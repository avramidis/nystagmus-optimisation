function [state, options, optchanged] = outfun(options,state,flag)
%OUTFUN Output function for each generation of the NSGA-II algorithm. The
%state of NSGA-II is stored in the states.mat file.
%
% Syntax:  [state, options, optchanged] = outfun(options,state,flag)
%
% Inputs:
%    options        - NSGA-II options
%    state          - NSGA-II state
%    flag           - NSGA-II flag that shows the interation stage
%
% Outputs:
%    state          - NSGA-II state
%    options        - NSGA-II options
%    optchanged     - Flag to show if the options were changed
%
% Example:
%    [state, options, optchanged] = outfun(options,state,flag)
%    This example The reads the currect state of NSGA-II iteration and add
%    its to the struct in the states.mat file.
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
% @date: 30/09/2012
% @version: 1.0
% @Copyright: MIT License

optchanged = false;
switch flag
 case 'init'
        disp('Starting the algorithm');
    case {'iter','interrupt'}
        disp('Iterating ...')
        
        try
            load('states.mat');
            states(end+1)=state;
            save('states.mat', 'states');
        catch err
            states(1)=state;
            save('states.mat', 'states');
        end
        
    case 'done'
        disp('Performing final task');
end
