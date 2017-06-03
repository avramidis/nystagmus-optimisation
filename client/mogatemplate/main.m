function main()
%MAIN Main function of the nystagmus optimisation method.
%
%   MAIN( client_n ) Optimises the Broomhead et al. (2000)
%   saccadic model. Finds the parameters values that cause the model to 
%   generate behaviour as close as posible to the target data.
%
% Syntax:  main( client_n )
%
% Inputs:
%    client_n - Integer designating the number of the optimisation
%
% Outputs: 
%    none
%
% Example:
%    main( 1, 'D:/GPU_SERVER/GPU_A' )
%    This example a client with ID 1 and server location 'D:/GPU_SERVER/GPU_A'.
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: E. Avramidis & O.E. Akman. Optimisation of an exemplar oculomotor model
% using multi-objective genetic algorithms executed on a GPU-CPU combination.
% BMC Syst. Biol., 11: 40 (2017)
%
% @author: Eleftherios Avramidis $
% @email: el.avramidis@gmail.com $
% @date: 29/09/2012 $
% @version: 1.0 $
% Copyright: MIT License

disp(['Current client path: ' pwd])
rng('shuffle')
diary('matlog.txt')
diary on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load client's parameters
load('params.mat')
client_n=params.client_n;
server_folder=params.server_folder;
neutral_params=params.neutral_params;
work_item=params.work_item;
generations=params.n_gen;
population=params.n_pop;

if exist('all_solutions.mat')==2
    delete('all_solutions.mat');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load waveform target
load('target.mat');
target_ts=target;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Output struct
% Create struct to save individuals of each generation
all_solutions = struct();
all_solutions.target.ts = target_ts;
all_solutions.generations = 1;
save('all_solutions.mat', 'all_solutions');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set NSGA-II fitness function and parameters

% Fitness function
fhm=@(x)fitfunm(x, client_n, population, server_folder, neutral_params);

% NSGA-II parameters
optGA = gaoptimset(@gamultiobj);
optGA.Display = 'iter';
optGA.Generations = generations;
optGA.OutputFcns = @outfun;
optGA.ParetoFraction = 1;
optGA.CrossoverFcn=@crossoverheuristic;
optGA.DistanceMeasureFcn = {@distancecrowding,'phenotype'};
optGA.PopulationSize = population;
optGA.Vectorized = 'on';
% optGA.TolFun=1e-100;
LB = [1,    0.1, 0.000001,   0,          1,    0.1];
UB = [1000, 60,  0.1,       12.0,       1000, 60];
optGA.PopInitRange = [LB; UB];
save('optGA.mat','optGA')

warning off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set profiler parameters
global gpu_time;
gpu_time=0;
global cpu_time;
cpu_time=0;
ga_start=tic;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Execute the NSGA-II
[Xga,Fga,~,output,~] = gamultiobj(fhm,6,[],[],[],[],LB,UB,optGA);
ga_all=toc(ga_start);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Format and save the output struct
filename = 'outresults';
load('all_solutions.mat');
load('states.mat');
all_solutions.Xga=Xga;
all_solutions.Fga=Fga;
all_solutions.output=output;
all_solutions.optGA=optGA;
all_solutions.times.ga_all=ga_all;
all_solutions.times.gpu_all=gpu_time;
all_solutions.times.cpu_all=cpu_time;
all_solutions.states=states;
save('all_solutions.mat', 'all_solutions');
movefile('all_solutions.mat',[filename '_' num2str(work_item) '.mat'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set signal to the gpuserver that the client has terminated
empty=1;
save([server_folder '\empty_' num2str(client_n) '.mat'], 'empty');

diary off

quit