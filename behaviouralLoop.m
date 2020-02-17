%% BehaviouralLoop.m
% Main trial loop for behavioural experiments.

for t = 1 : length(trials)
    % Set any initial values for variables at the start of each trial.
    
    % Keep track of times when each tile is flipped.
    flipTimestamps = [];
    
    % Points to decrease by for the decreasing points condition.
    decPoints = vars.decreasingPointsStart;
    
    % Time of start of trial.
    trials(t).trialStart = GetSecs;
    
    % We find what the grid actually looks like underneath if every tile
    % was flipped.
    % This grid will be a bunch of 1s and 2s to signifiy colour 1 or colour
    % 2.
    grid = trials(t).trueGrid;
    % We 'hide' each of the colours using a grid of 0s.
    hiddenGrid = zeros(gridX,gridY);
    % Draw the line borders for the grid.
    vars = drawGrid(Sc.window,vars);
    % Draw the box for participants to click on in order to give their
    % final answer.
    drawAnswerBox(Sc.window,answerCoords);
    
    Screen('Flip',Sc.window);
    
    % We keep track of which tiles have been flipped, which colours have been revealed, 
    % how tiles are flipped, and when the user has decided to stop flipping
    % and when they have given their answer. (in below order)
    fillCoords = [];
    colourArr = [];
    numOfFlips = 0;
    flipEndFlag = 0;
    answerFlag = 0;
    
    % WHEN FLIP OCCURS
    while (flipEndFlag == 0)
        [x,y,buttons] = GetMouse;
        % If left mouse button is clicked
        if(buttons(1))
            while 1
                % Wait for mouse release.
                [x,y,buttons] = GetMouse; 
                if(~(buttons(1)))
                    % Find where on the screen has been clicked. 
                    X = x;
                    Y = y;
                    squareCoords = vars.squareCoords;
                    answerCoords = vars.answerCoords;
                    % Check screen coordinates for each of the grid tiles
                    for n=1:tiles
                        % If the click is within the square of a grid tile
                        if (X > squareCoords(1,n) && X < squareCoords(3,n) && Y > squareCoords(2,n) && Y < squareCoords(4,n))
                            % Get time of the flip.
                            flipTimestamps = [flipTimestamps GetSecs];
                            % Number of flips increment
                            numOfFlips = numOfFlips + 1;
                            % Deduct points in decreasing win condition
                            decPoints = decPoints - vars.decreasingDec;
                            % Get grid tile that was clicked
                            arrayY = tilesCoord(n,1);
                            arrayX = tilesCoord(n,2);
                            % Keep track of all flipped tiles so we can
                            % redraw for each screen flip.
                            fillCoords(numOfFlips,:) = squareCoords(:,n)';
                            % Check the colour to be shown for this grid
                            % tile (1 or 2)
                            if (grid(arrayX,arrayY) == 1)
                                colourArr(numOfFlips,:) = colours(1,:);
                                hiddenGrid(arrayX,arrayY) = 1;
                            else
                                colourArr(numOfFlips,:) = colours(2,:);
                                hiddenGrid(arrayX,arrayY) = 2;
                            end
                            
                            % Add fields for trial breakdown - this allows
                            % us to see what happens during each trial on a
                            % flip by flip basis.
                            trials(t).trialBreakdown(numOfFlips).flipNumber = numOfFlips;
                            trials(t).trialBreakdown(numOfFlips).colourRevealed = vars.colourNames(grid(arrayX,arrayY));
                            reducedGrid = nonzeros(hiddenGrid);
                            trials(t).trialBreakdown(numOfFlips).majorityColour = vars.colourNames(mode(reducedGrid));
                            trials(t).trialBreakdown(numOfFlips).majorityAmount = sum(reducedGrid==mode(reducedGrid))-sum(reducedGrid~=mode(reducedGrid));
                            trials(t).trialBreakdown(numOfFlips).majPCorrect = getPcorrect(mode(reducedGrid),reducedGrid,vars);
                            trials(t).trialBreakdown(numOfFlips).timestamp = flipTimestamps(numOfFlips);
                            if numOfFlips == 1
                                trials(t).trialBreakdown(numOfFlips).timeSinceLastFlip = flipTimestamps(1) - trials(t).trialStart;
                            else
                                trials(t).trialBreakdown(numOfFlips).timeSinceLastFlip = flipTimestamps(numOfFlips) - flipTimestamps(numOfFlips-1);
                            end
                            trials(t).trialBreakdown(numOfFlips).currentGrid = hiddenGrid;
                            trials(t).trialBreakdown(numOfFlips).tileClicked = [arrayX arrayY];
                            
                            % Draw all flipped tiles.
                            drawColourTiles(fillCoords,numOfFlips,colourArr,Sc.window)
                            % Redraw grid lines
                            vars = drawGrid(Sc.window,vars);
                            % Box to answer
                            drawAnswerBox(Sc.window,answerCoords);                     
                            Screen('Flip',Sc.window);
                            break;
                            
                            % If participant has indicated to provide a
                            % final answer.
                        elseif (X > answerCoords(1) && X < answerCoords(3) && Y > answerCoords(2) && Y < answerCoords(4) && numOfFlips > 0) 
                            flipEndFlag = 1;
                            trials(t).answerTime = GetSecs;
                            trials(t).numOfTilesRevealed = numOfFlips;
                            trials(t).finalGridState = hiddenGrid;
                            hiddenGrid = nonzeros(hiddenGrid);
                            trials(t).majorityRevealed = vars.colourNames(mode(hiddenGrid));
                            trials(t).finalPCorrect = getPcorrect(mode(hiddenGrid),trials(t).finalGridState,vars);
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
    % Draw choice of colours for the final decision.
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
                    % left colour selected
                    if (X > optionCoords(1,1) && X < optionCoords(3,1) && Y > optionCoords(2,1) && Y < optionCoords(4,1))
                        trials(t).finalAnswerTime = GetSecs;
                        trials(t).finalAns = 1;
                        trials(t).finalColour = vars.colourNames(1);
                        % Check if answer provided was correct.
                        if (trials(t).trueAns == 1)
                            trials(t).correct = 1;
                            trialText = "correct!";
                            % points update
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
                            % Audio tone for incorrect answers.
                            Beeper(1000,.4,.5);
                            % Points update
                            points = points - vars.wrongPointsLoss;
                            trials(t).reward = vars.wrongPointsLoss*-1;
                        end
                        % Break out of the outer while loop
                        answerFlag = 1;
                        break
                        
                    % right colour selected
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
                        % In case the click occurred somewhere else other
                        % than one of the option boxes.
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