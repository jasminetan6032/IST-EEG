%% eegLoop.m
% Main trial loop for eeg experiments.

newConditionInstructs(t,trials,vars,Sc)

if((vars.practice) && t == 2)
    vars.colourCode1 = [0.1176    0.5647    1.0000];
    vars.colourCode2 = [0 1 0.4980];
    vars.colourCodeN = [0,0,0];
    vars.colourNames = {'blue','green','black'};
    colours = [vars.colourCode1; vars.colourCode2];
vars.colours = colours;
end

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
cjSampleFlag = 0;

%creates random sampling of confidence every 5 flips
cjsamples = [];
cjsamples(1) = randi([1 5]);
cjsamples(2) = randi([6 10]);
cjsamples(3) = randi([11 15]);
cjsamples(4) = randi([16 20]);
cjsamples(5) = randi([21 25]);

nextToFlip = ceil(rand*25);
while (tilesCoord(nextToFlip,3) == 1)
    nextToFlip = ceil(rand*25);
end
tilesCoord(nextToFlip,3) = 1;
vars = drawGrid(Sc.window,vars,trials,t,0);
squareCoords = vars.squareCoords;
Screen('FillRect',Sc.window,vars.colourCodeN,squareCoords(:,nextToFlip)');
Screen('Flip',Sc.window);
if (vars.triggers)
    sendTrig(33,useport);
end
% Time of start of trial.
trials(t).trialStart = GetSecs;

% WHEN FLIP OCCURS
while (flipEndFlag == 0)
    [x,y,buttons] = GetMouse;
    % If left mouse button is clicked and number of flips is not 25
    if(buttons(1) && (numOfFlips < 24))%<25
        %add trigger for flip
        if (vars.triggers)
            trigger_flip = numOfFlips + 1;
            sendTrig(trigger_flip,useport);
        end
        while 1
            % Wait for mouse release.
            [x,y,buttons] = GetMouse;
            if(~(buttons(1)))
                %Wait 1 second
                WaitSecs(0.5)
                % Record time when flip occured.
                flipTimestamps = [flipTimestamps GetSecs];
                % Increment number of flips for this trial.
                numOfFlips = numOfFlips + 1;
                %Re-initialise cjSampleFlag in case it was called after
                %the last flip
                cjSampleFlag = 0;
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
                trialBreakdown;
                %trigger for colour reveal
                %31 for majority colour, 32 for minority colour
                Screen('Flip',Sc.window);
                if (vars.triggers)
                    if strcmp(trials(t).trialBreakdown(numOfFlips).colourRevealed,trials(t).trueColour)
                        sendTrig(31,useport);
                    else
                        sendTrig(32,useport);
                    end
                end
                WaitSecs(1);
                
                
                %check if confidence should be randomly sampled
                for n = 1:length(cjsamples)
                    if numOfFlips == cjsamples(n)
                        drawColourTiles(fillCoords,numOfFlips,colourArr,Sc.window);
                        vars = drawGrid(Sc.window,vars,trials,t,1);
                        %collect confidence sample
                        if (vars.triggers)
                            sendTrig (50,useport)
                            [trials(t).trialBreakdown(numOfFlips).Cjsample, trials(t).trialBreakdown(numOfFlips).CjsampleTime, ...
                                trials(t).trialBreakdown(numOfFlips).cjLoc,trials(t).trialBreakdown(numOfFlips).cjDidRespond] = ...
                                cjSlider_eeg(Sc,vars,cfg,fillCoords,numOfFlips,colourArr,trials,t,1,useport);
                        else
                            [trials(t).trialBreakdown(numOfFlips).Cjsample, trials(t).trialBreakdown(numOfFlips).CjsampleTime, ...
                                trials(t).trialBreakdown(numOfFlips).cjLoc,trials(t).trialBreakdown(numOfFlips).cjDidRespond] = ...
                                cjSlider(Sc,vars,cfg,fillCoords,numOfFlips,colourArr,trials,t,1);
                        end
                        
                        Screen('Flip',Sc.window);
                        % Draw the new flipped tile and all tiles flipped up to
                        % this point in the trial.
                        drawColourTiles(fillCoords,numOfFlips,colourArr,Sc.window)
                        % Redraw the grid.
                        vars = drawGrid(Sc.window,vars,trials,t,0);
                        Screen('Flip',Sc.window);
                        WaitSecs(1);
                        %note that confidence sample was collected
                        cjSampleFlag = 1;
                    end
                end
                
                % If this variable exists, it means we can set the point
                % where participants are forced to respond on Forced
                % trials.
                if (exist('forcedPLevel','var') == 1)
                    if (forcedPLevel < trials(t).trialBreakdown(numOfFlips).majPCorrect)
                        forcedFlag = 1;
                    end
                end
                
                %if numOfFlips < 25 %because already incremented
                % Get the next tile that will be flipped.
                % This while loop forces that we keep randomly picking a
                % tile until we get one that has not been flipped already.
                nextToFlip = ceil(rand*25);
                while (tilesCoord(nextToFlip,3) == 1)&& numOfFlips < 25
                    nextToFlip = ceil(rand*25);
                end
                tilesCoord(nextToFlip,3) = 1;
                
                % Draw the new flipped tile and all tiles flipped up to
                % this point in the trial.
                drawColourTiles(fillCoords,numOfFlips,colourArr,Sc.window)
                % Redraw the grid.
                vars = drawGrid(Sc.window,vars,trials,t,0);
                % Colour the next tile to be flipped black. Flip screen to
                % show black tile.
                Screen('FillRect',Sc.window,vars.colourCodeN,squareCoords(:,nextToFlip)');
                Screen('Flip',Sc.window);
                if (vars.triggers)
                    sendTrig(33,useport);
                end
                
                break;
            end
        end
    end
    
    if(buttons(1) && (numOfFlips == 24))
        %add trigger for flip
        if (vars.triggers)
            sendTrig(25,useport);
        end
        while 1
            % Wait for mouse release.
            [x,y,buttons] = GetMouse;
            if(~(buttons(1)))
                %Wait 1 second
                WaitSecs(1)
                % Record time when flip occured.
                flipTimestamps = [flipTimestamps GetSecs];
                % Increment number of flips for this trial.
                numOfFlips = numOfFlips + 1;
                cjSampleFlag = 0;
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
                trialBreakdown;
                Screen('Flip',Sc.window);
                %add trigger for colour reveal
                %31 is majority colour, 32 is minority colour
                if (vars.triggers)
                    if strcmp(trials(t).trialBreakdown(numOfFlips).colourRevealed,trials(t).trueColour)
                        sendTrig(31,useport);
                    else
                        sendTrig(32,useport);
                    end
                end
                break
            end
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
    if((keyIsDown)&&numOfFlips>0&&~strcmp(trials(t).type,'forced'))
        while 1
            %insert trigger for answer
            if (vars.triggers)
                sendTrig(99,useport);
            end
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
                drawColourTiles(fillCoords,numOfFlips,colourArr,Sc.window);
                vars = drawGrid(Sc.window,vars,trials,t,1);
                highlightLeftOption(Sc.window,colours(1,:),colours(2,:),optionCoords);
                Screen('Flip',Sc.window);
                WaitSecs(1);
                trials(t).finalAnswerTime = GetSecs;
                trials(t).finalAns = 1;
                trials(t).finalColour = vars.colourNames(1);
                % Correct answer!
                if (trials(t).trueAns == 1)
                    trials(t).correct = 1;
                    trialText = 'Correct!';
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
                    trialText = 'Incorrect!';
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
                drawColourTiles(fillCoords,numOfFlips,colourArr,Sc.window);
                vars = drawGrid(Sc.window,vars,trials,t,1);
                highlightRightOption(Sc.window,colours(1,:),colours(2,:),optionCoords);
                Screen('Flip',Sc.window);
                WaitSecs(1);
                trials(t).finalAnswerTime = GetSecs;
                trials(t).finalAns = 2;
                trials(t).finalColour = vars.colourNames(2);
                if (trials(t).trueAns == 2)
                    trials(t).correct = 1;
                    trialText = 'Correct!';
                    if (~strcmp(trials(t).type,'decreasing'))
                        points = points + vars.fixedPointsWin;
                        trials(t).reward = vars.fixedPointsWin;
                    else
                        points = points + decPoints;
                        trials(t).reward = decPoints;
                    end
                else
                    trials(t).correct = 0;
                    trialText = 'Incorrect!';
                    points = points - vars.wrongPointsLoss;
                    trials(t).reward = vars.wrongPointsLoss*-1;
                end
                answerFlag = 1;
                break;
            end
        end
    end
end
if cjSampleFlag == 1
    trialOverNoCj;
else
    trialOver;
end

if trials(t).break
    trialBreak;
end
