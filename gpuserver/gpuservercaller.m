% Example script for calling the gpuservercaller function
%
% Other m-files required: gpuservercaller.m
% Subfunctions: none
% MAT-files required: none
%
% See also: E. Avramidis & O.E. Akman. Optimisation of an exemplar oculomotor model
% using multi-objective genetic algorithms executed on a GPU-CPU combination.
% BMC Syst. Biol., 11: 40 (2017)
%
% @author: Eleftherios Avramidis $
% @email: el.avramidis@gmail.com $
% @date: 09/06/2017 $
% @version: 1.0 $
% @copyright: MIT License

close all
clear variables
clc

n_clients=8;
n_pop=4000;
neutral_params = [120 1.5 0.0045 0.05 600 9];
platform=3;
device=0;

t_runtime = gpuserver(n_clients, n_pop, neutral_params, platform, device);