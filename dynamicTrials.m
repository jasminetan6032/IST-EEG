%% dynamicTrials.m
% Rather than building all trials ahead of time, we check that we have not
% reached our limit for flips/time, and then add a new trial one at a time.

function [trials, endFlag, subject] = dynamicTrials(vars,trials,subject)

% Row of trials struct to add to. Incremented after each trial in the
% main loop.
n = subject.numOfTrials;

% We need to get the current flips/time and the limit for this trial
% type (set in varSet).
if (strcmp(vars.expLengthMeasure,"flips"))
    y = subject.totalFlips;
    arr = vars.numOfExpFlips;
elseif (strcmp(vars.expLengthMeasure,"time"))
    y = subject.totalTime;
    arr = vars.numOfExpMinutes*60;
end

if y < arr
    trials(n).type = subject.blockCondition;
else
    % Flips/time exceeded the total for the whole experiment. Time to
    % finish the experiment!
    endFlag = 1;
    return
end

% From the current flips/time, which trial type are we in?
% ie for a current flips/time X and type array [A,B,C].
%     if (y < arr(1) && arr(1) ~= 0)
%         trials(n).type = vars.expStructure{1};
%     elseif (y > arr(1) && y < (arr(1) + arr(2)) && arr(2) ~= 0)
%         trials(n).type = vars.expStructure{2};
%         if (~strcmp(trials(n-1).type,trials(n).type))
%             % We don't want any excess flips/time to carry out into the
%             % next section, so we set our measure to the minimum amount to
%             % move onto the next trial type.
%             subject.totalFlips = arr(1);
%             subject.totalTime = arr(1);
%         end
%     elseif (y < (arr(1) + arr(2) + arr(3)) && arr(3) ~= 0)
%         trials(n).type = vars.expStructure{3};
%         if (~strcmp(trials(n-1).type,trials(n).type))
%             subject.totalFlips = arr(1) + arr(2);
%             subject.totalTime = arr(1) + arr(2);
%         end
%     else
%         % Flips/time exceeded the total for the whole experiment. Time to
%         % finish the experiment!
%         endFlag = 1;
%         return
%     end

endFlag = 0;
colourNames = vars.colourNames;
X = vars.gridDimX;
Y = vars.gridDimY;
tiles = X*Y;

trials(n).trialNumber = n;
if (mod(n,vars.expBlockLength) == 0)
    trials(n).break = 1;
else
    trials(n).break = 0;
end

% trials(n).block = ceil(n/vars.expBlockLength);

% Randomly decide what is our correct answer for each trial.
% 1 is left colour, 2 is right.
% This matches colours 1 and 2 in varSet.
trueAns = round(rand(1))+1;
trials(n).trueAns = trueAns;
trials(n).trueColour = colourNames(trueAns);

% Initialise our grids for each trial
grid = zeros(X,Y);
if trueAns == 1
    numOfColour1 = vars.difficultyLevels(vars.trialmatrix(vars.withinBlockNumber),1);
    numOfColour2 = vars.difficultyLevels(vars.trialmatrix(vars.withinBlockNumber),2);
else
    numOfColour1 = vars.difficultyLevels(vars.trialmatrix(vars.withinBlockNumber),2);
    numOfColour2 = vars.difficultyLevels(vars.trialmatrix(vars.withinBlockNumber),1);
end
% make note of how many of each colour should be in the grid.
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