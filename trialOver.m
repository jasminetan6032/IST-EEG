% TRIAL OVER
trials(t).trialEnd = GetSecs;
trials(t).averageTimeBetweenFlips = mean(flipTimestamps);
trials(t).trialTime = trials(t).trialEnd - trials(t).trialStart;
trials(t).totalPoints = points;

subject.totalFlips = subject.totalFlips + numOfFlips;
subject.totalTime = subject.totalTime + trials(t).trialTime;
subject.numOfTrials = subject.numOfTrials + 1;

vars.withinBlockNumber = vars.withinBlockNumber + 1;

drawColourTiles(fillCoords,numOfFlips,colourArr,Sc.window)
vars = drawGrid(Sc.window,vars,trials,t,1);
[trials(t).finalCj, trials(t).finalCjTime, ...
    trials(t).cjLoc,trials(t).cjDidRespond] = ...
    cjSlider(Sc,vars,cfg,fillCoords,numOfFlips,colourArr,trials,t,1);

if (trials(t).correct == 0)
    % Audio tone for incorrect answers.
    Beeper(1000,.4,.5);
end

if trials(t).correct == 1
    feedback = [trialText newline newline 'You have earned ' num2str(trials(t).reward) ' points'];
    feedback_trigger = 40;
else
    feedback = [trialText newline newline 'You have lost ' num2str(vars.wrongPointsLoss) ' points'];
    feedback_trigger = 41;
end
DrawFormattedText(Sc.window, feedback,'center', trialy, [1 1 1]);
Screen('Flip',Sc.window);
% sendTrig(feedback_trigger,useport);
WaitSecs(1);