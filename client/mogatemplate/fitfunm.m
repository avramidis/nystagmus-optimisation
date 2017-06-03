function y = fitfunm(x, client_n, pop_n, my_server_folder, neutral_params)
%FITFUNM Multi-objective fitness function for the optimisation of an
%oculomotor model to a nystagmus waveform.
%
% Syntax:  y = fitfunm(x, client_n, pop_n, my_server_folder, neutral_params)
%
% Inputs:
%    x                  - Matrix with the oculomotor model's parameter
%                         values
%    client_n           - Client name
%    pop_n              - Population size
%    my_server_folder   - Path to the gpu server
%    neutral_params     - Oculomotor model's parameters that are for
%                         running the model when its output does not play a
%                         role in the optimisation
%
% Outputs:
%    y                  - Fitness values
%
% Example:
%    y = fitfunm(x, 1, pop_n, my_server_folder, neutral_params)
%    This example calculates the fitness values for the MOGA client with
%    index 1 and individuals in matrix x. The MOGA population size is
%    pop_n, the gpuserver is in my_server_folder and the individual neutral_params
%    is used for calculations when the individuals output does not play a
%    role in the optimisation.
%
% Other m-files required: clent2server.m, getNystagmusWaveform4.m, calculate_fitness
% Subfunctions: none
% MAT-files required: target.mat
%
% See also: E. Avramidis & O.E. Akman. Optimisation of an exemplar oculomotor model
% using multi-objective genetic algorithms executed on a GPU-CPU combination.
% BMC Syst. Biol., 11: 40 (2017)
%
% @author: Eleftherios Avramidis $
% @email: el.avramidis@gmail.com $
% @date: 29/05/2017 $
% @version: 1.0 $
% @copyright: MIT License

%% Profiler global variables
global gpu_time;
global cpu_time;

%% Format the matrix x with the model parameters
pop_size = size(x,1);
if pop_size<pop_n
    x2 = repmat(neutral_params, pop_n-pop_size, 1);
    x3=[x;x2];
else
    x3=x;
end

%% Send the model parameter to the gpu server and read the results generated
%  by the gpuserver.
gpu_time_start=tic;
results=client2server(client_n, x3, my_server_folder);
gpu_time=gpu_time+toc(gpu_time_start);

%% Calculate the fitness for each individual
cpu_time_start=tic;
load('target.mat');
y=zeros(pop_size,2);
for i=1:pop_size
    simulated = getNystagmusWaveform(results(:,i));
    if simulated==0
        y1=1e+60;
        yp=1e+60;
    else
        [y1,yp]=calculate_fitness(target, simulated);
        if yp==1e+60
            y1=1e+60;
        end
    end
    
    y(i,1)=y1;
    y(i,2)=yp;
end
cpu_time=cpu_time+toc(cpu_time_start);
end