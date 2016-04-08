function ui = Open_GUI(dio, ui, gate_time, loop_interval, T, Testmode)
figure;

ui.onloop = uicontrol('style', 'togglebutton', 'string','Loop-off', 'position', [240 300 80 30],...
    'callback', @TTLLoop, 'fontsize', 10, 'BackGroundColor', 'w');

ui.onpulse = uicontrol('style', 'togglebutton', 'string', 'TTLPulse', 'position', [10 300 100 30],...
    'callback', {@TTLGateON, ui}, 'fontsize', 10);

ui.ongate = uicontrol('style', 'togglebutton', 'string', 'TTLGate', 'position', [130 300 100 30],...
    'callback', {@TTLGateON, ui}, 'fontsize', 10);

ui.off = uicontrol('string','OFF','position', [10 250 100 30],...
    'callback', {@TTLOFF, ui}, 'fontsize', 10);

uicontrol('style','text','string','gate_time(sec)','position', [130 275 100 20], 'fontsize', 10);

ui.gatet = uicontrol('style', 'edit', 'string', gate_time, 'position', [130 250 100 25],...
    'callback', 'gate_time = str2double(get(ui.gatet,''string''));',...
    'fontsize', 10, 'BackGroundColor', 'w');

uicontrol('style', 'text', 'string', 'Interval(sec)', 'position', [240 275 100 20], 'fontsize', 10);
ui.loopint = uicontrol('style', 'edit', 'string', loop_interval, 'position', [240 250 100 25],...
    'callback', 'loop_interval = str2double(get(ui.loopint,''string''));',...
    'fontsize', 10, 'BackGroundColor', 'w');

%% set Timer FCNs %%
T.StartFcn = @TimerStartFCN;
T.StopFcn = {@TimerStopFCN, ui};
T.TimerFcn = @TimerFCN;


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
        set(ui.onpulse,'value',0);
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
