function getmogaresults(n_workitems, n_pop)
% GETMOGARESULTS Copies the results from MOGA client folder to the results
% folder
%
% Syntax:  getmogaresults(n_workitems, n_pop)
%
% Inputs:
%    n_workitems    - Number of workitems
%    n_pop          - Population size
%
% Outputs:
%    none
%
% Example:
%    getmogaresults(10, 500)
%    This example copies the results from 10 MOGA runs with population size
%    500.
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
% @date: 2017/06/03 $
% @version: 1.0 $
% @copyright: MIT License

mkdir('results')
mkdir(['results\' num2str(n_pop)])

% copy results from each client
for i=1:n_workitems
    files = dir( ['client_' num2str(i) '\outresults_*.mat']);
    copyfile(['client_' num2str(i) '\' files(1).name], ['results\' num2str(n_pop) '\outresults_' num2str(i) '.mat']);
end

