%% drawOptions.m
% Draw the colour options available for final decision.
function drawOptions(win,col1,col2,optionCoords)
    Screen('FillRect',win,col1,optionCoords(:,1));
    Screen('FillRect',win,col2,optionCoords(:,2));
    Screen('FrameRect',win,[0 0 0],optionCoords(:,1),5);
    Screen('FrameRect',win,[0 0 0],optionCoords(:,2),5);
    Screen('DrawText', win, 'Left click', (optionCoords(1,1)+optionCoords(3,1))/2, (optionCoords(2,1)+optionCoords(4,1))/2, [255,255,255]);
    Screen('DrawText', win, 'Right click', (optionCoords(1,2)+optionCoords(3,2))/2, (optionCoords(2,2)+optionCoords(4,2))/2, [255,255,255]);
end