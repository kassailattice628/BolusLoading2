function TTLPulseON2

global sTrig
global ui

switch get(ui.onpulse,'value')
    case 1
        set(ui.onpulse,'BackGroundColor','g');
        outputSingleScan(sTrig,1); %continuously pulse on
    case 0
        set(ui.onpulse,'BackGroundColor','w');
        outputSingleScan(sTrig,0); %reset trigger signals at Low
end