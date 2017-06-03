function [y,yp] = calculate_fitness(target, simulated)
%COMPARE_FITNESS Calculates the multi-objective fitness value
%
% Syntax:  yout = calculate_fitness(target, simulated)
%
% Inputs:
%    target     - The target waveform
%    simulated  - The waveform to be evaluated
%
% Outputs:
%    y          - Waveform shape fitness
%    yp         - Waveform period fitness
%
% Example:
%    yout = calculate_fitness(sin(1:15), cos(1:25))
%    This example calculates the multi-objective fitness value of the two
%    waveforms sin(1:15) and cos(1:25).
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

target=target + 100;
simulated=simulated + 100;

%% Shape difference calculation
target=target(:) - min(target);
simulated_scaled = scale2target(target, simulated);
y=sum((simulated_scaled-target).^2);
y=y/length(target);
y=sqrt(y);

%% Period difference calculation
yp=compare_period(target, simulated);

% ym=abs(min(gradient(simulated,0.0004)));