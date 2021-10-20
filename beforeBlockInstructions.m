fixedInstructions = ['You will not lose any points for any tile you choose to flip over.'];
decreasingInstructions = ['You will lose 10 points for every tile you choose to flip over.'];

if (strcmp(trials(t).type,'fixed'))
    
    text = ['This is a fixed trial' newline newline fixedInstructions];
    text = [text newline newline newline 'Click on the screen to continue.'];
elseif (strcmp(trials(t).type,'decreasing'))
    text = ['This is a decreasing trial' newline newline decreasingInstructions];
    text = [text newline newline newline 'Click on the screen to continue.'];
end
DrawFormattedText(Sc.window, text,'center', 'center', [0 0 0]);
Screen('Flip', Sc.window);
WaitSecs(1);