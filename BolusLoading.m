%%%%Bolas loading TTL protocol%%%%% Ver2.1
clear all;
close all;

global dio
global ui

%%
gate_time = 3;
loop_interval = 1;

%%
T = timer('Period',loop_interval, 'ExecutionMode', 'fixedSpacing', 'TasksToExecute', 5);

%% GUI
ui = Open_GUI(dio, ui, gate_time, loop_interval, T);