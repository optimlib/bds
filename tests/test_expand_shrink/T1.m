function T1()

    clc
    % f = TQUARTIC(ones(3,1))
    % keyboard
    % Define a custom feature that combines "perturbed_x0", "noisy", and
    % "linearly_transformed".

    % p = Problem(struct('name', 'TQUARTIC', 'fun', @(x) TQUARTIC(x), 'x0', 0.1*ones(3,1)));
    options.problem = s_load('DIXON3DQ');
    
    solvers = {@cbds_test, @cbds_orig_test, @ds_test};
    options.feature_name = 'custom';
    options.benchmark_id = 'T1_DIXON3DQ_noisy';
    % options.problem = p;
    options.n_runs = 1;
    options.seed = 25;
    options.solver_verbose = 2;
    options.mod_fun = @mod_fun;

    benchmark(solvers, options)
end

function f = mod_fun(x, rand_stream, problem)

    f = problem.fun(x);
    f = f + max(1, abs(f)) * 1e-3 * rand_stream.randn(1);
end

function x = cbds_test(fun, x0)

    options.Algorithm = 'cbds';
    % options.StepTolerance = eps;
    % options.MaxFunctionEvaluations = 200;
    % options.StepTolerance = 1e-3;
    % options.alpha_threshold = 1e-6;
    options.shrink = 0.8;
    options.expand = 1/options.shrink;
    options.verbose = false;
    options.output_alpha_hist = false;
    [x, ~, ~, output] = bds(fun, x0, options);
    x
    output

end

function x = cbds_orig_test(fun, x0)

    options.Algorithm = 'cbds';
    % options.StepTolerance = eps;
    % options.MaxFunctionEvaluations = 200;
    [x, ~, ~, output] = bds(fun, x0, options);
    x
    output

end

function x = ds_test(fun, x0)

    options.Algorithm = 'ds';
    %options.MaxFunctionEvaluations = 50*length(x0);
    %options.StepTolerance = eps;
    %options.MaxFunctionEvaluations = 300;
    options.verbose = false;
    options.output_alpha_hist = false;
    [x, ~, ~, output] = bds(fun, x0, options);
    x
    output

end