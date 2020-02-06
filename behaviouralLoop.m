for t = 1 : length(trials)
    flipTimestamps = [];
    decPoints = vars.decreasingPointsStart;
    
    % Time of start of trial.
    trials(t).trialStart = GetSecs;
    
    grid = trials(t).trueGrid;
    hiddenGrid = zeros(gridX,gridY);
    vars = drawGrid(Sc.window,vars);
    drawAnswerBox(Sc.window,answerCoords);
    Screen('Flip',Sc.window);
    
    fillCoords = [];
    colourArr = [];
    numOfFlips = 0;
    flipEndFlag = 0;
    answerFlag = 0;
    % WHEN FLIP OCCURS
    while (flipEndFlag == 0)
        [x,y,buttons] = GetMouse;
        % If mouse button is clicked
        if(buttons(1))
            while 1
                % Wait for mouse release.
                [x,y,buttons] = GetMouse; 
                if(~(buttons(1)))
                    X = x;
                    Y = y;
                    squareCoords = vars.squareCoords;
                    answerCoords = vars.answerCoords;
                    for n=1:tiles
                        if (X > squareCoords(1,n) && X < squareCoords(3,n) && Y > squareCoords(2,n) && Y < squareCoords(4,n))
                            flipTimestamps = [flipTimestamps GetSecs];
                            numOfFlips = numOfFlips + 1;
                            decPoints = decPoints - vars.decreasingDec;
                            arrayY = tilesCoord(n,1);
                            arrayX = tilesCoord(n,2);
                            fillCoords(numOfFlips,:) = squareCoords(:,n)';
                            if (grid(arrayX,arrayY) == 1)
                                colourArr(numOfFlips,:) = colours(1,:);
                                hiddenGrid(arrayX,arrayY) = 1;
                            else
                                colourArr(numOfFlips,:) = colours(2,:);
                                hiddenGrid(arrayX,arrayY) = 2;
                            end
                            drawColourTiles(fillCoords,numOfFlips,colourArr,Sc.window)
                            vars = drawGrid(Sc.window,vars);
                            drawAnswerBox(Sc.window,answerCoords);
                            Screen('Flip',Sc.window);
                            break;
                        elseif (X > answerCoords(1) && X < answerCoords(3) && Y > answerCoords(2) && Y < answerCoords(4) && numOfFlips > 0) 
                            flipEndFlag = 1;
                            trials(t).answerTime = GetSecs;
                            trials(t).numOfTilesRevealed = numOfFlips;
                            trials(t).finalGridState = hiddenGrid;
                            hiddenGrid = nonzeros(hiddenGrid);
                            trials(t).majorityRevealed = vars.colourNames(mode(hiddenGrid));
                            trials(t).majorityMargin = sum(hiddenGrid==mode(hiddenGrid))-sum(hiddenGrid~=mode(hiddenGrid));
                            break;
                        end
                    end
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
                    X = x;
                    Y = y;
                    if (X > optionCoords(1,1) && X < optionCoords(3,1) && Y > optionCoords(2,1) && Y < optionCoords(4,1))
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
                            points = points - vars.wrongTokenLoss;
                            trials(t).reward = vars.wrongTokenLoss*-1;
                        end
                        answerFlag = 1;
                        break
                    elseif (X > optionCoords(1,2) && X < optionCoords(3,2) && Y > optionCoords(2,2) && Y < optionCoords(4,2))
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
                    else
                        answerFlag = 0;
                    end
                end
            end
            break;
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