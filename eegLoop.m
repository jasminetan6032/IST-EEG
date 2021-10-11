%% eegLoop.m
% Main trial loop for eeg experiments.

newConditionInstructs(t,trials,vars,Sc)

SetMouse(centerX, centerY);
HideCursor();
flipTimestamps = [];
decPoints = vars.decreasingPointsStart;

tilesCoord(:,3) = 0;
% Set the grid for this trial and start the initial visible grid to all 0s.
grid = trials(t).trueGrid;
hiddenGrid = zeros(gridX,gridY);

% Reset all tracking variables for the trial.
fillCoords = [];
colourArr = [];
numOfFlips = 0;
flipEndFlag = 0;
answerFlag = 0;
forcedFlag = 0;
flip25Flag = 0;

nextToFlip = ceil(rand*25);
while (tilesCoord(nextToFlip,3) == 1)
    nextToFlip = ceil(rand*25);
end
tilesCoord(nextToFlip,3) = 1;
vars = drawGrid(Sc.window,vars,trials,t,0);
squareCoords = vars.squareCoords;
Screen('FillRect',Sc.window,vars.colourCodeN,squareCoords(:,nextToFlip)');
Screen('Flip',Sc.window);
% Time of start of trial.
trials(t).trialStart = GetSecs;

% WHEN FLIP OCCURS
while (flipEndFlag == 0)
    [x,y,buttons] = GetMouse;
    % If left mouse button is clicked
    if(buttons(1))
        if numOfFlips < 25
            while 1
                %add trigger for flip
                %sendTrig(numOfFlips,useport);
                % Wait for mouse release.
                [x,y,buttons] = GetMouse;
                if(~(buttons(1)))
                    %Wait 1 second
                    WaitSecs(1)
                    % Record time when flip occured.
                    flipTimestamps = [flipTimestamps GetSecs];
                    % Increment number of flips for this trial.
                    numOfFlips = numOfFlips + 1;
                    %add trigger for reveal = numOfFlips (necessary?)
                    % For decreasing trials, deduct reward points for flip.
                    decPoints = decPoints - vars.decreasingDec;
                    % Get coordinates of tile that was flipped.
                    arrayY = tilesCoord(nextToFlip,1);
                    arrayX = tilesCoord(nextToFlip,2);
                    % Add this tile to the array of flipped tiles, used in the
                    % drawColourTiles function.
                    fillCoords(numOfFlips,:) = squareCoords(:,nextToFlip)';
                    % Get the colour of the flipped tile to paint it.
                    if (grid(arrayX,arrayY) == 1)
                        colourArr(numOfFlips,:) = colours(1,:);
                        hiddenGrid(arrayX,arrayY) = 1;
                    else
                        colourArr(numOfFlips,:) = colours(2,:);
                        hiddenGrid(arrayX,arrayY) = 2;
                    end
                    % Draw the new flipped tile and all tiles flipped up to
                    % this point in the trial.
                    drawColourTiles(fillCoords,numOfFlips,colourArr,Sc.window)
                    % Redraw the grid.
                    vars = drawGrid(Sc.window,vars,trials,t,0);
                    % Get the next tile that will be flipped.
                    % This while loop forces that we keep randomly picking a
                    % tile until we get one that has not been flipped already.
                    nextToFlip = ceil(rand*25);
                    while (tilesCoord(nextToFlip,3) == 1)&& numOfFlips < 25
                        nextToFlip = ceil(rand*25);
                    end
                    tilesCoord(nextToFlip,3) = 1;
                    
                    trialBreakdown;
                    
                    % If this variable exists, it means we can set the point
                    % where participants are forced to respond on Forced
                    % trials.
                    if (exist('forcedPLevel','var') == 1)
                        if (forcedPLevel < trials(t).trialBreakdown(numOfFlips).majPCorrect)
                            forcedFlag = 1;
                        end
                    end
                    
                    if numOfFlips < 25
                        % Colour the next tile to be flipped black.
                        Screen('FillRect',Sc.window,vars.colourCodeN,squareCoords(:,nextToFlip)');
                        Screen('Flip',Sc.window);
                    end
                    
                    while numOfFlips == 25
                        KbName('UnifyKeyNames');
                        % specify key names of interest in the study
                        activeKeys = [KbName('space')];
                        RestrictKeysForKbCheck(activeKeys);
                        % suppress echo to the command line for keypresses
                        ListenChar(2);
                        
                        % check if spacebar is pressed
                        [ keyIsDown, keyTime, keyCode ] = KbCheck;
                        if(keyIsDown)
                            while 1
                                %insert trigger for answer
                                %             sendTrig(99,useport);
                                % Wait for key release.
                                [ keyIsDown, keyTime, keyCode ] = KbCheck;
                                if(~(keyIsDown))
                                    % Breaks us out of the loop of flipping and sends us to answer.
                                    flip25Flag = 1;
                                    break;
                                end
                            end
                        end
                        % if the wait for presses is in a loop,
                        % then the following two commands should come after the loop finishes
                        % reset the keyboard input checking for all keys
                        RestrictKeysForKbCheck;
                        % re-enable echo to the command line for key presses
                        % if code crashes before reaching this point
                        % CTRL-C will reenable keyboard input
                        ListenChar(1);
                        break;
                    end
                    break;
                end
            end
            %         else
            %             flipEndFlag = 1;
        end
    end
    % Ok, this condition is a bit of mess.
    % This branch is when the participant is giving their answer.
    % We trigger this in two scenarios:
    % 1. On a fixed or decreasing trial, the space bar is pressed AND
    % there is at least one flipped tile on the grid.
    % 2. On a forced trial, the current PCorrect is greater than the
    % average PCorrect when decisions were made during the fixed trials.
    
    % improve portability of your code across operating systems
    KbName('UnifyKeyNames');
    % specify key names of interest in the study
    activeKeys = [KbName('space')];
    RestrictKeysForKbCheck(activeKeys);
    % suppress echo to the command line for keypresses
    ListenChar(2);
    
    % check if spacebar is pressed
    [ keyIsDown, keyTime, keyCode ] = KbCheck;
    if((keyIsDown)&&numOfFlips>0&&~strcmp(trials(t).type,'forced')||flip25Flag==1)
        while 1
            %insert trigger for answer
            %             sendTrig(99,useport);
            % Wait for key release.
            [ keyIsDown, keyTime, keyCode ] = KbCheck;
            if(~(keyIsDown))
                % Record what the grid looks like when the decision was
                % made.
                trials(t).finalGridState = hiddenGrid;
                hiddenGrid = nonzeros(hiddenGrid);
                % See what the most prevalent colour and what amount in the
                % final grid state that the participant could see.
                trials(t).majorityMargin = sum(hiddenGrid==mode(hiddenGrid))-sum(hiddenGrid~=mode(hiddenGrid));
                if (trials(t).majorityMargin == 0)
                    trials(t).majorityRevealed = 'neither';
                else
                    trials(t).majorityRevealed = vars.colourNames(mode(hiddenGrid));
                end
                % PCorrect at decision point.
                trials(t).finalPCorrect = getPcorrect(mode(hiddenGrid),trials(t).finalGridState,vars);
                % Breaks us out of the loop of flipping.
                flipEndFlag = 1;
                break;
            end
        end
    end
    % if the wait for presses is in a loop,
    % then the following two commands should come after the loop finishes
    % reset the keyboard input checking for all keys
    RestrictKeysForKbCheck;
    % re-enable echo to the command line for key presses
    % if code crashes before reaching this point
    % CTRL-C will reenable keyboard input
    ListenChar(1)
end
% Keep grid the same and present choice of colour to answer for the
% participant.
drawColourTiles(fillCoords,numOfFlips,colourArr,Sc.window);
vars = drawGrid(Sc.window,vars,trials,t,1);
drawOptions(Sc.window,colours(1,:),colours(2,:),optionCoords);
Screen('Flip',Sc.window);
while (answerFlag == 0)
    [x,y,buttons] = GetMouse;
    % If left mouse button is clicked, we choose the left colour.
    if(buttons(1))
        while 1
            % Wait for mouse release.
            [x,y,buttons] = GetMouse;
            if(~(buttons(1)))
                trials(t).finalAnswerTime = GetSecs;
                trials(t).finalAns = 1;
                trials(t).finalColour = vars.colourNames(1);
                % Correct answer!
                if (trials(t).trueAns == 1)
                    trials(t).correct = 1;
                    trialText = 'correct!';
                    % Award points depending on condition.
                    if (~strcmp(trials(t).type,'decreasing'))
                        points = points + vars.fixedPointsWin;
                        trials(t).reward = vars.fixedPointsWin;
                    else
                        points = points + decPoints;
                        trials(t).reward = decPoints;
                    end
                    % Wrong answer!
                else
                    trials(t).correct = 0;
                    trialText = 'incorrect!';
                    % Deduct points.
                    points = points - vars.wrongPointsLoss;
                    trials(t).reward = vars.wrongPointsLoss*-1;
                end
                % Break out of loop of waiting for an answer.
                answerFlag = 1;
                break;
            end
        end
        % If right mouse button is clicked, we choose the right colour.
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
                    trialText = 'correct!';
                    if (~strcmp(trials(t).type,'decreasing'))
                        points = points + vars.fixedPointsWin;
                        trials(t).reward = vars.fixedPointsWin;
                    else
                        points = points + decPoints;
                        trials(t).reward = decPoints;
                    end
                else
                    trials(t).correct = 0;
                    trialText = 'incorrect!';
                    points = points - vars.wrongPointsLoss;
                    trials(t).reward = vars.wrongPointsLoss*-1;
                end
                answerFlag = 1;
                break;
            end
        end
    end
end
trialOver;

if trials(t).break
    trialBreak;
end
