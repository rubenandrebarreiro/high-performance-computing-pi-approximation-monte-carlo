# High-Performance Computing (HPC):<br>&nbsp;&#8226; Pi Approximation by Monte Carlo

![https://raw.githubusercontent.com/rubenandrebarreiro/high-performance-computing-pi-approximation-monte-carlo/master/imgs/JPGs/banner-1.jpg](https://raw.githubusercontent.com/rubenandrebarreiro/high-performance-computing-pi-approximation-monte-carlo/master/imgs/JPGs/banner-1.jpg)
###### High-Performance Computing (HPC): Pi Approximation by Monte Carlo - Banner #1

***

## Current Status
[![contributor for this repository](https://img.shields.io/badge/contributor-rubenandrebarreiro-blue.svg)](https://github.com/rubenandrebarreiro/) [![developed in](https://img.shields.io/badge/developed&nbsp;in-ciencias&nbsp;ulisboa-blue.svg)](https://ciencias.ulisboa.pt/)
[![current version](https://img.shields.io/badge/version-1.0-magenta.svg)](https://github.com/rubenandrebarreiro/high-performance-computing-pi-approximation-monte-carlo/)

[![status of this version no. 1](https://img.shields.io/badge/status-completed-orange.svg)](https://github.com/rubenandrebarreiro/high-performance-computing-pi-approximation-monte-carlo/)
[![status of this version no. 2](https://img.shields.io/badge/status-final-orange.svg)](https://github.com/rubenandrebarreiro/high-performance-computing-pi-approximation-monte-carlo/)
[![status of this version no. 3](https://img.shields.io/badge/status-stable-orange.svg)](https://github.com/rubenandrebarreiro/high-performance-computing-pi-approximation-monte-carlo/)
[![status of this version no. 4](https://img.shields.io/badge/status-documented-orange.svg)](https://github.com/rubenandrebarreiro/high-performance-computing-pi-approximation-monte-carlo/)

[![keyword of this version no. 1](https://img.shields.io/badge/keyword-high&nbsp;performance&nbsp;computing-brown.svg)](https://github.com/rubenandrebarreiro/high-performance-computing-pi-approximation-monte-carlo/)
[![keyword of this version no. 2](https://img.shields.io/badge/keyword-pi&nbsp;approximation-brown.svg)](https://github.com/rubenandrebarreiro/high-performance-computing-pi-approximation-monte-carlo/)
[![keyword of this version no. 3](https://img.shields.io/badge/keyword-monte&nbsp;carlo-brown.svg)](https://github.com/rubenandrebarreiro/high-performance-computing-pi-approximation-monte-carlo/)
[![keyword of this version no. 4](https://img.shields.io/badge/keyword-c&nbsp;plus&nbsp;plus-brown.svg)](https://github.com/rubenandrebarreiro/high-performance-computing-pi-approximation-monte-carlo/)
[![keyword of this version no. 5](https://img.shields.io/badge/keyword-openmp-brown.svg)](https://github.com/rubenandrebarreiro/high-performance-computing-pi-approximation-monte-carlo/)
[![keyword of this version no. 6](https://img.shields.io/badge/keyword-cuda-brown.svg)](https://github.com/rubenandrebarreiro/high-performance-computing-pi-approximation-monte-carlo/)

[![technology used no. 1](https://img.shields.io/badge/built&nbsp;with-cuda-red.svg)](https://developer.nvidia.com/cuda-zone) 
[![technology used no. 2](https://img.shields.io/badge/built&nbsp;with-openmp-red.svg)](https://www.openmp.org/) 
[![technology used no. 3](https://img.shields.io/badge/built&nbsp;with-c++-red.svg)](http://www.cplusplus.com/) 
[![technology used no. 4](https://img.shields.io/badge/built&nbsp;with-c-red.svg)](https://en.wikipedia.org/wiki/C_(programming_language))
[![technology used no. 5](https://img.shields.io/badge/built&nbsp;with-cmake-red.svg)](https://cmake.org/) 
[![software used no. 1](https://img.shields.io/badge/software-jetbrains&nbsp;clion-gold.svg)](https://www.jetbrains.com/clion/)

[![star this repository](http://githubbadges.com/star.svg?user=rubenandrebarreiro&repo=high-performance-computing-pi-approximation-monte-carlo&style=flat)](https://github.com/rubenandrebarreiro/high-performance-computing-pi-approximation-monte-carlo/stargazers)
[![fork this repository](http://githubbadges.com/fork.svg?user=rubenandrebarreiro&repo=high-performance-computing-pi-approximation-monte-carlo&style=flat)](https://github.com/rubenandrebarreiro/high-performance-computing-pi-approximation-monte-carlo/fork)
[![downloads of this repository](https://img.shields.io/github/downloads/rubenandrebarreiro/gpu-cuda-self-organising-maps/total.svg)](https://github.com/rubenandrebarreiro/high-performance-computing-pi-approximation-monte-carlo/archive/master.zip)
[![price of this project](https://img.shields.io/badge/price-free-success.svg)](https://github.com/rubenandrebarreiro/high-performance-computing-pi-approximation-monte-carlo/archive/master.zip)


##### Current Progress of the Project

[![current progress of this project](http://progressed.io/bar/100?title=&nbsp;completed&nbsp;)](https://github.com/rubenandrebarreiro/high-performance-computing-pi-approximation-monte-carlo/) 


## Description

> TBD.

> **IMPORTANT**
>
> ##### &nbsp;&nbsp;&#8226; This practical High-Performance Computing (HPC) demonstration was built<br>&nbsp;&nbsp;&nbsp;&nbsp;for the practical laboratory classes of the [Computer Systems Architectures](https://fenix.ciencias.ulisboa.pt/courses/asc-2254879305242433)<br>&nbsp;&nbsp;&nbsp;&nbsp;(Fall Semester - 2024-2025 academic year), at [Ci&#234;ncias - ULisboa](https://ciencias.ulisboa.pt/) of [University of Lisbon](https://www.ulisboa.pt/),<br>&nbsp;&nbsp;&nbsp;&nbsp;between December 10, 2024, and December 20, 2024. ⚠️

### What are Monte Carlo methods?

> * Numerical computing techniques that use random simulations to<br>solve mathematical problems that may be difficult or impossible to solve.

### What is the Monte Carlo approximation of π?

> * A technique that uses the generation of (pseudo or truly) random numbers to<br>estimate π, relating the area of ​​a circumference and a square.

### How does the Monte Carlo approximation of &#960; work?

> ***1. Definition of Cartesian Space:***
>    * Considers a circumference with radius <i>r</i> and a square with side <i>2 &#215; r</i>.

> ***2. Generation of (Pseudo or Truly) Random Points:***
>    * Generation of <i>N<sub>total</sub></i> (pseudo or truly) random points (<i>x</i>,<i>y</i>) in the interval [-<i>r</i>,<i>r</i>].

> ***3. Counting the Points inside the Circumference:***
>    * Counting the <i>N</i> points (<i>x,y</i>) that are inside the circumference, checking the condition <i>x</i><sup>2</sup> + <i>y</i><sup>2</sup> &le; <i>r</i>.

> ***4. Calculation of the Approximation of &#960;:***
>    * We know that the areas of the square and the circumference are given by:
>      * <i>A<sub>square</sub></i> = (<i>2</i> &#215; <i>r</i>) × (<i>2</i> &#215; <i>r</i>) = (<i>2</i> &#215; <i>r</i>)<sup>2</sup> = 4 &#215; <i>r<sup>2</sup></i>
>      * <i>A<sub>circumference</sub></i> = <i>&#960;</i> &#215; <i>r<sup>2</sup></i>
>    * We can approximate the rate of the number of points inside the circumference given by<br>N<sub>circumference</sub>/N<sub>total</sub> to the value of <i>&#960;</i> / <i>4</i> as follows:
>      * <i>N<sub>circumference</sub></i> / <i>N<sub>total</sub></i> < (<i>A<sub>circumference</sub></i> / <i>A<sub>square</sub></i>) = (&#960; &#215; <i>r<sup>2</sup></i>) / (<i>4</i> &#215; <i>r<sup>2</sup></i>) = <i>&#960;</i> / <i>4</i>
>    * Therefore, we can calculate <i>&#960;</i> approximately as <i>&#960;</i> &asymp; <i>4</i> &#215; (<i>N<sub>circumference</sub></i> / <i>N<sub>total</sub></i>).

### Sequential Programs vs. Parallel Programs

> ***Sequential Programs:***
> * Instructions executed in a specific order.
> * Each instruction depends on the completion of the previous instruction.
> * Performance depends on the speed of the CPU and the number of instructions.

> ***Parallel Programs:***
> * Instructions can be executed simultaneously and independently.
> * Dividing tasks into several smaller subtasks per worker (thread).
> * (Better) performance for tasks divided into independent subtasks.

***

## Instructions

> ***Edit, compile, and run the sequential version (single CPU worker)***
> * To compile the program, type the following command in the terminal:
> ```
> g++ -std=c++11 pi_approximation_sequential_cpu.cpp -o pi_approximation_sequential_cpu -lsfml-graphics -lsfml-window -lsfml-system
> ```
>
> * To edit the program, type the following command in the terminal:
> ```
> gedit pi_approximation_sequential_cpu.cpp
> ```
>
> * To run the program, type the following command in the terminal:
> ```
> ./pi_approximation_sequential_cpu
> ```

> ***Edit, compile, and run the parallel version (multiple CPU workers)***
> * To compile the program, type the following command in the terminal:
> ```
> g++ -fopenmp -std=c++11 pi_approximation_parallel_cpu_openmp.cpp -o pi_approximation_parallel_cpu_openmp -lsfml-graphics -lsfml-window -lsfml-system
> ```
>
> * To edit the program, type the following command in the terminal:
> ```
> gedit pi_approximation_parallel_cpu_openmp.cpp
> ```
> 
> * To run the program, type the following command in the terminal:
> ```
> ./pi_approximation_parallel_cpu_openmp
> ```

> ***Edit, compile, and run the parallel version (multiple GPU workers)***
> * To compile the program, type the following command in the terminal:
> ```
> nvcc -std=c++11 pi_approximation_parallel_gpu_cuda.cu -o pi_approximation_parallel_gpu_cuda -lsfml-graphics -lsfml-window -lsfml-system -lcurand
> ```
>
> * To edit the program, type the following command in the terminal:
> ```
> gedit pi_approximation_parallel_gpu_cuda.cu
> ```
> 
> * To run the program, type the following command in the terminal:
> ```
> ./pi_approximation_parallel_gpu_cuda
> ```

> **IMPORTANT**
>
> ##### &nbsp;&nbsp;&#8226; The source code and executable files are located on _./src_ folder. ⚠️

***

## Screenshots

![https://raw.githubusercontent.com/rubenandrebarreiro/high-performance-computing-pi-approximation-monte-carlo/master/imgs/JPGs/screenshot-1.jpg](https://raw.githubusercontent.com/rubenandrebarreiro/high-performance-computing-pi-approximation-monte-carlo/master/labs/screenshots/jpgs/screenshot-1.jpg)
###### High-Performance Computing (HPC): Pi Approximation by Monte Carlo's Screenshot #1

***

![https://raw.githubusercontent.com/rubenandrebarreiro/high-performance-computing-pi-approximation-monte-carlo/master/imgs/JPGs/screenshot-2.jpg](https://raw.githubusercontent.com/rubenandrebarreiro/high-performance-computing-pi-approximation-monte-carlo/master/labs/screenshots/jpgs/screenshot-2.jpg)
###### High-Performance Computing (HPC): Pi Approximation by Monte Carlo's Screenshot #2

***

## Getting Started

### Prerequisites
To install and run this application, you will need:
> The [**_Git_**](https://git-scm.com/) feature and/or a [**_third-party Git Client based GUI_**](https://git-scm.com/downloads/guis/), like:
* [**_GitHub Desktop_**](https://desktop.github.com/), [**_GitKraken_**](https://www.gitkraken.com/), [**_SourceTree_**](https://www.sourcetreeapp.com/) or [**_TortoiseGit_**](https://tortoisegit.org/).

### Installation
To install this application, you will only need to _download_ or _clone_ this repository and run the application locally:

> You can do it downloading the [**_.zip file_**](https://github.com/rubenandrebarreiro/high-performance-computing-pi-approximation-monte-carlo/archive/master.zip) in download section of this repository.

> Or instead, by cloning this repository by a [**_Git Client based GUI_**](https://git-scm.com/downloads/guis), using [**_HTTPS_**](https://en.wikipedia.org/wiki/HTTPS) or [**_SSH_**](https://en.wikipedia.org/wiki/SSH_File_Transfer_Protocol), by one of the following link:
* [**_HTTPS_**](https://en.wikipedia.org/wiki/HTTPS):
```
https://github.com/rubenandrebarreiro/high-performance-computing-pi-approximation-monte-carlo.git
```
* [**_SSH_**](https://en.wikipedia.org/wiki/SSH_File_Transfer_Protocol):
```
git@github.com:rubenandrebarreiro/high-performance-computing-pi-approximation-monte-carlo.git
```

> Or even, by running one of the following commands in a **_Git Bash Console_**:
* [**_HTTPS_**](https://en.wikipedia.org/wiki/HTTPS):
```
git clone https://github.com/rubenandrebarreiro/high-performance-computing-pi-approximation-monte-carlo.git
```
* [**_SSH_**](https://en.wikipedia.org/wiki/SSH_File_Transfer_Protocol):
```
git clone git@github.com:rubenandrebarreiro/high-performance-computing-pi-approximation-monte-carlo.git
```

## Built with
* [**_JetBrains - CLion_**](https://www.jetbrains.com/clion/)
* [**_C++_**](http://www.cplusplus.com/)
* [**_C_**](https://en.wikipedia.org/wiki/C_(programming_language))
* [**_OpenMP_**](https://www.openmp.org/) 
* [**_CUDA_**](https://developer.nvidia.com/cuda-zone)
* [**_CMake_**](https://cmake.org/)

## Contributors

> [Rúben André Barreiro](https://github.com/rubenandrebarreiro/)

## Contacts

### Rúben André Barreiro
#### E-mails
* [ruben.andre.letra.barreiro@tecnico.ulisboa.pt](mailto:ruben.andre.letra.barreiro@tecnico.ulisboa.pt)
* [rabarreiro@ciencias.ulisboa.pt](mailto:rabarreiro@ciencias.ulisboa.pt)
* [ruben.andre.letra.barreiro@gmail.com](mailto:ruben.andre.letra.barreiro@gmail.com)
* [ruben.andre.letra.barreiro@yahoo.com](mailto:ruben.andre.letra.barreiro@yahoo.com)

## Portfolios/Blogs and Git Hosting/Repository Services

### Rúben André Barreiro
#### GitHub's Portfolio/Personal Blog
* [https://rubenandrebarreiro.github.io/](https://rubenandrebarreiro.github.io/)

#### Hosting/Repository Services
* [https://github.com/rubenandrebarreiro/](https://github.com/rubenandrebarreiro/)
* [https://gitlab.com/rubenandrebarreiro/](https://gitlab.com/rubenandrebarreiro/)
* [https://bitbucket.org/rubenandrebarreiro/](https://bitbucket.org/rubenandrebarreiro/)
* [https://dev.azure.com/rubenandrebarreiro/](https://dev.azure.com/rubenandrebarreiro/)
