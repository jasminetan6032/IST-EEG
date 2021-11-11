%% newConditionInstructs
% If one section/condition of the experiment has ended, introduce the next
% section with instruction screen.
function newConditionInstructs(t,trials,vars,Sc)
if (t > 1 && ~strcmp(trials(t).type,trials(t-1).type) && vars.doInstr)
    if (vars.practice)
        insimdata = imread(char(strcat('Instructions/',trials(t).type,'_practice.jpg')));
    else
        insimdata = imread(char(strcat('Instructions/',trials(t).type,'.jpg')));
    end
    texins = Screen('MakeTexture', Sc.window, insimdata);
    Screen('DrawTexture', Sc.window, texins,[],Sc.rect);
    Screen('Flip',Sc.window);
    WaitSecs(.25);
    hasconfirmed = false;
    while ~hasconfirmed
        [x,y,buttons] = GetMouse;
        if(buttons(1)||buttons(2)||buttons(3))
            while 1
                % Wait for mouse release.
                [x,y,buttons] = GetMouse;
                if(~(buttons(1))&&~(buttons(2))&&~(buttons(3)))
                    type = [trials.type].';
                    finalP = [trials.finalPCorrect].';
                    forcedPLevel = mean(finalP(strcmp(type,'fixed')));
                    hasconfirmed = true;
                    break;
                end
            end
        end
    end
end
end