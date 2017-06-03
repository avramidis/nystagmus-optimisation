close all
clear variables
clc

n_clients=8;
n_pop=4000;
neutral_params = [120 1.5 0.0045 0.05 600 9];
platform=3;
device=0;

t_runtime = gpuserver(n_clients, n_pop, neutral_params, platform, device);