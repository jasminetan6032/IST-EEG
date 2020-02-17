%% drawColourTiles.m
% Draw all flipped tiles in their respective colours thus far in this
% trial.
function drawColourTiles(fillCoords,flips,colourArr,win)
    for m=1:flips
        Screen('FillRect',win,colourArr(m,:),fillCoords(m,:));
    end
end