% End the experiment after trials are over.
function [subject] = endExp(subject,trials,Sc)

    % Compute total number of tile flips and total time on experiment for this
    % subject.
    subject.totalFlips = sum([trials.numOfTilesRevealed]);
    subject.totalTime = sum([trials.trialTime]);


    % Thank the participant.
    insimdata = imread('Instructions/thanks.jpeg');
    texins = Screen('MakeTexture', Sc.window, insimdata);
    Screen('DrawTexture', Sc.window, texins,[],Sc.rect);
    Screen('Flip',Sc.window);
    WaitSecs(.25);
    hasconfirmed = false;
    while ~hasconfirmed
        [x,y,buttons] = GetMouse;
        if(buttons(1))
            while 1
                % Wait for mouse release.
                [x,y,buttons] = GetMouse; 
                if(~(buttons(1)))
                    hasconfirmed = true;
                    break;
                end
            end
        end
    end
    
    Screen('CloseAll');
    ListenChar(0);
    DisableKeysForKbCheck([]);
    ShowCursor()
    Priority(0);
end