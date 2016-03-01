function openGUI
global dev
global sTrig
global gatet
global loopint
global ui

%GUI
figure;

ui.onpulse = uicontrol('style','togglebutton','string','TTLPulse','position',[10 300 100 30],'callback','TTLPulseON2','fontsize',10);
ui.ongate = uicontrol('style','togglebutton','string','TTLGate','position',[130 300 100 30],'callback','RepGate','fontsize',10);
ui.onloop = uicontrol('style','togglebutton','string','Loop-off','position',[240 300 80 30],'callback','TTLLoop2','fontsize',10,'BackGroundColor','w');

ui.off = uicontrol('string','OFF','position',[10 250 100 30],'callback','TTLOFF2','fontsize',10);

uicontrol('style','text','string','GateTime(sec)','position',[130 275 100 20],'fontsize',10);
ui.gatet = uicontrol('style','edit','string',gatet,'position',[130 250 100 25],'callback','gatet=str2num(get(ui.gatet,''string''));','fontsize',10,'BackGroundColor','w');

uicontrol('style','text','string','Interval(sec)','position',[240 275 100 20],'fontsize',10);
ui.loopint = uicontrol('style','edit','string',loopint,'position',[240 250 100 25],'callback','loopint=str2num(get(ui.loopint,''string''));','fontsize',10,'BackGroundColor','w');

%% nested functions
%%
    function TTLPulseON2
        switch get(ui.onpulse,'value')
            case 1
                set(ui.onpulse,'BackGroundColor','g');
                outputSingleScan(sTrig,1); %continuously pulse on
            case 0
                set(ui.onpulse,'BackGroundColor','w');
                outputSingleScan(sTrig,0); %reset trigger signals at Low
        end
    end
%% 
    function RepGate
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
    end
%%
    function TTLLoop2
        switch get(ui.onloop,'value')
            case 1
                set(ui.onloop,'string','Loop','BackGroundColor','g');
            case 0
                set(ui.onloop,'string','Loop-off','BackGroundColor','w');
        end
    end
%%
    function TTLOFF2
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
    end
end