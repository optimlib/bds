function fhist_solvers(problem_name, parameters)
% This file is to draw the function value history of the solvers.
% 

hfig = figure("visible", true);  % Plot the figure with displaying it.

fullpath = mfilename("fullpath");
path_examples = fileparts(fullpath);
path_bds = fileparts(path_examples);
path_src = fullfile(path_bds, "src");
path_competitors = fullfile(path_bds, "tests", "competitors");
addpath(path_src)
addpath(path_competitors)

locate_matcutest();
p = macup(problem_name);
dim = length(p.x0);

color_set = ["red", "blue", "green", "yellow"];
solvers_num = length(parameters.solvers_options);
fhist = cell(1, solvers_num);
test_options.is_noisy = false;

for i = 1:solvers_num
    
    solver = str2func(parameters.solvers_options{i}.solver);
    % [~, ~, ~, output] = solver(p.objective, p.x0, parameters.solvers_options{i}); 
    % fhist{i} = output.fhist;


    obj = ScalarFunction(p);
    solver(@(x)obj.fun(x,test_options.is_noisy,1,test_options), p.x0, parameters.solvers_options{i});
    fhist{i} = obj.valHist;
 
end

for i = 1:solvers_num
    loglog(fhist{i}, color_set(i));
    hold on
end

legend(parameters.solvers_name(1), parameters.solvers_name(2));

savepath = parameters.savepath; 
filename = strcat(problem_name, "_", num2str(dim), ".png");
saveas(gcf, fullfile(savepath, filename));

rmpath(path_src)
rmpath(path_competitors)

end

