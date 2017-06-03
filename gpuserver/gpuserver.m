function t_runtime = gpuserver(n_clients, n_pop, neutral_params, platform, device)
%GPUSERVER Starts the ODE solver server.
%
% Syntax:  t_runtime  = start_server(n_clients, n_pop, neutral_params, platform, device)
%
% Inputs:
%    n_clients          - Number of MOGA clients
%    n_pop              - Population size for each MOGA client
%    neutral_params     - Oculomotor parameters that are used when the
%                         integration is not needed.
%    platform           - OpenCL platform id
%    device             - OpenCL device id
%
% Outputs:
%    t_runtime          - Optimisation runtime in seconds
%
% Example:
%    t_runtime = START_SERVER( 8, 4000, [120 1.5 0.0045 0.05 600 9], 0, 3 )
%    This example starts the ODE solver client for 8 MOGA clients with
%    population size 4000 for each client. The neutral parameters are given
%    in the third argument as a vector. The selected OpenCL platform id is
%    0 and the devide is 3.
%
% Other m-files required: odeclcaller.m
% Subfunctions: none
% MAT-files required: none
%
% See also: E. Avramidis & O.E. Akman. Optimisation of an exemplar oculomotor model
% using multi-objective genetic algorithms executed on a GPU-CPU combination.
% BMC Syst. Biol., 11: 40 (2017)
%
% @author: Eleftherios Avramidis $
% @email: el.avramidis@gmail.com $
% @date: 2016/12/14 $
% @version: 1.0 $
% @copyright: MIT License

%% Setup optimisation server parameters
tic;
n_ended=zeros(n_clients,1);
iteration=1;

%% Wait input from clients, integrate the model and write the results to binary files
while (true)
    n_ended=zeros(n_clients,1);
    disp(['Iterations number: ' num2str(iteration)])
    
    iteration=iteration+1;
    
    read_pop=zeros(n_clients,1);
    x=zeros(n_clients*n_pop, 6);
    
    clients_read=ones(n_clients,1);
    
    disp('Waiting for populations...')
    while(true)
        pause(0.01)
        idx=find(clients_read==1);
        for i=idx'
            if exist(['pop_' num2str(i) '.mat'], 'file')==2
                % read population file
                try
                    load(['pop_' num2str(i) '.mat'])
                    k=(i-1)*n_pop;
                    x(k+1:k+n_pop, :)=pop;
                    read_pop(i)=1;
                    clients_read(i)=0;
                    
                    break;
                catch
                    
                end
            else
                if exist(['ended_' num2str(i) '.mat'], 'file')==2
                    n_ended(i)=1;
                    k=(i-1)*n_pop;
                    x(k+1:k+n_pop, :) = repmat(neutral_params, n_pop, 1);
                    read_pop(i)=1;
                    clients_read(i)=0;
                end
            end
        end
        
        idx=find(read_pop==1);
        if size(idx,1)==n_clients
            disp('All populations read...')
            break;
        else
            
        end
    end
    
    %% Delete population files
    for i=1:n_clients
        while(exist(['pop_' num2str(i) '.mat'], 'file')==2)
            pause(0.1)
            delete(['pop_' num2str(i) '.mat']);
        end
    end
    
    %% Break if all clients finished their optimisation runs
    idx=find(n_ended==1);
    if size(idx,1)==n_clients
        break;
    end
    
    %% Close all - including files
    close all
    
    %% Delete results_ready file flag from previous iteration
    if exist('results_ready.mat')==2
        pause(0.1)
        delete('results_ready.mat');
    end
    
    %% Delete result files from previous iteration
    for i=1:n_clients
        delete(['results_' num2str(i) '.bin']);
    end
    
    %% Run the ODE solver for all populations
    sim_results = odeclcaller(x, platform, device);
    
    %% Save integration results in seperate files - one for each client
    for i=1:n_clients
        k=(i-1)*n_pop;
        
        results=sim_results(:, k+1:k+n_pop);
        
        fid = fopen(['results_' num2str(i) '.bin'], 'w');
        fwrite(fid, results, 'double');
        fclose(fid);
    end
    
    %% Clear the variables with the integration results
    clear sim_results;
    clear results;
    
    pause(1);
    
    %% Set the results_ready file flag to 1 to signal the clients that the results are ready
    results_ready=1;
    save('results_ready.mat', 'results_ready');
end
t_runtime=toc;
disp('Finished')