% Example script for calling the upoextraction function
%
% Other m-files required: upoextraction.m
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

close all
clear variables
clc

load('ts_example.mat');
upo = upoextraction(ts, 120, 0.005);
