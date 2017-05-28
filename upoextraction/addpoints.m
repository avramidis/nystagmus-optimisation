function ts_out=addpoints(ts_in, dt_old, dt_new)
%ADDPOINTS Add more points to the time series using interpolation.
%
% Syntax:  ts_out=addpoints(ts_in, dt_old, dt_new)
%
% Inputs:
%    ts_in      - Input time series
%    dt_old     - Input time series dt
%    dt_new     - Input time series dt
%
% Outputs:
%    ts_out     - Interpolated output time series
%
% Example:
%    ts_out=addpoints(ts_in, 0.005, 0.0004)
%    This example adds new points to the ts_in time series using slpine
%    interpolation. The delta time for the input time series is 0.005 while
%    for the output time series is 0.0004
%
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
% @date: 21/05/2014 $
% @version: 1.0 $
% @copyright: MIT License

seconds=size(ts_in,1)*dt_old;

t=0:dt_old:seconds;
t=t(1:end-1)';
ts_orig=[t ts_in];

t2=0:dt_new:seconds;
t2=t2(1:end-1)';
ts_out = interp1(ts_orig(:,1),ts_orig(:,2),t2,'slpine');

end