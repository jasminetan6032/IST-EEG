function [vars] = drawGrid(win,vars)

    winAreaX = vars.resX;
    winAreaY = vars.resY;
    gridAreaX = vars.gridX;
    gridAreaY = vars.gridY;
    centerX = winAreaX/2;
    centerY = winAreaY/2;
    colour1 = vars.colourCode1;
    colour2 = vars.colourCode2;
    
    tilesX = vars.gridDimX;
    tilesY = vars.gridDimY;
    
    gridCorner1 = centerX - (gridAreaX/2);
    gridCorner2 = centerY - (gridAreaY/2);
    gridCorner3 = centerX + (gridAreaX/2);
    gridCorner4 = centerY + (gridAreaY/2);
    
    penWidth = 3;
    
    Screen('FrameRect',win,[0,0,0],[gridCorner1 gridCorner2 gridCorner3 gridCorner4],penWidth);
    
    squareWidth = gridAreaX/tilesX;
    squareCoords = [];
    
    c = [gridCorner1, gridCorner2, gridCorner1+squareWidth, gridCorner2+squareWidth];
    c2 = c(2);
    c4 = c(4);
    count = 1;
    for n=1:tilesX
        for m=1:tilesY
            squareCoords(1,count) = c(1);
            squareCoords(2,count) = c(2);
            squareCoords(3,count) = c(3);
            squareCoords(4,count) = c(4);
            count = count + 1;
            if (m == tilesY)
                c(2) = c2;
                c(4) = c4;
                c(1) = c(1) + squareWidth;
                c(3) = c(3) + squareWidth;
            else
                c(2) = c(2) + squareWidth;
                c(4) = c(4) + squareWidth;
            end
        end
    end
    Screen('FrameRect',win,[0,0,0],squareCoords,penWidth);
    vars.squareCoords = squareCoords;
%     text = "Click on tiles in the grid to reveal their colour.";
%     text = [text newline newline "When you are ready to answer, click the Answer button below"];
%     textY = winAreaY*0.1;
%     Screen('TextSize',win,12);
%     DrawFormattedText(win,text,'center',textY,[0 0 0]);
end