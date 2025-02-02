save([pwd '/' vars.rawdata_path num2str(subject.id) '/behaviour/' subject.fileName '_' num2str(round(t/vars.expBlockLength))],'trials', 'vars', 'subject', 't');
correct = [trials(1:t).correct];
timeLeft = round(((vars.numOfExpMinutes*60 - trials(t).trialTime)/60),1);
text = ['You currently have ' num2str(points) ' points' newline newline 'Your accuracy up until this point is ' num2str((sum(correct)/t)*100) '%' newline newline 'You have' num2str(timeLeft) 'minutes left in the game.'];
text = [text newline newline newline 'You may now take a break. Click on the screen to continue.'];
DrawFormattedText(Sc.window, text,'center', 'center', [0 0 0]);
Screen('Flip', Sc.window);
if (vars.triggers)
    sendTrig(66,useport);
end
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
    vars.colourCode1 = [0.1176    0.5647    1.0000];
    vars.colourCode2 = [0 1 0.4980];
    vars.colourCodeN = [0,0,0];
    vars.colourNames = {'blue','green','black'};
    colours = [vars.colourCode1; vars.colourCode2];
    vars.colours = colours;
elseif (strcmp(subject.blockCondition, 'decreasing'))
    subject.blockCondition = vars.expStructure{1};
    vars.colourCode1 = [0.9290 0.6940 0.1250];
    vars.colourCode2 = [0.6350 0.0780 0.1840];
    vars.colourCodeN = [0,0,0];
    vars.colourNames = {'orange','red','black'};
    colours = [vars.colourCode1; vars.colourCode2];
    vars.colours = colours;
end

vars.trialmatrix = randperm(vars.expBlockLength);
vars.withinBlockNumber = 1;