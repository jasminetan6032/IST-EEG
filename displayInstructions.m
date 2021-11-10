%Takes the name of a jpeg file, looks for the file in the Instructions
%folder and presents a single slide. It then waits till the participant has
%clicked to move on. 
%instructions need to be in characters, i.e. 'exp' or refer to a variable
%that is a character eg. subject.blockCondition

function displayInstructions(instructions, Sc)
insimdata = imread(strcat('Instructions/',instructions,'.jpeg'));
texins = Screen('MakeTexture', Sc.window, insimdata);
Screen('DrawTexture', Sc.window, texins,[],Sc.rect);
Screen('Flip',Sc.window);
WaitSecs(1);
hasconfirmed = false;
while ~hasconfirmed
    [x,y,buttons] = GetMouse;
    if(buttons(1)||buttons(2)||buttons(3))
        while 1
            % Wait for mouse release.
            [x,y,buttons] = GetMouse;
            if(~(buttons(1))&&~(buttons(2))&&~(buttons(3)))
                hasconfirmed = true;
                break;
            end
        end
    end
end
end