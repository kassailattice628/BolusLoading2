%%%%Bolas loading TTL protocol%%%%%
clear;
close all;
% Reset DAQ
daq.reset
%%
global dev
global sTrig
global gatet
global loopint

%% DAQ setting %Session Based DAQ 
dev = daq.getDevices;
% DIO setting
sTrig = daq.createSession(dev.Vendor.ID);
addDigitalChannel(sTrig, dev.ID, 'port2/line4', 'OutputOnly');%Ctr0 out ‚ðŽg‚¤
outputSingleScan(sTrig,0); %reset trigger signals at Low

%%
gatet = 200;
loopint = 10;

%%
openGUI