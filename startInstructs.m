%% startInstructs.m
% Instructions for the start of the experiment.

% We have separate files for instructing on the behavioural and EEG
% versions. They are given different file name prefixes.
filePrefix = "";
numOfInstructs = 0;
if (strcmp(vars.experimentType,'behavioural'))
    filePrefix = "beh";
    numOfInstructs = 5;
elseif (strcmp(vars.experimentType,'eeg'))
    filePrefix = "eeg";
    numOfInstructs = 7;
end

% Loop through instruction files, with right click to move forward and left
% click to move back.
r = 1;
while r<= numOfInstructs
    insimdata = imread(strcat('Instructions/',filePrefix,num2str(r),'.jpeg'));
    texins = Screen('MakeTexture', Sc.window, insimdata);
    Screen('DrawTexture', Sc.window, texins,[],Sc.rect);
    Screen('Flip',Sc.window);
    WaitSecs(.25);
    [x,y,buttons] = GetMouse;
    if(buttons(1)&&r>1)
        while 1
            % Wait for mouse release.
            [x,y,buttons] = GetMouse; 
            if(~(buttons(1)))
                r = r - 1;
                break;
            end
        end
    elseif((buttons(2)||buttons(3)))
        while 1
            % Wait for mouse release.
            [x,y,buttons] = GetMouse; 
            if(~buttons(2)&&~buttons(3))
                r = r + 1;
                break;
            end
        end
    end
end

% Tell participant about first lot of trials of a particular type (most
% likely the Fixed win condition)
insimdata = imread(strcat('Instructions/',vars.expStructure{1},'.jpeg'));
texins = Screen('MakeTexture', Sc.window, insimdata);
Screen('DrawTexture', Sc.window, texins,[],Sc.rect);
Screen('Flip',Sc.window);
WaitSecs(1);
[x,y,buttons] = GetMouse;
while 1
    if(buttons(1)||buttons(2)||buttons(3))
        while 1
            % Wait for mouse release.
            [x,y,buttons] = GetMouse; 
            if(~(buttons(1))&&~(buttons(2))&&~(buttons(3)))
                break;
            end
        end
    end
    break;
end