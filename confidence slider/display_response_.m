function [ft] = display_response_(window,cfg,temp,vars)
% Usage:
% [ft] = display_response(Sc,cfg,temp [,cj1])
%
% Inputs:
% Sc: Screen structure
% cfg: cfg strucure
% temp: vector containing haschanged boolean and current confidence 
%       judgement

% 
% 
% if nargin < 4
    show_cj1    = false; 
% else
%     show_cj1    = true;
%     cj1         = varargin{1};
%     int1        = sign(cj1);
% end
gs = round(cfg.bar.gap_size/2);
[haschanged,cj] = deal(temp(1),temp(2));
fdTxt = cfg.instr.finaldecision{1};

%% display response
% draw static elements

% draw scale
draw_scale_(window,cfg);
% draw confidence and interval landmarks
draw_landmarks(window,cfg,vars);
% add response instructions
add_responseinstr(window,cfg);

% display previous confidence
if show_cj1
    switch int1
        case -1 % 1
            positions = linspace(cfg.bar.gaprect(1)-cfg.bar.cursorwidth.*.5,...
                cfg.bar.barrect(1)+cfg.bar.cursorwidth.*.5,cfg.bar.maxScale);
        case 1
            positions = linspace(cfg.bar.gaprect(3)+cfg.bar.cursorwidth.*.5, ...
                cfg.bar.barrect(3)-cfg.bar.cursorwidth.*.5,cfg.bar.maxScale);
    end
    cj1rect = CenterRectOnPoint([0,0,cfg.bar.cursorwidth,cfg.bar.cursorheight],...
    positions(abs(cj1)), ...
    window.rect(4).*cfg.bar.positiony);
    Screen('FillRect', window.window, [.4 .4 .4]',cj1rect );

    Screen('TextSize', window.window, 23); % change font size
    DrawFormattedText(window.window,fdTxt,'center',window.center(2) -100);
    Screen('TextSize', window.window, 13); % change back font size
end

% define response cursor position
switch sign(cj)
    case -1
        positions = linspace(cfg.bar.gaprect(1)-cfg.bar.cursorwidth.*.5,...
            cfg.bar.barrect(1)+cfg.bar.cursorwidth.*.5,cfg.bar.maxScale);
    case 1
        positions = linspace(cfg.bar.gaprect(3)+cfg.bar.cursorwidth.*.5, ...
            cfg.bar.barrect(3)-cfg.bar.cursorwidth.*.5,cfg.bar.maxScale);
end

% draw cursor only after first click
if haschanged
    cursorrect = CenterRectOnPoint([0,0,cfg.bar.cursorwidth,cfg.bar.cursorheight],...
        positions(abs(cj)), ...
        window.rect(4) .* cfg.bar.positiony);
    Screen('FillRect', window.window, [102,255,0]',cursorrect'); % bright green
end

Screen('TextFont', window.window, 'Myriad Pro');

% Flip on screen
ft = Screen('Flip', window.window);

return