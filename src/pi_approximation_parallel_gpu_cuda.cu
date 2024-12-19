// Aproximacao de PI (com animacao) - Versao Paralela em GPU com CUDA
// Demonstracao para Arquitetura de Sistemas de Computadores (ASC)
// Ciencias - ULisboa (2024/2025 - Semestre 1)
// @author: Ruben Andre Barreiro

// Importacao das bibliotecas necessarias

// Importacao do modulo de Graficos da biblioteca
// Simple and Fast Multimedia Library (SFML)
// ReSharper disable All
#include <SFML/Graphics.hpp>

// Importacao da biblioteca I/O Stream
// para escrita e leitura de dados
#include <iostream>

// Importacao da biblioteca String Stream
// para escrita de cadeias de caracteres (strings)
#include <sstream>

// Importacao da biblioteca principal
// do CUDA para programacao em GPU
#include <cuda.h>

// Importacao da biblioteca de Tempo de Execucao
// do CUDA para programacao em GPU
#include <cuda_runtime.h>

// Importacao da biblioteca da API
// de Tempo de Execucao do CUDA para programacao em GPU
#include <cuda_runtime_api.h>

// Importacao da biblioteca CURAND (CUDA RANDOM)
// para a geracao de numeros pseudo-aleatorios em GPU
#include <curand_kernel.h>


// Definicao/Re-Definicao das diretrizes em CUDA
// a serem usadas ao longo da execucao do programa
#ifndef __CUDACC__
    #define __device__
    #define __host__
    #define __global__
    #define __syncthreads()
    #define blockIdx (dim3{0,0,0})
    #define threadIdx (dim3{0,0,0})
    #define blockDim (dim3{0,0,0})
    #define gridDim (dim3{0,0,0})
#endif


