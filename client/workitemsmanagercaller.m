% Example script for calling the workitemsmanager function
%
% Other m-files required: workitemsmanager.m
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

n_gen=100;
n_pop=4000;
n_workitems = 8;
n_clients = 8;
server_folder = '..\gpuserver\';
neutral_params = [120 1.5 0.0045 0.05 600 9];

workitemsmanager(n_gen, n_pop, n_workitems, n_clients, server_folder, neutral_params)