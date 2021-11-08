% Psychtoolbox setup
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference','TextRenderer',0);
% Resolution of screen retrived from vars.
winAreaX = vars.resX;
winAreaY = vars.resY;
Sc = start_psychtb([0 0 winAreaX winAreaY]);

% Use the above X and Y dimensions to derive the centre of the screen.
xy = Screen('Resolution',0);
centerX = winAreaX/2;
centerY = winAreaY/2;
vars.centerX = centerX;
vars.centerY = centerY;

% Dimensions of the IST grid.
gridX = vars.gridDimX;
gridY = vars.gridDimY;
tiles = gridX*gridY;

% Generate a grid of coordinates for referring to tiles
% eg 5 X 5 grid: coordinates of (1,1) to (5,5)
tilesCoord = []; 
count = 1;
for x=1:gridX
    for y=1:gridY
        tilesCoord(count,1) = x;
        tilesCoord(count,2) = y;
        count = count + 1;
    end
end

% Answer box used by participants in the behavioural experiment to indicate
% when they want to stop flipping tiles and give their answer. 
% The box should sit below the main IST grid in the centre, so below put it
% in a resonable position and adapt based on the window size.
% Below we set the size and coordinates of this box.
answerCoords = [];
answerCoords(1) = winAreaX*0.45;
answerCoords(2) = winAreaY*0.875;
answerCoords(3) = winAreaX*0.55;
answerCoords(4) = winAreaY*0.95;
vars.answerCoords = answerCoords;

% After choosing to answer, participants are shown colour boxes for their
% options of which of the two colours is the majority.
% Again, changes based on the size of the window.
% Below we set the size and coordinates of these boxes.
optionCoords = [];
optionCoords(1,1) = winAreaX*0.35;
optionCoords(2,1) = winAreaY*0.875;
optionCoords(3,1) = winAreaX*0.45;
optionCoords(4,1) = winAreaY*0.975;
optionCoords(1,2) = winAreaX*0.55;
optionCoords(2,2) = winAreaY*0.875;
optionCoords(3,2) = winAreaX*0.65;
optionCoords(4,2) = winAreaY*0.975;
vars.optionCoords = optionCoords;

% x and y coordinates of where to put feedback text on the screen.
trialx = answerCoords(1) + ((answerCoords(3) - answerCoords(1))/2);
trialy = answerCoords(2) + ((answerCoords(4) - answerCoords(2))/2);

% Define starting colours
colours = [vars.colourCode1; vars.colourCode2];
vars.colours = colours;

% Starting amount of points.
points = 0;

% Cj Slider Vars

cfg.bar.maxScale            = 55;
cfg.bar.minScale            = -55;
cfg.backgroundColour = Sc.bkgCol;           % grey
cfg.fontsize=25;
% instructions on screen
cfg.instr.cjtext        = {'50%' '100%'};           % confidence judgement text
cfg.instr.instr = {'Right click to confirm'}; % how to respond.
cfg.instr.finaldecision = {'What is your final decision?'};                 
cfg.instr.interval      = {'LEFT' 'RIGHT'};

% Defining subject measures for dynamic experiment length and
% post-experiment recording.
subject.totalFlips = 0;
subject.totalTime = 0;
subject.numOfTrials = 1;
if mod(subject.id,2) == 0
    subject.blockCondition = vars.expStructure{1};
else
    subject.blockCondition = vars.expStructure{2};
end

% if (strcmp(vars.experimentType,'eeg'))
%     useport = pairStimtoEEG;
% end