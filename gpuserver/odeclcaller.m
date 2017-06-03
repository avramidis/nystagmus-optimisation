function yout = odeclcaller(x_params, platform, device)
%ODECLCALLER Calls the odecl function.
%
% Syntax:  yout = odeclcaller(x_params, platform, device)
%
% Inputs:
%    x_params   - Oculomotor model parameters
%    platform   - OpenCL platform id
%    device     - OpenCL device id
%
% Outputs:
%    yout       - Integration results
%
% Example:
%    yout = odeclcaller(x_params, 0, 3)
%    This example setups the ODECL parameters to integrate the oculomotor
%    model. The selected OpenCL platform id is 0 and the devide is 3.
%
% Other m-files required: odecl.m
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

%% Number of different population sets
pop=size(x_params,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Broomhead et al. (2000) model initial conditions
y0=[0 0 0 0 0 1];
x_y0=repmat(y0, pop, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Broomhead et al. (2000) model parameters

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Noise parameters
nnoi = 0;
x_noise = [];
x_noise=repmat(x_noise,pop,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Merge deterministic model parameters and noise parameters
if nnoi>0
    x_params=[x_params x_noise];
end

nparams=size(x_params,2);
nnoise=nnoi;
pop=size(x_params,1);

% platform = 3;
% device = 0;
kernel = 'broomhead.cl';
initx = x_y0;
params = x_params;
solver = 'im';
orbits = pop;
nequat = 6;
dt = 5e-6;
tspan = 6;
ksteps = 80;
ksteps_multi = 1;
localgroupsize = 0;
% localgroupsize = 256;

% Call ODECL to integrate the model in the defined in the kernel file
[~,yout]=odecl(platform, device, kernel, initx, params, solver, orbits, nequat, nparams+nnoise, nnoise, dt, tspan, ksteps, ksteps_multi, localgroupsize );

% check if the solver exploded
if ~isempty(find(isnan(yout), 1))
    length(find(isnan(yout)))
    disp('NANs found!!!')
    save('params_problem.mat','x_params')
end

% Extract only the last 9000 data points
yout=yout(end-9000:end,:);

