close all
clear variables
clc

n_pop=4;
x = [120 1.5 0.0045 0.05 600 9];
x = repmat(x,n_pop,1);
platform=0;
device=0;

sim_results = odeclcaller(x, platform, device);

plot(sim_results(:,1))