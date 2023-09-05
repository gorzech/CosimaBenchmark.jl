# CosimaBenchmark

[![Build Status](https://github.com/gorzech/CosimaBenchmark.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/gorzech/CosimaBenchmark.jl/actions/workflows/CI.yml?query=branch%3Amain)

Package that accompany Cosima.jl and CosimaModels.jl. Created to allow for consistent benchmarking of the Cosima.jl. 

## Usage

### Setup the new environment and add required packages

1. Create a new local Julia environment in folder of your choice.
    ```[julia]
    ] # to chenge mode to pkg>
    activate .
    ```
2. Add all three needed Cosima packages. Here I assume you share the environment directory with Cosima, CosimaModal, and CosimaBenchmark directories.
    ```[julia]
    # All to be executed in pkg mode
    dev ../Cosima
    dev ../CosimaModels
    dev ../CosimaBenchmark
    ```
3. Get back to the Julia REPL by hitting `backspace`.

4. Use package by typing `using CosimaBenchmark`.

5. If everything went fine, you should be able to import the package without any errors. Just in case, you can run the following command: 

    ```[julia]
    CosimaBenchmark.benchmark_params_name()
    ```
    It should display the file name under which benchmark parameters will be saved. 

### Prepare for benchmarking – setup BenchmarkTools parameters

