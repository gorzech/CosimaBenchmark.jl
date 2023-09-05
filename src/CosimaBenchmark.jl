module CosimaBenchmark
using Cosima
using CosimaModels
using BenchmarkTools
using Dates
using Pkg
# Write your package code here
function run_single_ode_step_benchmark(system_settings)
    sys = create_system(system_settings)
    ode = OdeMbs(sys)
    y0 = initial_position(sys)
    dy = zeros(sys.ny)
    return @benchmark ode!($dy, $y0, $ode, 0.0)
end

function run_single_ode_step_benchmark_with_setup(system_settings)
    sys = create_system(system_settings)
    return @benchmark ode!(dy, y0, ode, 0.0) setup = begin
        ode = OdeMbs($sys)
        y0 = initial_position($sys)
        dy = zeros($(sys.ny))
    end
end

function get_ode_step_benchmarkable_with_setup(system_settings)
    sys = create_system(system_settings)
    return @benchmarkable ode!(dy, y0, ode, 0.0) setup = begin
        ode = OdeMbs($sys)
        y0 = initial_position($sys)
        dy = zeros($(sys.ny))
    end
end

function run_simple_benchmark_1pendulum()
    single_pendulum = NPendulum()
    run_single_ode_step_benchmark(single_pendulum)
end

function save_benchmark_group_parameters(suite)
    tune!(suite)
    BenchmarkTools.save(banchmark_params_name(), params(suite))
end

const Cosima_suite_v1 = Dict("single_pendulum" => NPendulum(),
    "double_pendulum" => NPendulum(2),
    "triple_pendulum" => NPendulum(3),
    "x6_pendulum" => NPendulum(6),
    "x13_pendulum" => NPendulum(13),
    "spatial_slider" => SpatialSliderCrank())

function cosima_benchmarkable_suite()
    suite = BenchmarkGroup()
    for (n, s) in Cosima_suite_v1
        suite[n] = get_ode_step_benchmarkable_with_setup(s)
    end
    return suite
end

function test_run_benchmark_suite()
    suite = cosima_benchmarkable_suite()
    tune!(suite)
    run(suite)
end

function run_benchmark_suite_parameters()
    suite = cosima_benchmarkable_suite()
    loadparams!(suite, BenchmarkTools.load(banchmark_params_name())[1], :evals, :samples)
    run(suite)
end

function save_benchmark(benchmark_results, file_name)
    BenchmarkTools.save(file_name, benchmark_results)
end

function load_benchmark(file_name)
    BenchmarkTools.load(file_name)
end

function benchmark_params_name()
    return "params." * gethostname() * ".json"
end

function package_version(package_name)
    first(values(filter(x -> x.second.name == package_name, Pkg.dependencies()))).version
end

function benchmark_suite_name()
    version_cosima = string(package_version("Cosima"))
    version_cosima_models = string(package_version("CosimaModels"))
    # version_cosima_benchmark = string(package_version("CosimaBenchmark"))
    return file_friendly_now() * "_B-" * "0.0.1" * "_C-" * version_cosima * "_M-" * version_cosima_models * "_" * gethostname() * ".json"
end

function file_friendly_now()
    df = dateformat"yyyy-mm-dd\THH-MM-SS"
    return Dates.format(Dates.now(), df)
end

end
