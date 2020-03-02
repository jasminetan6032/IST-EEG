function [] = add_responseinstr(window,cfg)
% Usage:
% [] = add_responseinstr(Sc,cfg)
% 
% Required fields:
% cfg.instr.instr refers to the response mode instructions 
% at the bottom of the page.
% cfg.bar.positiony
% 
% Default values are assigned only to cfg.instr.instr
% 
% Niccolo Pescetelli
%
% - - updated MD July 2019 to accomodate new variable names.
% - - New font cfgs (size and colour).

%% check required fields
% if ~isfield(cfg.instr,'instr')
    cfg.instr.instr = {'Right click to confirm'};
% end


%% add response istructions
Screen('TextSize', window.window, cfg.fontsize);
Screen('TextFont', window.window, 'Myriad Pro');
DrawFormattedText(window.window, cfg.instr.instr{1}, 'center', (window.rect(4)).*(cfg.bar.positiony+.1), [1,1,1]);


return
