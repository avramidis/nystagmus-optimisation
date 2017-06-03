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