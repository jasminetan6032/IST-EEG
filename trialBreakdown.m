% Add fields for trial breakdown - this allows
% us to see what happens during each trial on a
% flip by flip basis.
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