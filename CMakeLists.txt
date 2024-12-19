cmake_minimum_required(VERSION 3.29)
project(Pi_Approximation__High_Performance_Computing_)
enable_language(CUDA)

set(CMAKE_CXX_STANDARD 20)

find_package(CUDAToolkit REQUIRED)
include_directories("${CUDA_INCLUDE_DIRS}")

add_executable(Pi_Approximation__High_Performance_Computing_
        src/pi_approximation_sequential_cpu.cpp
        src/pi_approximation_parallel_cpu_openmp.cpp
        src/pi_approximation_parallel_gpu_cuda.cu
)