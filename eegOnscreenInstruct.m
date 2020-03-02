function eegOnscreenInstruct(win,cfg)
    %Draw response boxes on screen:
    Screen('FrameRect', win, [0,0,0], cfg.MouseRect_pos1, 1);
    Screen('FrameRect', win, [0,0,0], cfg.MouseRect_pos2, 1);
    Screen('DrawText', win, 'Flip Tile', win.Center(1)-cfg.MouseRect(3)*.75, window.Rect(4)*cfg.bar.positiony, [255,255,255]);
    Screen('DrawText', win, 'Answer', win.Center(1)+cfg.MouseRect(3)*.25, window.Rect(4)*cfg.bar.positiony, [255,255,255]);
end