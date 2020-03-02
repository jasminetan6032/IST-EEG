function [cj resp_t interval hasconfirmed] = cjSlider(window,vars,cfg,fillCoords,numOfFlips,colourArr)
    %% Show mouse pointer
    SetMouse (window.center(1), window.center(2)+20);
    ShowCursor('Arrow');


    %% initialize variables
    resp = 0; 
    buttons=[]; 
    haschanged=false; 
    hasconfirmed=false;
    int=0;
    
    define_scale;

    % draw scale
    draw_scale_(window,cfg)

    % draw confidence and interval landmarks
    draw_landmarks(window,cfg,vars)
    Screen('Flip',window.window);
    %% collect response
    while ~any(buttons) % wait for click
        [x,y,buttons] = GetMouse;
    end
    while ~hasconfirmed
        while any(buttons)||~haschanged   % wait for release and change of cj and confirmation
            [resp_x, resp_y, buttons] = GetMouse();

            if resp_x<vars.centerX % if mouse's on the left rect

                resp = find(resp_x < (cfg.bar.xshift+cfg.bar.cursorwidth.*.5),1) - cfg.bar.maxScale-1;
                haschanged = true;
                int = -1;
                if resp==0, resp=int;end
            elseif resp_x>vars.centerX %&& resp_x<=cfg.bar.barrect(3) % if mouse's on the right rect
                resp = find(resp_x < (cfg.bar.xshift+cfg.bar.cursorwidth.*.5),1) - cfg.bar.maxScale;
                haschanged = true;
                int = 1;
                if isempty(resp), resp=cfg.bar.maxScale;end
            end
            
            ft = display_response_(window,cfg,[haschanged,resp],vars);
            drawColourTiles(fillCoords,numOfFlips,colourArr,window.window);
            vars = drawGrid(window.window,vars);
        end

        % check for confirmation
        
        if ~hasconfirmed
            [x,y,buttons] = GetMouse;
            if (buttons(2)||buttons(3))
                while 1
                    % Wait for mouse release.
                    [x,y,buttons] = GetMouse; 
                    if(~(buttons(2))&&~(buttons(3)))
                        resp_t = GetSecs;
                        hasconfirmed = true;
                        break;
                    end
                end
            end
        end

    end


    %% compute confidence judgment
    cj = resp ;

    % change interval to [1 2] range
    interval = 2-(int<0);


return