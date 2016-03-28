function TTLLoop2
global ui

switch get(ui.onloop,'value')
    case 1
    set(ui.onloop,'string','Loop','BackGroundColor','g');
    case 0
    set(ui.onloop,'string','Loop-off','BackGroundColor','w');
end