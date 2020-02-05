function drawColourTiles(fillCoords,flips,colourArr,win)
    for m=1:flips
        Screen('FillRect',win,colourArr(m,:),fillCoords(m,:));
    end
end