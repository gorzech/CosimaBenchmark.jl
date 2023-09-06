function save_benchmark_group_parameters!(suite)
    tune!(suite)
    BenchmarkTools.save(benchmark_params_name(), params(suite))
end

function load_benchmark_group_parameters!(suite)
    loadparams!(suite, BenchmarkTools.load(benchmark_params_name())[1], :evals, :samples)
end

function save_benchmark(benchmark_results, file_name)
    BenchmarkTools.save(file_name, benchmark_results)
end

function load_benchmark(file_name)
    BenchmarkTools.load(file_name)
end

function benchmark_params_name()
    return "params" * "_B-" * Benchmark_version * "_" * gethostname() * ".json"
end

function package_version(package_name)
    first(values(filter(x -> x.second.name == package_name, Pkg.dependencies()))).version
end

function benchmark_suite_name(result_name="")
    version_cosima = string(package_version("Cosima"))
    version_cosima_models = string(package_version("CosimaModels"))
    # version_cosima_benchmark = string(package_version("CosimaBenchmark"))
    return (file_friendly_now() * "_B-" * Benchmark_version * "_C-" * version_cosima * "_M-"
            * version_cosima_models * "_" * gethostname() * "." * result_name * ".json")
end

function file_friendly_now()
    df = dateformat"yyyy-mm-dd\THH-MM-SS"
    return Dates.format(Dates.now(), df)
end