// Definicao do kernel em CUDA para gerar os pontos pseudo-aleatoriamente e
// contar o numero de pontos pseudo-aleatorios que estao no interior da circunferencia
__global__ void generate_random_points_and_count_inside_circle(int* inside_circle_count,
                                                               double* x_points, double* y_points,
                                                               const bool is_partial,
                                                               const int CUDA_BLOCK_SIZE,
                                                               const int NUM_POINTS, const double RADIUS) {

    // Definicao de um bloco de dados partilhado no dispositivo (GPU)
    extern volatile __shared__ unsigned int cuda_block_shared_data[];


    // Definicao do indice do thread local lancado pelo dispositivo (GPU)
    unsigned int local_cuda_thread_idx =
        threadIdx.x;

    // Definicao do indice do bloco de dados lancado pelo dispositivo (GPU)
    unsigned int cuda_block_idx =
        blockIdx.x;

    // Definicao da dimensao da grelha de dados lancada pelo dispositivo (GPU)
    unsigned int cuda_grid_dim =
        gridDim.x;

    // Definicao do indice do thread global lancado pelo dispositivo (GPU)
    unsigned int global_cuda_thread_idx =
            ( ( cuda_block_idx * ( 2 * CUDA_BLOCK_SIZE ) ) +
                local_cuda_thread_idx );

    // Definicao do tamanho da grelha de dados lancada pelo dispositivo (GPU)
    unsigned int cuda_grid_size =
        ( 2 * CUDA_BLOCK_SIZE * cuda_grid_dim );


    // Inicializacao do bloco de dados partilhado no dispositivo (GPU)
    cuda_block_shared_data[local_cuda_thread_idx] = 0;


    // Se o indice do thread global lancado pelo dispositivo (GPU)
    // e menor que o numero total de pontos a serem gerados de forma
    // pseudo-aleatoria e se esta a ser tratada uma reducao parcial
    if(global_cuda_thread_idx < NUM_POINTS && is_partial) {

        // Definicao do estado de um gerador pseudo-aleatorio do CURAND
        curandState prng_state;

        // Definicao do gerador pseudo-aleatorio do CURAND,
        // para a geracao das coordenadas x e y dos pontos
        curand_init(clock(), global_cuda_thread_idx,
                    0, &prng_state);


        // Geracao pseudo-aleatoria da coordenadas x no intervalo [-RADIUS, RADIUS]
        const double x = -RADIUS + curand_uniform(&prng_state) * 2 * RADIUS;

        // Geracao pseudo-aleatoria da coordenadas y no intervalo [-RADIUS, RADIUS]
        const double y = -RADIUS + curand_uniform(&prng_state) * 2 * RADIUS;


        // Copia da coordenada pseudo-aleatoria x
        // do ponto (x,y) para a memoria do dispositivo (GPU)
        x_points[global_cuda_thread_idx] = x;

        // Copia da coordenada pseudo-aleatoria y
        // do ponto (x,y) para a memoria do dispositivo (GPU)
        y_points[global_cuda_thread_idx] = y;


        // Verificacao sobre se o ponto (x,y) gerado pseudo-aleatoriamente
        // esta no interior da circunferencia de raio RADIUS
        if (x * x + y * y <= RADIUS * RADIUS) {

            // Contagem do ponto interior a circunferencia de raio RADIUS
            inside_circle_count[global_cuda_thread_idx] += 1;

        }

    }

    // Sincronizacao dos CUDA threads lancados no dispositivo (GPU)
    __syncthreads();


    // Enquanto o indice do thread global lancado pelo dispositivo (GPU)
    // e menor que o numero maximo de pontos a serem gerados de forma pseudo-aleatoria
    while(global_cuda_thread_idx < NUM_POINTS) {

        // Calculo do indice do thread global lancado pelo dispositivo (GPU),
        // considerando um offset equivalente ao tamanho do bloco de dados
        // a ser considerado pelo dispositivo (GPU)
        unsigned int global_cuda_thread_idx_shifted_with_cuda_block_offset =
                ( global_cuda_thread_idx + CUDA_BLOCK_SIZE );

        // Reducao (soma) da contagem dos pontos interiores em relacao
        // ao indice do thread global lancado pelo dispositivo (GPU),
        // e ao mesmo em relacao a vizinhanca com offset do tamanho
        // do bloco de dados a ser considerado pelo dispositivo (GPU),
        // atualizando o bloco de dados partilhado no dispositivo (GPU)
        cuda_block_shared_data[local_cuda_thread_idx] +=
            inside_circle_count[global_cuda_thread_idx] +
                inside_circle_count[global_cuda_thread_idx_shifted_with_cuda_block_offset];

        // Soma do tamanho da grelha de dados a ser lancada pelo dispositivo (GPU)
        // ao indice do thread global lancado pelo dispositivo (GPU)
        global_cuda_thread_idx += cuda_grid_size;

    }

    // Sincronizacao dos CUDA threads lancados no dispositivo (GPU)
    __syncthreads();


    // Se o tamanho do bloco de dados a ser considerado
    // pelo dispositivo (GPU) e maior ou igual a 512
    if(CUDA_BLOCK_SIZE >= 512) {

        // Se o indice do thread local lancado
        // pelo dispositivo (GPU) e menor que 256
        if (local_cuda_thread_idx < 256) {

            // Reducao (soma) da contagem do bloco de dados partilhado
            // no dispositivo (GPU) em relacao a vizinhanca com offset 256
            cuda_block_shared_data[local_cuda_thread_idx] +=
                cuda_block_shared_data[local_cuda_thread_idx + 256];

        }

        // Sincronizacao dos CUDA threads lancados no dispositivo (GPU)
        __syncthreads();

    }

    // Se o tamanho do bloco de dados a ser considerado
    // pelo dispositivo (GPU) e maior ou igual a 256
    if(CUDA_BLOCK_SIZE >= 256) {

        // Se o indice do thread local lancado
        // pelo dispositivo (GPU) e menor que 128
        if (local_cuda_thread_idx < 128) {

            // Reducao (soma) da contagem do bloco de dados partilhado
            // no dispositivo (GPU) em relacao a vizinhanca com offset 128
            cuda_block_shared_data[local_cuda_thread_idx] +=
                cuda_block_shared_data[local_cuda_thread_idx + 128];

        }

        // Sincronizacao dos CUDA threads lancados no dispositivo (GPU)
        __syncthreads();

    }

    // Se o tamanho do bloco de dados a ser considerado
    // pelo dispositivo (GPU) e maior ou igual a 128
    if(CUDA_BLOCK_SIZE >= 128) {

        // Se o indice do thread local lancado
        // pelo dispositivo (GPU) e menor que 64
        if (local_cuda_thread_idx < 64) {

            // Reducao (soma) da contagem do bloco de dados partilhado
            // no dispositivo (GPU) em relacao a vizinhanca com offset 64
            cuda_block_shared_data[local_cuda_thread_idx] +=
                cuda_block_shared_data[local_cuda_thread_idx + 64];

        }

        // Sincronizacao dos CUDA threads lancados no dispositivo (GPU)
        __syncthreads();

    }


    // Se o indice do thread local lancado
    // pelo dispositivo (GPU) e menor que 32
    if (local_cuda_thread_idx < 32) {

        // Se o tamanho do bloco de dados a ser considerado
        // pelo dispositivo (GPU) e maior ou igual a 64
        if(CUDA_BLOCK_SIZE >= 64) {

            // Reducao (soma) da contagem do bloco de dados partilhado
            // no dispositivo (GPU) em relacao a vizinhanca com offset 32
            cuda_block_shared_data[local_cuda_thread_idx] +=
                cuda_block_shared_data[local_cuda_thread_idx + 32];

        }


        // Se o tamanho do bloco de dados a ser considerado
        // pelo dispositivo (GPU) e maior ou igual a 32
        if (CUDA_BLOCK_SIZE >= 32) {

            // Reducao (soma) da contagem do bloco de dados partilhado
            // no dispositivo (GPU) em relacao a vizinhanca com offset 16
            cuda_block_shared_data[local_cuda_thread_idx] +=
                cuda_block_shared_data[local_cuda_thread_idx + 16];

        }


        // Se o tamanho do bloco de dados a ser considerado
        // pelo dispositivo (GPU) e maior ou igual a 16
        if (CUDA_BLOCK_SIZE >= 16) {

            // Reducao (soma) da contagem do bloco de dados partilhado
            // no dispositivo (GPU) em relacao a vizinhanca com offset 8
            cuda_block_shared_data[local_cuda_thread_idx] +=
                cuda_block_shared_data[local_cuda_thread_idx + 8];

        }


        // Se o tamanho do bloco de dados a ser considerado
        // pelo dispositivo (GPU) e maior ou igual a 8
        if (CUDA_BLOCK_SIZE >= 8) {

            // Reducao (soma) da contagem do bloco de dados partilhado
            // no dispositivo (GPU) em relacao a vizinhanca com offset 4
            cuda_block_shared_data[local_cuda_thread_idx] +=
                cuda_block_shared_data[local_cuda_thread_idx + 4];

        }


        // Se o tamanho do bloco de dados a ser considerado
        // pelo dispositivo (GPU) e maior ou igual a 4
        if (CUDA_BLOCK_SIZE >= 4) {

            // Reducao (soma) da contagem do bloco de dados partilhado
            // no dispositivo (GPU) em relacao a vizinhanca com offset 2
            cuda_block_shared_data[local_cuda_thread_idx] +=
                cuda_block_shared_data[local_cuda_thread_idx + 2];

        }


        // Se o tamanho do bloco de dados a ser considerado
        // pelo dispositivo (GPU) e maior ou igual a 2
        if (CUDA_BLOCK_SIZE >= 2) {

            // Reducao (soma) da contagem do bloco de dados partilhado
            // no dispositivo (GPU) em relacao a vizinhanca com offset 1
            cuda_block_shared_data[local_cuda_thread_idx] +=
                cuda_block_shared_data[local_cuda_thread_idx + 1];

        }

    }


    // Se o indice do thread local lancado pelo dispositivo (GPU)
    // corresponde ao primeiro thread local lancado
    if (local_cuda_thread_idx == 0) {

        // Reducao da contagem de um ponto interior a circunferencia
        // em relacao ao bloco de dados partilhado no dispositivo (GPU)
        inside_circle_count[blockIdx.x] =
            cuda_block_shared_data[0];

    }

}


