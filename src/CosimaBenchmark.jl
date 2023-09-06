module CosimaBenchmark
using Cosima
using CosimaModels
using BenchmarkTools
using Dates
using Pkg

include("cosima_suite.jl")

const Benchmark_version = "1"

const Current_suite = Cosima_suite_v1

include("file_support.jl")

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


function get_benchmarkable_suite()
    suite = BenchmarkGroup()
    for (n, s) in Current_suite
        suite[n] = get_ode_step_benchmarkable_with_setup(s)
    end
    return suite
end

function test_run_benchmark_suite()
    suite = get_benchmarkable_suite()
    tune!(suite)
    run(suite)
end

function run_benchmark_suite()
    suite = get_benchmarkable_suite()
    load_benchmark_group_parameters!(suite)
    run(suite)
end

end
