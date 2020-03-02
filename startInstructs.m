filePrefix = "";
numOfInstructs = 0;
if (strcmp(vars.experimentType,'behavioural'))
    filePrefix = "beh";
    numOfInstructs = 5;
elseif (strcmp(vars.experimentType,'eeg'))
    filePrefix = "eeg";
    numOfInstructs = 7;
end

r = 1;
while r< numOfInstructs
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