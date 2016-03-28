function TTLOFF2
global ui
global sTrig


switch get(ui.ongate,'value')
    case 1 %loop ’†‚È‚ç stop
        stop(sTrig)
        delete(sTrig)
    case 0
        outputSingleScan(sTrig, 0)
end

disp('TTL_OFF');
set(ui.onpulse,'value',0);
set(ui.ongate,'value',0, 'BackGroundColor','w');
set(ui.onloop, 'string','Loop-off','value',0, 'BackGroundColor','w');
