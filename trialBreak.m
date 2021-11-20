save([pwd '/' vars.rawdata_path num2str(subject.id) '/behaviour/' subject.fileName '_' num2str(round(t/vars.expBlockLength))],'trials', 'vars', 'subject', 't');
correct = [trials(1:t).correct];
timeLeft = round(((vars.numOfExpMinutes*60 - trials(t).trialTime)/60),1);
text = ['You currently have ' num2str(points) ' points' newline newline 'Your accuracy up until this point is ' num2str((sum(correct)/t)*100) '%' newline newline 'You have' num2str(timeLeft) 'minutes left in the game.'];
text = [text newline newline newline 'You may now take a break. Click on the screen to continue.'];
DrawFormattedText(Sc.window, text,'center', 'center', [0 0 0]);
Screen('Flip', Sc.window);
WaitSecs(1);
hasconfirmed = false;
while ~hasconfirmed
    [x,y,buttons] = GetMouse;
    % If mouse button is clicked
    if(buttons(1)||buttons(2)||buttons(3))
        X = x;
        Y = y;
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

if (strcmp(subject.blockCondition, 'fixed'))
    subject.blockCondition = vars.expStructure{2};
elseif (strcmp(subject.blockCondition, 'decreasing'))
    subject.blockCondition = vars.expStructure{1};
end

vars.trialmatrix = randperm(vars.expBlockLength);
vars.withinBlockNumber = 1;