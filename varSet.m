%% VarSet - Set our experimental variables.
function [vars] = varSet(vars)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SET EXPERIMENTAL VARIABLES IN THE BELOW BLOCK
    
    % Set X and Y dimensions of the experiment window below.
    vars.resX = 1080;
    vars.resY = 600;
    
    vars.gridX = 400;
    vars.gridY = 400;
    
    % Set below to 'behavioural' or 'eeg'
    vars.experimentType = 'behavioural';
    
    % How many blocks?
    vars.numOfExpBlocks = 6;
    % How many trials per block? 
    vars.expBlockLength = 30;
    
    % Set points for the fixed and decreasing win conditions.
    vars.fixedPointsWin = 100;
    vars.decreasingPointsStart = 250;
    vars.wrongTokenLoss = 100;
    vars.decreasingDec = 10;
    
    % What should the dimensions of our grid be?
    % Specify the x (columns) and y (rows) below.
    vars.gridDimX = 5;
    vars.gridDimY = 5;

    % Colours to use for our grid, provided as RGB triplet
    % 1 and 2 are our underlying colours for ppts to guess
    % N is our neutral (ie ppt has not turned over that tile yet).
    vars.colourCode1 = [0.9290 0.6940 0.1250];
    vars.colourCode2 = [0.6350 0.0780 0.1840];
    vars.colourCodeN = [0,0,0];
    vars.colourNames = {'orange','red','black'};
   
    % Setting to skip instructions while debugging
    vars.do_instr = true;   
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end