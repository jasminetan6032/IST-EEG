% Psychtoolbox setup
Screen('Preference', 'SkipSyncTests', 0);
Screen('Preference','TextRenderer',0);
Sc = start_psychtb([0 0 vars.resX vars.resY]);

% Use the above X and Y dimensions to derive the centre of the screen.
xy = Screen('Resolution',0);
centerX = vars.resX/2;
centerY = vars.resY/2;

gridX = vars.gridDimX;
gridY = vars.gridDimY;
tiles = gridX*gridY;
tilesCoord = [];

count = 1;
for x=1:gridX
    for y=1:gridY
        tilesCoord(count,1) = x;
        tilesCoord(count,2) = y;
        count = count + 1;
    end
end

winAreaX = vars.resX;
winAreaY = vars.resY;

answerCoords = [];
answerCoords(1) = winAreaX*0.45;
answerCoords(2) = winAreaY*0.875;
answerCoords(3) = winAreaX*0.55;
answerCoords(4) = winAreaY*0.95;
vars.answerCoords = answerCoords;
Screen('FrameRect',Sc.window,[0,0,0],answerCoords,1);

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

trialx = answerCoords(1) + ((answerCoords(3) - answerCoords(1))/2);
trialy = answerCoords(2) + ((answerCoords(4) - answerCoords(2))/2);

% Define starting colours
colours = [vars.colourCode1; vars.colourCode2];
vars.colours = colours;