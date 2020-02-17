%% drawOptions.m
% Draw the colour options available for final decision.
function drawOptions(win,col1,col2,optionCoords)
    Screen('FillRect',win,col1,optionCoords(:,1));
    Screen('FillRect',win,col2,optionCoords(:,2));
    Screen('FrameRect',win,[0 0 0],optionCoords(:,1),5);
    Screen('FrameRect',win,[0 0 0],optionCoords(:,2),5);
end