// Aproximacao de PI (com animacao) - Versao Sequencial
// Demonstracao para Arquitetura de Sistemas de Computadores (ASC)
// Ciencias - ULisboa (2024/2025 - Semestre 1)
// @author: Ruben Andre Barreiro

// Importacao das bibliotecas necessarias

// Importacao do modulo de Graficos da biblioteca
// Simple and Fast Multimedia Library (SFML)
#include <SFML/Graphics.hpp>

// Importacao da biblioteca I/O Stream
// para escrita e leitura de dados
#include <iostream>

// Importacao da biblioteca Random
// para a geracao de numeros pseudo-aleatorios
#include <random>

// Importacao da biblioteca Vector
// para a criacao e gestao de vetores
#include <vector>

// Importacao da biblioteca String Stream
// para escrita de cadeias de caracteres (strings)
#include <sstream>


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

    // Inicialização do vetor de pontos interiores a circunferencia
    std::vector<sf::CircleShape> inside_points;

    // Inicialização do vetor de pontos exteriores a circunferencia
    std::vector<sf::CircleShape> outside_points;


    // Inicializacao do gerador de numeros pseudo-aleatorios
    std::random_device pseudo_rand;

    // Configuracao do gerador de numeros pseudo-aleatorios
    // baseados em Mersenne Twister com periodos longos de 2^(19.937)-1
    std::mt19937 gen(pseudo_rand());

    // Criacao de uma distribuicao uniform de valores pseudo-aleatorios
    // no intervalo [-r, r], onde r e o raio da circunferencia
    std::uniform_real_distribution<> dis(-RADIUS, RADIUS);

    // Criacao de um contador, para os pontos gerados
    // que estao dentro da circunferencia
    int inside_circle = 0;

    // Criar a janela de renderizacao para a aproximacao de PI,
    // usando a biblioteca Simple and Fast Multimedia Library (SFML)
    sf::RenderWindow window(sf::VideoMode(800, 600),
                                          "Aproximacao de PI - Animacao "
                                          "(Versao Sequencial em CPU)");

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
    int current_point = 0;

    // Definicao do valor da aproximacao de PI atual gerada
    double pi_approx = 0.0;


    // Enquanto a janela estiver aberta e nao tenham sido
    // gerados o numero maximo de pontos que podem ser gerados e
    // a aproximacao de PI for diferente do valor real de PI
    while(window.isOpen() && current_point < NUM_MAX_POINTS &&
          pi_approx != PI_REAL) {

        // Criacao de um evento no contexto da biblioteca
        // Simple and Fast Multimedia Library (SFML)
        sf::Event event{};


        // Enquanto a janela espera por um evento
        // (definicao de um "escutador" de eventos)
        while(window.pollEvent(event)) {

            // Se o evento "escutado" for do tipo "fecho"
            if (event.type == sf::Event::Closed) {

                // Fecho da janela criada anteriormente
                window.close();

            }

        }


        // Limpeza da janela e definicao da cor
        // para a janela como branco
        window.clear(sf::Color::White);


        // Geracao da coordenada x para um novo ponto
        // gerado de forma uniformemente distribuida
        double x = dis(gen);

        // Geracao da coordenada y para um novo ponto
        // gerado de forma uniformemente distribuida
        double y = dis(gen);


        // Definicao do ponto base a desenhar na tela
        sf::CircleShape point(1);

        // Definicao (e escala) do ponto base a desenhar na tela
        point.setPosition(static_cast<float>(400 + x * 100),
                          static_cast<float>(300 + y * 100));


        // Se o ponto atual gerado esta dentro da circunferencia
        // (ou seja, o ponto atual gerado e um ponto interno)
        if (x * x + y * y <= RADIUS * RADIUS) {

            // Definicao da cor do ponto interno como verde
            point.setFillColor(sf::Color::Green);

            // Adicao do ponto atual gerado ao vetor
            // de pontos interiores a circunferencia
            inside_points.push_back(point);

            // Incremento do contador para os pontos gerados
            // que estao dentro da circunferencia
            inside_circle++;

        }
        // Se o ponto atual gerado nao esta dentro da circunferencia
        // (ou seja, o ponto atual gerado e um ponto externo)
        else {

            // Definicao da cor do ponto externo como vermelho
            point.setFillColor(sf::Color::Red);

            // Adicao do ponto atual gerado ao vetor
            // de pontos exteriores a circunferencia
            outside_points.push_back(point);

        }


        // Atualizacao da aproximacao de PI atual,
        // considerando o ponto atual gerado
        pi_approx = 4.0 * inside_circle / (current_point + 1);

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


        // Incremento do indice correspondente ao ponto atual gerado
        current_point++;

    }


    // Impressao da estimativa/aproximacao de PI
    printf("Estimativa/Aproximacao de PI: %f\n", pi_approx);

    // Impressao do valor real de PI
    printf("Valor Real de PI: %f\n", PI_REAL);


    // Retorno do valor de flag (etiqueta) a 1 (sucesso)
    return 0;

}