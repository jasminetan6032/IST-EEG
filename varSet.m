%% VarSet - Set our experimental variables.
function [vars] = varSet(vars)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SET EXPERIMENTAL VARIABLES IN THE BELOW BLOCK
    
    % Set X and Y dimensions of the experiment window below.
    vars.resX = 1400;
    vars.resY = 900;
    
    vars.gridX = 400;
    vars.gridY = 400;
    
    % Set below to 'behavioural' or 'eeg'
    vars.experimentType = 'eeg';
    
    % Do we define the length of the experiment by trials, flips or time?
    vars.expLengthMeasure  = 'trials';
    
    % Below field only applicable for trials length generation.
    % How many blocks?
    vars.numOfExpBlocks = 4;
    % How many trials per block (before going to a break)? 
    vars.expBlockLength = 30;

    
    % Trial Types are fixed, decreasing and forced (in this recommended order).
    % Below is the order that these types appear in the experiment and it
    % is recommended to use the default order, but you can change it below.
    vars.expStructure = {'fixed', 'decreasing', 'forced'}; 
    % Just put zero below if you don't want any of a particular type.
    % Make sure expBlocks values add up to numOfExpBlocks above.
    vars.expBlocks = [2,2,0];
    vars.trainingLength = 5;
    
    % Below field only applicable for flips length generation.
    % How many flips do you want in the experiment for each trial type?
    vars.numOfExpFlips = [100,100,100];
    % Below fields only applicable for time length generation.
    % How long do you want the experiment to be (in minutes) for each trial type?
    vars.numOfExpMinutes = [15,15,15];
    % NB: minutes and flips are defined across the whole experiment, thus
    % for each set of trials (ie fixed, creasing or forced), the
    % minutes/flips are divded across each of these sections according to
    % the number of blocks allocated to each in var.expBlocks below.
    
    
    % Set points for the fixed and decreasing win conditions.
    vars.fixedPointsWin = 100;
    vars.decreasingPointsStart = 250;
    vars.wrongPointsLoss = 100;
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