%%%%Bolas loading TTL protocol%%%%% Ver2.1
clear all;
close all;

global dio
global ui

%%
Testmode = 1;

if Testmode == 0
dio = digitalio('nidaq','dev1'); %digital object for trigger output
addline(dio,1,1,'out');
putvalue(dio, 0);
end

%%
gate_time = 3;
loop_interval = 1;

%%
T = timer('Period',loop_interval, 'ExecutionMode', 'fixedSpacing', 'TasksToExecute', 5);

%% GUI
ui = Open_GUI(dio, ui, gate_time, loop_interval, T, Testmode);