// Definicao da funcao principal (main) do programa
int main() {

    // Definicao de algumas configuracoes
    // iniciais para o programa

    // Definicao da constante para guardar
    // o numero maximo de pontos que podem ser gerados
    constexpr int NUM_MAX_POINTS = 400000;

    // Definicao da constante para guardar
    // o valor real de PI
    constexpr double PI_REAL = 3.14159;

    // Definicao da constante para guardar
    // o raio da circunferencia
    constexpr float RADIUS = 2.0;

    // Definicao do tamanho do bloco de dados
    // a ser considerado pelo dispositivo (GPU)
    constexpr int CUDA_BLOCK_SIZE = 256;

    // Definicao do tamanho da grelha de dados
    // a ser considerada pelo dispositivo (GPU)
    const int CUDA_GRID_SIZE =
        ceil( static_cast<double>(NUM_MAX_POINTS) / CUDA_BLOCK_SIZE );


    // Alocacao de memoria no host (CPU) para as coordenadas x
    // dos pontos a serem gerados de forma pseudo-aleatoria
    auto* x_points_host_cpu = new double[NUM_MAX_POINTS];

    // Alocacao de memoria no host (CPU) para as coordenadas y
    // dos pontos a serem gerados de forma pseudo-aleatoria
    auto* y_points_host_cpu = new double[NUM_MAX_POINTS];

    // Definicao do numero de pontos interiores a circunferencia
    // a serem contabilizados na memoria do host (CPU)
    auto num_points_inside_circle_host_cpu =
        static_cast<int *>( malloc( sizeof(int) ) );


    // Definicao das coordenadas x dos pontos a serem gerados
    // de forma pseudo-aleatoria na memoria do dispositivo (GPU)
    double* x_points_device_gpu;

    // Definicao das coordenadas y dos pontos a serem gerados
    // de forma pseudo-aleatoria na memoria do dispositivo (GPU)
    double* y_points_device_gpu;

    // Definicao do numero de pontos interiores a circunferencia
    // a serem contabilizados na memoria do dispositivo (GPU)
    int* num_points_inside_circle_device_gpu;


    // Alocacao de memoria no dispositivo (GPU) para as coordenadas x
    // dos pontos a serem gerados de forma pseudo-aleatoria
    cudaMalloc(reinterpret_cast<void **>(&x_points_device_gpu),
               NUM_MAX_POINTS * sizeof(double));

    // Alocacao de memoria no dispositivo (GPU) para as coordenadas y
    // dos pontos a serem gerados de forma pseudo-aleatoria
    cudaMalloc(reinterpret_cast<void **>(&y_points_device_gpu),
               NUM_MAX_POINTS * sizeof(double));

    // Alocacao de memoria no dispositivo (GPU) para o numero
    // de pontos interiores a circunferencia a serem contabilizados
    cudaMalloc(reinterpret_cast<void **>(&num_points_inside_circle_device_gpu),
               NUM_MAX_POINTS * sizeof(int));


    // Inicializacao do valor a 0 para o numero de pontos
    // interiores a circunferencia a serem contabilizados
    // na memoria do dispositivo (GPU)
    cudaMemset(num_points_inside_circle_device_gpu,
               0, NUM_MAX_POINTS * sizeof(int));


    // Chamada ao kernel em CUDA para gerar os pontos pseudo-aleatoriamente e
    // contar o numero de pontos pseudo-aleatorios que estao no interior
    // da circunferencia, considerando um padrao de reducao parcial
    // NOTA: Os numeros pseudo-aleatorios so sao gerados nas reducoes parciais
    generate_random_points_and_count_inside_circle
            <<<CUDA_GRID_SIZE, CUDA_BLOCK_SIZE, ( CUDA_BLOCK_SIZE * sizeof( int ) ) >>>
              (num_points_inside_circle_device_gpu,
               x_points_device_gpu, y_points_device_gpu,
               true, CUDA_BLOCK_SIZE,
               NUM_MAX_POINTS, RADIUS);


    // Sincronizacao dos CUDA threads lancados pelo dispositivo (GPU)
    cudaDeviceSynchronize();


    // Chamada ao kernel em CUDA para gerar os pontos pseudo-aleatoriamente e
    // contar o numero de pontos pseudo-aleatorios que estao no interior
    // da circunferencia, considerando um padrao de reducao final
    // (considerando os numeros pseudo-aleatorios gerados anteriormente)
    // NOTA: Os numeros pseudo-aleatorios so sao gerados nas reducoes parciais
    generate_random_points_and_count_inside_circle
            <<<1, CUDA_BLOCK_SIZE, ( CUDA_BLOCK_SIZE * sizeof( int ) ) >>>
              (num_points_inside_circle_device_gpu,
               x_points_device_gpu, y_points_device_gpu,
               false, CUDA_BLOCK_SIZE,
               NUM_MAX_POINTS, RADIUS);


    // Copia as coordenadas x dos pontos gerados anteriormente
    // de forma pseudo-aleatoria na memoria do dispositivo (GPU)
    // para a memoria do host (CPU)
    cudaMemcpy(x_points_host_cpu, x_points_device_gpu,
               NUM_MAX_POINTS * sizeof(double),
               cudaMemcpyDeviceToHost);

    // Copia as coordenadas y dos pontos gerados anteriormente
    // de forma pseudo-aleatoria na memoria do dispositivo (GPU)
    // para a memoria do host (CPU)
    cudaMemcpy(y_points_host_cpu, y_points_device_gpu,
               NUM_MAX_POINTS * sizeof(double),
               cudaMemcpyDeviceToHost);

    // Copia o numero de pontos interiores a circunferencia
    // contabilizados na memoria do dispositivo (GPU)
    // para a memoria do host (CPU)
    cudaMemcpy(&num_points_inside_circle_host_cpu[0],
               &num_points_inside_circle_device_gpu[0],
               sizeof(int), cudaMemcpyDeviceToHost);


    // Inicialização do vetor de pontos interiores a circunferencia
    std::vector<sf::CircleShape> inside_points;

    // Inicialização do vetor de pontos exteriores a circunferencia
    std::vector<sf::CircleShape> outside_points;


    // Criar a janela de renderizacao para a aproximacao de PI,
    // usando a biblioteca Simple and Fast Multimedia Library (SFML)
    sf::RenderWindow window(sf::VideoMode(800, 600),
                            "Aproximacao de PI - Animacao "
                            "(Versao Paralela em GPU com CUDA)");

    // Desenho da circunferencia com o raio associado
    // (representando a area da aproximacao de PI),
    // usando um factor de 100 para ajustar
    // o tamanho da circunferencia
    sf::CircleShape circle(RADIUS * 100);

    // Centralizar a circunferencia na disposicao da janela
    circle.setPosition(400 - RADIUS * 100, 300 - RADIUS * 100);

    // Definicao da cor interior como transparente
    circle.setFillColor(sf::Color::Transparent);

    // Definicao da cor da linha exterior (contorno)
    // da circunferencia como preto
    circle.setOutlineColor(sf::Color::Black);

    // Definicao da expessura da linha exterior (contorno)
    // da circunferencia com um factor de 2
    circle.setOutlineThickness(2);


    // Criacao da fonte (tipo de letra) para o texto
    // a definir para a exibicao da estimativa de PI
    sf::Font font;

    // Se nao e possivel carregar a fonte (tipo de letra) para o texto
    // a definir para a exibicao da estimativa de PI, como Arial
    if(!font.loadFromFile("fonts/arial.ttf")) {

        // Criacao de uma cadeia de caracteres (string)
        // para o erro respetivo ao carregamento
        // da fonte (tipo de letra)
        std::cerr << "Falha ao carregar a fonte!" << std::endl;

        // Retorno do valor de flag (etiqueta) a -1 (erro)
        return -1;

    }


    // Criacao de um texto para a informacao
    // sobre a aproximacao de PI
    sf::Text pi_approx_text;

    // Definicao da fonte (tipo de letra) para
    // o texto da informacao sobre a aproximacao de PI
    pi_approx_text.setFont(font);

    // Definicao do tamanho do caracter do texto
    // para a informacao sobre a aproximacao de PI
    pi_approx_text.setCharacterSize(24);

    // Definicao da cor do texto (preto)
    // para a informacao sobre a aproximacao de PI
    pi_approx_text.setFillColor(sf::Color::Black);

    // Definicao da posicao na janela do texto
    // para a informacao sobre a aproximacao de PI
    pi_approx_text.setPosition(10, 520);


    // Criacao de um texto para a informacao
    // sobre o valor real de PI
    sf::Text pi_real_text;

    // Definicao da fonte (tipo de letra) para
    // o texto da informacao sobre o valor real de PI
    pi_real_text.setFont(font);

    // Definicao do tamanho do caracter do texto
    // para a informacao sobre o valor real de PI
    pi_real_text.setCharacterSize(24);

    // Definicao da cor do texto (preto)
    // para a informacao sobre o valor real de PI
    pi_real_text.setFillColor(sf::Color::Black);

    // Definicao da posicao na janela do texto
    // para a informacao sobre o valor real de PI
    pi_real_text.setPosition(10, 550);


    // Definicao do indice correspondente ao ponto atual gerado
    unsigned int current_point = 0;

    // Definicao do valor da aproximacao de PI atual gerada
    double pi_approx = 0.0;


    // Enquanto a janela estiver aberta e nao tenham sido
    // gerados o numero maximo de pontos que podem ser gerados e
    // a aproximacao de PI for diferente do valor real de PI
    while (window.isOpen() && current_point < NUM_MAX_POINTS &&
           pi_approx != PI_REAL) {

        // Para cada ponto a serem gerado por cada batch (lote)
        // associado aos threads lancados pelo dispositivo (GPU)
        for (int i = 0; i < NUM_MAX_POINTS; i++) {

            // Definicao do ponto base a desenhar na tela
            sf::CircleShape point(1);

            // Definicao (e escala) do ponto base a desenhar na tela
            point.setPosition(static_cast<float>(400 + x_points_host_cpu[i] * 100),
                              static_cast<float>(300 + y_points_host_cpu[i] * 100));


            // Se o ponto atual gerado esta dentro da circunferencia
            // (ou seja, o ponto atual gerado e um ponto interno)
            if (x_points_host_cpu[i] * x_points_host_cpu[i] +
                y_points_host_cpu[i] * y_points_host_cpu[i] <= RADIUS * RADIUS) {

                // Definicao da cor do ponto interno como verde
                point.setFillColor(sf::Color::Green);

                // Adicao do ponto atual gerado ao vetor
                // de pontos interiores a circunferencia
                inside_points.push_back(point);

            }
            else {

                // Definicao da cor do ponto externo como vermelho
                point.setFillColor(sf::Color::Red);

                // Adicao do ponto atual gerado ao vetor
                // de pontos exteriores a circunferencia
                outside_points.push_back(point);

            }

        }

        // Soma do indice correspondente ao ponto atual gerado,
        // tendo em consideracao o numero de pontos gerados local
        current_point += NUM_MAX_POINTS;

        // Atualizacao da aproximacao de PI atual,
        // considerando o ponto atual gerado
        pi_approx = 4.0 * num_points_inside_circle_host_cpu[0] / current_point;



        // Criacao de um evento no contexto da biblioteca
        // Simple and Fast Multimedia Library (SFML)
        sf::Event event{};


        // Enquanto a janela espera por um evento
        // (definicao de um "escutador" de eventos)
        while (window.pollEvent(event)) {

            // Se o evento "escutado" for do tipo "fecho"
            if (event.type == sf::Event::Closed) {

                // Fecho da janela criada anteriormente
                window.close();

            }

        }


        // Limpeza da janela e definicao da cor
        // para a janela como branco
        window.clear(sf::Color::White);


        // Definicao do Stream de Cadeia de Caracteres (String)
        // para a aproximacao de PI
        std::stringstream pi_approx_string_stream;

        // Definicao do Stream de Cadeia de Caracteres (String)
        // para o valor real de PI
        std::stringstream pi_real_string_stream;

        // Definicao de escrita do texto da aproximacao de PI,
        // usando o canal de I/O definido anterior
        pi_approx_string_stream << "Estimativa/Aproximacao de PI: "
                                << pi_approx;


        // Definicao de escrita do texto do valor real de PI,
        // usando o canal de I/O definido anterior
        pi_real_string_stream << "Valor Real de PI: "
                              << PI_REAL;


        // Definicao da cadeia de caracteres (String)
        // com o texto da aproximacao de PI, atraves
        // do canal de I/O definido anterior
        pi_approx_text.setString(pi_approx_string_stream.str());

        // Definicao da cadeia de caracteres (String)
        // com o texto do valor real de PI, atraves
        // do canal de I/O definido anterior
        pi_real_text.setString(pi_real_string_stream.str());


        // Para todos os pontos internos a circunferencia
        for (const auto& inside_point : inside_points) {

            // Desenho do ponto atual interno a circunferencia
            window.draw(inside_point);

        }


        // Para todos os pontos externos a circunferencia
        for (const auto& outside_point : outside_points) {

            // Desenho do ponto atual externo a circunferencia
            window.draw(outside_point);

        }


        // Desenho da circunferencia
        window.draw(circle);


        // Desenho do texto para a aproximacao de PI
        window.draw(pi_approx_text);

        // Desenho do texto para o valor real de PI
        window.draw(pi_real_text);


        // Exibicao de todos os graficos definidos
        // anteriormente na janela correspondente
        window.display();


        // Espera de um pequeno tempo antes de adicionar
        // o ponto atual gerado (para efeitos de animacao)
        // NOTA: E possivel ajustar o valor para controlar
        //       a velocidade da animacao (valor por defeito: 1 ms)
        sleep(sf::milliseconds(1));

    }


    // Remove a memoria alocada no host (CPU) para as coordenadas x
    // dos pontos a serem gerados de forma pseudo-aleatoria
    delete[] x_points_host_cpu;

    // Remove a memoria alocada no host (CPU) para as coordenadas y
    // dos pontos a serem gerados de forma pseudo-aleatoria
    delete[] y_points_host_cpu;


    // Remove a memoria alocada no dispositivo (GPU) para as coordenadas x
    // dos pontos a serem gerados de forma pseudo-aleatoria
    cudaFree(x_points_device_gpu);

    // Remove a memoria alocada no dispositivo (GPU) para as coordenadas y
    // dos pontos a serem gerados de forma pseudo-aleatoria
    cudaFree(y_points_device_gpu);


    // Remove a memoria alocada no dispositivo (GPU) para o numero de
    // pontos interiores a circunferencia a serem contabilizados
    cudaFree(num_points_inside_circle_device_gpu);


    // Impressao da estimativa/aproximacao de PI
    printf("Estimativa/Aproximacao de PI: %f\n", pi_approx);

    // Impressao do valor real de PI
    printf("Valor Real de PI: %f\n", PI_REAL);


    // Retorno do valor de flag (etiqueta) a 1 (sucesso)
    return 0;

}
