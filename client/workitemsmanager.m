function workitemsmanager(n_gen, n_pop, n_workitems, n_clients, server_folder, neutral_params)
% WORKITEMSMANAGER Manages the clients function
%
% Syntax:  workitemsmanager( n_workitems, n_clients, server_folder )
%
% Inputs:
%    n_workitems    - Number of generations
%    n_workitems    - Population size
%    n_workitems    - Number of workitems
%    n_clients      - Number of clients
%    server_folder  - Path to the server files (Best in a RAM disk)
%
% Outputs:
%    none
%
% Example:
%    workitemsmanager(5, 500, 16, 4, 'D:/GPU_SERVER/GPU_A')
%    This example starts the work times manager with 16 work items and
%    4 clients. THe NSGA-II runs for 5 generations and 500 population size.
%
% Other m-files required: templatefull_multi_orig (folder)
% Subfunctions: none
% MAT-files required: none
%
% See also: E. Avramidis & O.E. Akman. Optimisation of an exemplar oculomotor model
% using multi-objective genetic algorithms executed on a GPU-CPU combination.
% BMC Syst. Biol., 11: 40 (2017)
%
% @author: Eleftherios Avramidis $
% @email: el.avramidis@gmail.com $
% @date: 2015/07/25 $
% @version: 1.0 $
% @copyright: MIT License

%% Check if GPU server folder exists
pathInfo = what(server_folder);
server_folder=[pathInfo.path '\'];
if exist(server_folder, 'dir')==0
    error([server_folder ' GPU server folder does not exist']);
end

%% Create the list with the workitems
workitems = zeros(n_workitems, 2);
for i=1:n_workitems
    workitems(i,:)=[i i];
end

%% Send empty file flags to the GPU server
for i=1:n_clients
    ended=1;
    save([server_folder 'empty_' num2str(i) '.mat'], 'ended');
end

% Number of client slots to the server that are invactive 
n_ended=0;

% check if there are empty slots at the server
while(true)
    pause(2)
    for i=1:n_clients  % is the number of slot in the server
        if exist([server_folder 'empty_' num2str(i) '.mat'], 'file')==2
            % send a work item
            
            if size(workitems,1)==0
                n_ended=n_ended+1;
                ended=1;
                save([server_folder 'ended_' num2str(i) '.mat'], 'ended');
                delete([server_folder 'empty_' num2str(i) '.mat']);
                continue;
            end
            
            work_item=workitems(1,:);
            workitems(1,:)=[];
            
            copyfile('mogatemplate', ['client_' num2str(work_item(1))]);
            % copy the target waveform
            copyfile(['target' num2str(work_item(2)) '.mat'], ['client_' num2str(work_item(1)) '\target.mat']);
            
            % Create and copy mat file with the parameters struct
            params=struct();
            params.client_n=i;
            params.work_item=work_item(1);
            params.server_folder=server_folder;
            params.neutral_params=neutral_params;
            params.n_gen=n_gen;
            params.n_pop=n_pop;
            save('params.mat','params');
            movefile('params.mat', ['client_' num2str(work_item(1)) '\params.mat']);
            
            run_command = 'matlab -nojvm -nosplash -r main() &';
            cd(['client_' num2str(work_item(1))]);
            [s, w] = dos(run_command);
            if s % then failed
                disp('Call to m file failed')
                return
            end
            
            cd('..');
            delete([server_folder 'empty_' num2str(i) '.mat']);
        end
    end
    if n_ended==n_clients
        break;
    end
end

%% Copy results to results folder
getmogaresults(n_workitems, n_pop);