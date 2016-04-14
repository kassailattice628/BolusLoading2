function ui = Open_GUI(dio, ui, gate_time, loop_interval, T)
Testmode = 1;
dio = [];

ui.fig = figure('Position',[10, 500, 220, 200], 'Name','BolusLoad2', 'NumberTitle', 'off', 'Menubar','none', 'Resize', 'off');

ui.onloop = uicontrol('style', 'togglebutton', 'string','Loop-off', 'position', [110 50 100 30],...
    'callback', @TTLLoop, 'fontsize', 12, 'BackGroundColor', 'w');

ui.ongate = uicontrol('style', 'togglebutton', 'string', 'TTLGate', 'position', [10 50 100 30],...
    'callback', {@TTLGateON, ui}, 'fontsize', 12);

ui.off = uicontrol('string','OFF','position', [10 10 80 30],...
    'callback', {@TTLOFF, ui}, 'fontsize', 12);

uicontrol('style','text','string','duration(s)','position', [10 115 100 20], 'fontsize', 12);

ui.gatet = uicontrol('style', 'edit', 'string', gate_time, 'position', [10 90 100 25],...
    'callback', 'gate_time = str2double(get(ui.gatet,''string''));',...
    'fontsize', 12, 'BackGroundColor', 'w');

uicontrol('style', 'text', 'string', 'Interval(s)', 'position', [110 115 100 20], 'fontsize', 12);

ui.loopint = uicontrol('style', 'edit', 'string', loop_interval, 'position', [110 90 100 25],...
    'callback', 'loop_interval = str2double(get(ui.loopint,''string''));',...
    'fontsize', 12, 'BackGroundColor', 'w');

uicontrol('style','togglebutton', 'string', 'DAQ-ON', 'position', [10, 150, 100, 30], 'callback', @setDAQ)

%% set Timer FCNs %%
T.StartFcn = @TimerStartFCN;
T.StopFcn = {@TimerStopFCN, ui};
T.TimerFcn = @TimerFCN;

%%
    function setDAQ(hObject, ~)
        if get(hObject, 'value')
            Testmode = 0;
            % DAQ setting %Session Based DAQ
            dev = daq.getDevices;
            % DIO setting
            dio = daq.createSession(dev.Vendor.ID);
            addDigitalChannel(dio, dev.ID, 'port2/line4', 'OutputOnly');%Ctr0 out ‚ðŽg‚¤
            startForeground(dio)
            outputSingleScan(dio,0); %reset trigger signals at Low
        else
            Testmode = 1;
            putvalue(dio, 0);
            delete dio
            dio =[];
        end
    end

%%
    function TTLGateON(h, ~, ui)
        if get(h,'value')==1
            if get(ui.onloop, 'value')
                set(T, 'period', loop_interval, 'ExecutionMode', 'fixedSpacing');
                start(T)
            else % single shot
                set(T, 'ExecutionMode','singleShot');
                start(T);
            end
        end
    end
%%
    function TTLLoop(h, ~)
        if get(h,'value')==1
            set(h,'string','Loop','BackGroundColor','g');
        else
            set(h,'string','Loop-off','BackGroundColor','w');
        end
    end
%%
    function TTLOFF(~, ~, ui)
        if strcmp(T.Running,'on')
            stop(T);
            delete(T);
        end
        putdio(dio, 0)
        disp('TTL_OFF');
        set(ui.ongate,'value',0);
        set(ui.onloop, 'string','Loop-off','value',0, 'BackGroundColor','w');
    end

%%
    function putdio(dio, val)
        if Testmode == 0
            putvalue(dio, val);
        end
    end

%% define Timer Functions %%
%%
    function TimerStartFCN(~,~)
        disp('Start Loop')
    end
%%
    function TimerStopFCN(obj, ~, ui)
        disp('End Loop')
        stop(obj);
        disp(obj.Running);
        TTLOFF([], [], ui)
    end
%%
    function TimerFCN(~,~)
        disp('Timer')
        putdio(dio, 1)
        pause(gate_time)
        putdio(dio, 0)
    end


end
