function r=client2server(i, pop, my_server_folder)
%CLIENT2SERVER Sends the population to the gpuserver and reads the results
%from the gpuserver.
%
% Syntax:  r=client2server(i, pop, my_server_folder)
%
% Inputs:
%    i                  - Client index
%    pop                - Population with the MOGA individuals
%    my_server_folder   - Path to the gpu server
%
% Outputs:
%    r                  - Results from the gpuserver
%
% Example:
%    r=client2server(1, pop, 'D\GPUSERVER\GPU_1')
%    This example sends the population to the gpuserver in the 'D\GPUSERVER\GPU_1'
%    folder and returns the results to the variable r for the MOGA client with 
%    index 1.
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: E. Avramidis & O.E. Akman. Optimisation of an exemplar oculomotor model
% using multi-objective genetic algorithms executed on a GPU-CPU combination.
% BMC Syst. Biol., 11: 40 (2017)
%
% @author: Eleftherios Avramidis
% @email: el.avramidis@gmail.com
% @date: 29/05/2017
% @version: 1.0
% @copyright: MIT License

% Connect to server
while(true)
    pause(0.1)
    try
        save([my_server_folder '\pop_' num2str(i) '.mat'], 'pop');
        disp('Pop have been sent to server');
        
        break;
    catch e_name
        %         disp('Waiting to send pop to server...');
    end
end

disp('Waiting for results...')
% waiting for results
while(true)
    try
        pause(0.1)
        if exist([my_server_folder '\results_ready.mat'], 'file')==2
            if exist([my_server_folder '\results_' num2str(i) '.bin'], 'file')==2                
                fid = fopen([my_server_folder '\results_' num2str(i) '.bin']);
                r = fread(fid, [9001 size(pop,1)], 'double');
                fclose(fid);
                break;
            end
        end
    catch e_name
        disp(e_name)
                disp('Waiting for results...')
    end
end

disp('delete results...')
% waiting for results
while(true)
    try
        pause(0.1)
        if exist([my_server_folder '\results_ready.mat'], 'file')==2
            if exist([my_server_folder '\results_' num2str(i) '.bin'], 'file')==2
                delete([my_server_folder '\results_' num2str(i) '.bin']);
                break;
            end
        end
    catch e_name
        %         disp('Waiting for results...')
    end
end

