for t = 1 : length(trials)
    flipTimestamps = [];
    decPoints = vars.decreasingPointsStart;
    
    % Time of start of trial.
    trials(t).trialStart = GetSecs;
    
    tilesCoord(:,3) = 0;
    grid = trials(t).trueGrid;
    hiddenGrid = zeros(gridX,gridY);
    
    fillCoords = [];
    colourArr = [];
    numOfFlips = 0;
    flipEndFlag = 0;
    answerFlag = 0;
    
    nextToFlip = ceil(rand*25);
    while (tilesCoord(nextToFlip,3) == 1)
        nextToFlip = ceil(rand*25);
    end
    tilesCoord(nextToFlip,3) = 1;
    Screen('FillRect',Sc.window,vars.colourCodeN,squareCoords(:,nextToFlip)');
    vars = drawGrid(Sc.window,vars);
    Screen('Flip',Sc.window);
    % WHEN FLIP OCCURS
    while (flipEndFlag == 0)
        [x,y,buttons] = GetMouse;
        % If left mouse button is clicked
        if(buttons(1))
            while 1
                % Wait for mouse release.
                [x,y,buttons] = GetMouse; 
                if(~(buttons(1)))
                    flipTimestamps = [flipTimestamps GetSecs];
                    numOfFlips = numOfFlips + 1;
                    decPoints = decPoints - vars.decreasingDec;
                    arrayY = tilesCoord(nextToFlip,1);
                    arrayX = tilesCoord(nextToFlip,2);
                    fillCoords(numOfFlips,:) = squareCoords(:,nextToFlip)';
                    if (grid(arrayX,arrayY) == 1)
                        colourArr(numOfFlips,:) = colours(1,:);
                        hiddenGrid(arrayX,arrayY) = 1;
                    else
                        colourArr(numOfFlips,:) = colours(2,:);
                        hiddenGrid(arrayX,arrayY) = 2;
                    end
                    drawColourTiles(fillCoords,numOfFlips,colourArr,Sc.window)
                    vars = drawGrid(Sc.window,vars);
                    nextToFlip = ceil(rand*25);
                    while (tilesCoord(nextToFlip,3) == 1)
                        nextToFlip = ceil(rand*25);
                    end
                    tilesCoord(nextToFlip,3) = 1;
                    
                    trials(t).trialBreakdown(numOfFlips).flipNumber = numOfFlips;
                    trials(t).trialBreakdown(numOfFlips).colourRevealed = vars.colourNames(grid(arrayX,arrayY));
                    reducedGrid = nonzeros(hiddenGrid);
                    trials(t).trialBreakdown(numOfFlips).majorityAmount = sum(reducedGrid==mode(reducedGrid))-sum(reducedGrid~=mode(reducedGrid));
                    if (trials(t).trialBreakdown(numOfFlips).majorityAmount == 0)
                        trials(t).trialBreakdown(numOfFlips).majorityColour = 'neither';
                    else
                        trials(t).trialBreakdown(numOfFlips).majorityColour = vars.colourNames(mode(reducedGrid));
                    end
                    trials(t).trialBreakdown(numOfFlips).majPCorrect = getPcorrect(mode(reducedGrid),reducedGrid,vars);
                    trials(t).trialBreakdown(numOfFlips).timestamp = flipTimestamps(numOfFlips);
                    if numOfFlips == 1
                        trials(t).trialBreakdown(numOfFlips).timeSinceLastFlip = flipTimestamps(1) - trials(t).trialStart;
                    else
                        trials(t).trialBreakdown(numOfFlips).timeSinceLastFlip = flipTimestamps(numOfFlips) - flipTimestamps(numOfFlips-1);
                    end
                    trials(t).trialBreakdown(numOfFlips).currentGrid = hiddenGrid;
                    trials(t).trialBreakdown(numOfFlips).tileClicked = [arrayX arrayY];
                    
                    Screen('FillRect',Sc.window,vars.colourCodeN,squareCoords(:,nextToFlip)');
                    Screen('Flip',Sc.window);
                    break;
                end
            end
        end
        if((buttons(2)||buttons(3))&&numOfFlips>0)
            while 1
                % Wait for mouse release.
                [x,y,buttons] = GetMouse; 
                if(~buttons(2)&&~buttons(3))
                    trials(t).finalGridState = hiddenGrid;
                    hiddenGrid = nonzeros(hiddenGrid);
                    trials(t).numOfTilesRevealed = numOfFlips;
                    trials(t).majorityMargin = sum(hiddenGrid==mode(hiddenGrid))-sum(hiddenGrid~=mode(hiddenGrid));
                    if (trials(t).majorityMargin == 0)
                        trials(t).majorityRevealed = 'neither';
                    else
                        trials(t).majorityRevealed = vars.colourNames(mode(hiddenGrid));
                    end
                    trials(t).finalPCorrect = getPcorrect(mode(hiddenGrid),trials(t).finalGridState,vars);
                    flipEndFlag = 1;
                    break;
                end
            end
        end
    end
    drawColourTiles(fillCoords,numOfFlips,colourArr,Sc.window)
    vars = drawGrid(Sc.window,vars);
    drawOptions(Sc.window,colours(1,:),colours(2,:),optionCoords)
    Screen('Flip',Sc.window);
    while (answerFlag == 0)
        [x,y,buttons] = GetMouse;
        % If mouse button is clicked
        if(buttons(1))
            while 1
                % Wait for mouse release.
                [x,y,buttons] = GetMouse; 
                if(~(buttons(1)))
                    trials(t).finalAnswerTime = GetSecs;
                    trials(t).finalAns = 1;
                    trials(t).finalColour = vars.colourNames(1);
                    if (trials(t).trueAns == 1)
                        trials(t).correct = 1;
                        trialText = "correct!";
                        if (trials(t).type ~= 'decreasing')
                            points = points + vars.fixedPointsWin;
                            trials(t).reward = vars.fixedPointsWin;
                        else
                            points = points + decPoints;
                            trials(t).reward = decPoints;
                        end
                    else
                        trials(t).correct = 0;
                        trialText = "incorrect!";
                        Beeper(1000,.4,.5);
                        points = points - vars.wrongTokenLoss;
                        trials(t).reward = vars.wrongTokenLoss*-1;
                    end
                    answerFlag = 1;
                    break;
                end
            end
        elseif (buttons(2)||buttons(3))
            while 1
                % Wait for mouse release.
                [x,y,buttons] = GetMouse; 
                if(~(buttons(2))&&~(buttons(3)))
                    trials(t).finalAnswerTime = GetSecs;
                    trials(t).finalAns = 2;
                    trials(t).finalColour = vars.colourNames(2);
                    if (trials(t).trueAns == 2)
                        trials(t).correct = 1;
                        trialText = "correct!";
                        if (trials(t).type ~= 'decreasing')
                            points = points + vars.fixedPointsWin;
                            trials(t).reward = vars.fixedPointsWin;
                        else
                            points = points + decPoints;
                            trials(t).reward = decPoints;
                        end
                    else
                        trials(t).correct = 0;
                        trialText = "incorrect!";
                        points = points - vars.wrongTokenLoss;
                        trials(t).reward = vars.wrongTokenLoss*-1;
                    end
                    answerFlag = 1;
                    break;
                end
            end
        end
    end
    % TRIAL OVER
    trials(t).trialEnd = GetSecs;
    trials(t).averageTimeBetweenFlips = mean(flipTimestamps);
    trials(t).trialTime = trials(t).trialEnd - trials(t).trialStart;
    trials(t).totalPoints = points;
    
    drawColourTiles(fillCoords,numOfFlips,colourArr,Sc.window)
    vars = drawGrid(Sc.window,vars);
    %DrawFormattedText(Sc.window, trialText,trialx,trialy,[0 0 0]);
    Screen('Flip',Sc.window);
    
    if trials(t).break
        save([pwd '/' vars.rawdata_path num2str(subject.id) '/behaviour/' subject.fileName '_' num2str(round(t/vars.expBlockLength))],'trials', 'vars', 'subject', 't');
        correct = [trials(1:t).correct];
        text = ['You currently have ' num2str(points) ' points' newline newline 'Your accuracy up until this point is ' num2str((sum(correct)/t)*100) '%'];
        text = [text newline newline newline 'You may now take a break. Click on the screen to continue.'];
        DrawFormattedText(Sc.window, text,'center', 'center', [0 0 0]);
        Screen('Flip', Sc.window);
        hasconfirmed = false;
        while 1
            [x,y,buttons] = GetMouse;
            % If mouse button is clicked
            if(buttons(1))
                X = x;
                Y = y;
                while 1
                    % Wait for mouse release.
                    [x,y,buttons] = GetMouse; 
                    if(~(buttons(1)))
                        break;
                    end
                end
            end
            break;
        end
    end
end