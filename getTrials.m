%% getTrials.m
% Setup the trials struct and generate all our trials.
function [trials] = getTrials(vars)

    if (strcmp(vars.expLengthMeasure,'trials'))
        % Total number of trials across the experiment.
        numOfExpTrials = vars.numOfExpBlocks*vars.expBlockLength;
        b = numOfExpTrials;
    else
        b = 200;
    end
        
    blockToAssign = 1;
    blockCounter = 1;
    colourNames = vars.colourNames;
    X = vars.gridDimX;
    Y = vars.gridDimY;
    tiles = X*Y;

    % Column headings.
    trials = struct('trialNumber',cell(1,b),'block',cell(1,b),...
    'break',cell(1,b),'type',cell(1,b),'numOfColour1',cell(1,b),'numOfColour2',cell(1,b),...
    'finalAns',cell(1,b),'finalColour',cell(1,b),'finalPCorrect',cell(1,b),'finalCj',cell(1,b),'finalCjTime',cell(1,b),...
    'cjLoc',cell(1,b),'cjDidRespond',cell(1,b),'trueAns',cell(1,b),'trueColour',cell(1,b),'correct',cell(1,b),...
    'numOfTilesRevealed',cell(1,b),'majorityRevealed',cell(1,b),'majorityMargin',cell(1,b),...
    'trialStart',cell(1,b),'answerTime',cell(1,b),'finalAnswerTime',cell(1,b),'trialEnd',cell(1,b),'trialTime',cell(1,b),...
    'averageTimeBetweenFlips',cell(1,b),'reward',cell(1,b),'totalPoints',cell(1,b),'trueGrid',...
    cell(1,b),'trueColourGrid',cell(1,b),'finalGridState',cell(1,b),'trialBreakdown',struct('flipNumber',cell(1,1),'colourRevealed',...
            cell(1,1),'majorityColour',cell(1,1),'majorityAmount',cell(1,1),'majPCorrect',cell(1,1),...
            'timestamp',cell(1,1),'timeSinceLastFlip',cell(1,1),'currentGrid',...
            cell(1,1),'tileClicked',cell(1,1)));
        
        
    for n = 1:b
        % Load up trial numbers.
        trials(n).trialNumber = n;
        trials(n).break = 0;
        trialTot = vars.expBlockLength;
        trials(n).block = blockToAssign;
        typesBlocks = vars.expBlocks;
        typeOrder = vars.expStructure;
        if blockToAssign <= typesBlocks(1)
            trials(n).type = typeOrder(1);
        elseif blockToAssign <= (typesBlocks(1)+typesBlocks(2))
            trials(n).type = typeOrder(2);
        else
            trials(n).type = typeOrder(3);
        end
        % We assign block numbers to each trial based on how many trials we
        % know is in each block.
        if blockCounter == trialTot
            blockCounter = 1;
            trials(n).break = 1;
            blockToAssign = blockToAssign + 1;
        else
            blockCounter = blockCounter + 1;
        end
        
        % Randomly decide what is our correct answer for each trial.
        % 1 is left colour, 2 is right.
        % This matches colours 1 and 2 in varSet.
        trueAns = round(rand(1))+1;
        trials(n).trueAns = trueAns;
        trials(n).trueColour = colourNames(trueAns);
        
        % Initialise our grids for each trial
        grid = zeros(X,Y);
        if trueAns == 1
            numOfColour1 = ceil(tiles/2);
            numOfColour2 = floor(tiles/2);
        else
            numOfColour1 = floor(tiles/2);
            numOfColour2 = ceil(tiles/2);
        end
        % check how many of each colour should be in the grid.
        trials(n).numOfColour1 = numOfColour1;
        trials(n).numOfColour2 = numOfColour2;
        
        % Before our grid becomes of dimensions x by y, we have an array
        % gridFlat of (x*y) by 1.
        gridFlat = [repelem(1,numOfColour1) repelem(2,numOfColour2)];
        gridFlat = randsample(gridFlat,length(gridFlat));
        
        % Convert gridFlat into proper x by y grid.
        count = 1;
        for x=1:X
            for y=1:Y
                grid(x,y) = gridFlat(count);
                count = count + 1;
            end
        end
        % trueGrid - underarching grid with colours represented as either 1
        % or 2.
        % trueColourGrid - same as trueGrid, but colours shown in words
        % instead (eg 'red' or 'yellow') as per the names assigned in
        % varSet under colourNames.
        trials(n).trueGrid = grid;
        colourGrid = cell(size(grid));
        colourGrid(grid==1)={colourNames(1)};
        colourGrid(grid==2)={colourNames(2)};
        trials(n).trueColourGrid = colourGrid;
    end
end