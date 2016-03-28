function RepGate

global gatet
global loopint
global ui

global sTrig
global dev


switch get(ui.ongate,'value')
    case 1
        delete(sTrig);
        
        sTrig = daq.createSession(dev.Vendor.ID);
        switch get(ui.onloop, 'value')
            case 0 %single
                sTrig.DurationInSeconds = gatet+loopint;
            case 1 %loop
                sTrig.IsContinuous = true;
        end
        CtrCh = addCounterOutputChannel(sTrig, dev.ID, 'ctr0','Pulsegeneration');
        CtrCh.Frequency= 1/(gatet + loopint);
        %DutyCycle = signal(sec)/cycle(sec)
        CtrCh.DutyCycle= gatet/(gatet+loopint);
        
        set(ui.ongate,'BackGroundColor','g');
        
        startBackground(sTrig);
          
    case 0
        stop(sTrig)
        delete(sTrig)
        
        sTrig = daq.createSession(dev.Vendor.ID);
        addDigitalChannel(sTrig, dev.ID, 'port2/line4', 'OutputOnly');%Ctr0 out ‚ðŽg‚¤
        outputSingleScan(sTrig,0); %reset trigger signals at Low
        
        disp('OFF');
        
        set(ui.ongate,'BackGroundColor','w');
        set(ui.onloop, 'string','Loop-off','value',0, 'BackGroundColor','w');     
end