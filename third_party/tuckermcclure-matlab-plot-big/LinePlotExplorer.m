classdef LinePlotExplorer < handle
    
% LinePlotExplorer
%
% This tool allows users to move around quickly within a 2D plot by panning
% (left clicking and dragging) or zoom (scrolling with a scroll wheel). 
% When instantiated, it will provide this ability for all axes in the
% provided figure (or current figure by default).
%
% Usage:
%
% lpe = LinePlotExplorer(h_fig, x_min, x_max); % Start LinePlotExplorer
% % ...
% lpe.Stop(); % Stop using this LinePlotExplorer.
%
% Inputs:
% 
% h_fig - Handle of figure to control (optional)
% x_min - Minimum value to show on x axis (optional)
% x_max - Maximum value to show on x axis (optional)
%
% Outputs:
%
% lpe   - LinePlotExplorer object.
%
% This object uses the figure's WindowButtonUpFcn, WindowButtonDownFcn,
% WindowButtonMotionFcn, and WindowScrollWheelFcn callbacks. If those are
% necessary for other tasks as well, callbacks can be attached to the
% LinePlotExplorer, which will pass all arguments on to the provided
% callback function.
%
% Example:
%
% lpe = LinePlotExplorer(gcf);
% lpe.AttachCallback('WindowButtonDownFcn', 'disp(''clicked'');');
% 
% Or multiple callbacks can be set with a single call:
%
% lpe.AttachCallback('WindowButtonDownFcn',   'disp(''down'');', ...
%                    'WindowButtonUpFcn',     'disp(''up'');', ...
%                    'WindowButtonMotionFcn', 'disp(''moving'');', ...
%                    'WindowScrollWheelFcn',  @(~, ~) disp('scrolling'));
%
% Tucker McClure
% Copyright 2013, The MathWorks, Inc.
% Modified by Andrew Penn (2024)

    properties
        
        % Figure handle
        h_fig;
        
        % Min and max values for x and y axes
        x_reset;
        y_reset;
        x_max;
        x_min;
        y_max;
        y_min;
        
        % Interactivity parameters
        button_down = false;
        button_down_point;
        button_down_axes;
        
        wbdf; % Pass-through WindowButtonDownFcn
        wbuf; % Pass-through WindowButtonUpFcn
        wbmf; % Pass-through WindowButtonMotionFcn
        wswf; % Pass-through WindowScrollWheelFcn
        wkpf; % Pass-through WindowKeyPressFcn
        wkrf; % Pass-through WindowKeyReleaseFcn

    end
    
    methods
        
        % Create a ReductiveViewer for the x and y variables.
        function o = LinePlotExplorer(varargin)

            % Record the figure number and min and max value on the x axis.
            if nargin < 1, o.h_fig =  gcf; else o.h_fig = varargin{1}; end;
            if nargin < 2, o.x_min = -inf; else o.x_min = varargin{2}; end;
            if nargin < 3, o.x_max =  inf; else o.x_max = varargin{3}; end;
            o.x_reset = xlim;
            o.y_reset = ylim;

            % Set the callbacks.
            set(o.h_fig, 'WindowScrollWheelFcn',  @o.Scroll, ...
                         'WindowButtonDownFcn',   @o.ButtonDown, ...
                         'WindowButtonUpFcn',     @o.ButtonUp, ...
                         'WindowButtonMotionFcn', @o.Motion, ...
                         'WindowKeyPressFcn', @o.KeyPress, ...
                         'WindowKeyReleaseFcn', @o.KeyRelease);

            % Remove matlab's toolbar controls
            set(o.h_fig,'Toolbar','None')
            h_axes = get(o.h_fig, 'CurrentAxes');
            h_axes.Toolbar.Visible = 'off'; 

            % Create custom menu
            set(o.h_fig,'Menubar','none');
            m = uimenu(o.h_fig,'Text', 'Main');
            mHelp   = uimenu(m,'Text','Help');
            % mReset  = uimenu(m,'Text','Reset controls');
            mMore   = uimenu(m,'Text','More menus...');
            mClose   = uimenu(m,'Text','Close figure');
            % mReset.MenuSelectedFcn = {@ResetFig,o};
            mMore.MenuSelectedFcn = @MoreMenus;
            mHelp.MenuSelectedFcn = @HelpInfo;
            mClose.MenuSelectedFcn = 'close(gcf);';
  
            function ResetFig(src,event,o)

                % Disable any existing zoom and pan interactions
                zoomState = zoom(o.h_fig);
                zoomState.Enable = 'off';
                panState = pan(o.h_fig);
                panState.Enable = 'off';

                % Reset limits on both axes
                h_axes = get(gcf, 'CurrentAxes');
                set(h_axes, 'XLim', o.x_reset);
                set(h_axes, 'YLim', o.y_reset);
                x_lims = get(h_axes, 'XLim');

                % Remove 'Main' menu if it already exists
                try
                    if (strcmpi (o.h_fig.Children(1).Text, 'Main'))
                        delete(o.h_fig.Children(1))
                    end
                catch
                end

                % Reinitialize rapid navigation controls
                LinePlotExplorer(gcf,x_lims(1),x_lims(2));
            
            end
            
            function MoreMenus(src,event)
                
                switch get(gcf,'Menubar')
                    case 'none'
                        set(gcf,'Menubar','Figure')
                        set(src,'Text','Fewer menus...');
                    otherwise
                        set(gcf,'Menubar','None')
                        set(src,'Text','More menus...');
                end
                
            
            end
            
            function HelpInfo(src,event)
            
                msg = { ...
                       '\fontname{Arial}\fontsize{18}\color{blue}', ...
                       '\bfControls for the Navigation of Time Series Plots\rm', ...
                       '\fontname{Arial}\fontsize{14}\color{black}', ...
                       '\bfMOUSE CONTROLS:\rm', ...
                       '\fontname{Courier}\fontsize{12}', ...
                       '\bfZoom^{$} in X^{\ast}: \rmScroll wheel.', ...
                       '\bfZoom^{$} in Y : \rmScroll wheel + Right button (or SHIFT).', ...
                       '\bfPan   in X^{\ast}: \rmLeft  button drag.', ...
                       '\bfPan   in Y : \rmRight button drag \bfOR\rm Left button drag + SHIFT.', ...
                       '\bfAutoscale  : \rmDouble click (left or right).', ...
                       '\fontname{Arial}', ...
                       '^{$} The zoom focus is the current position of the mouse pointer.', ...
                       ' ', ...
                       '\fontname{Arial}\fontsize{14}', ...
                       '\bfKEYBOARD-ONLY CONTROLS:\rm', ...
                       '\fontname{Courier}\fontsize{12}', ...
                       '\bfZoom^{\Phi} in X^{\ast}: \rmLEFT/RIGHT CURSOR + SHIFT.', ...
                       '\bfZoom^{\Phi} in Y : \rmUP/DOWN    CURSOR + SHIFT.', ...
                       '\bfPan   in X^{\ast}: \rmLEFT/RIGHT CURSOR.', ...
                       '\bfPan   in Y : \rmUP/DOWN    CURSOR.', ...
                       '\bfAutoscale  : \rmESCAPE or RETURN.', ...
                       '\fontname{Arial}', ...
                       '^{\Phi} The zoom focus is the center of the current plot view.', ...
                       ' ', ...
                       '^{\ast} Pan and zoom along the X-axis may respect the limits of the data.', ...
                       '\it', ...
                       'Originally written by Tucker McClure (2013-2018).', ...
                       'Modified and extended by Andrew Penn (2024).', ...
                       ' ', ...
                       };
                Opt.Interpreter = 'tex';
                Opt.WindowStyle = 'non-modal';
                h = msgbox(msg, 'Help', 'none', Opt);
                set (h,'resize','on');

            
            end


 
        end
        
    end
    
    methods (Access = public)

        % Stop using this object to control the figure.
        function Stop(o)

            if ishandle(o.h_fig)
                
                % Clear the callbacks.
                set(o.h_fig, ...
                    'WindowButtonDownFcn',   o.wbdf, ...
                    'WindowButtonUpFcn',     o.wbuf, ...
                    'WindowButtonMotionFcn', o.wbmf, ...
                    'WindowScrollWheelFcn',  o.wswf, ...
                    'WindowKeyPressFcn',  o.wkpf);
                
            end
 
        end
        
        % Add a pass-through callback for one of the callbacks
        % FigureRotator hogs to itself. This way, a user can still get all
        % the info he needs from a figure's callbacks *and* use the 
        % rotator.
        function AttachCallback(o, varargin)
            
            for k = 2:2:length(varargin)
                switch varargin{k-1}
                    case 'WindowButtonDownFcn'
                        o.wbdf = varargin{k};
                    case 'WindowButtonUpFcn'
                        o.wbuf = varargin{k};
                    case 'WindowButtonMotionFcn'
                        o.wbmf = varargin{k};
                    case 'WindowScrollWheelFcn'
                        o.wswf = varargin{k};
                    case 'WindowKeyPressFcn'
                        o.wkpf = varargin{k};
                    case 'WindowKeyReleaseFcn'
                        o.wkrf = varargin{k};
                    otherwise
                        warning('Invalid callback attachment.');
                end
            end
            
        end
        
    end
    
    methods (Access = protected)
        
        % When the user moves the mouse wheel...
        function Scroll(o, h, event, varargin)

            % Get current axes for this figure.
            h_axes = get(o.h_fig, 'CurrentAxes');

            % Disable autoscaling in axes properties
            set (h_axes, 'XLimMode', 'manual')
            set (h_axes, 'YLimMode', 'manual')
            
            % Get where the mouse was when the user scrolled.
            point = get(h_axes, 'CurrentPoint');
            point = point(1, 1:2);
            
            % Get the old limits.
            old_x_lims = get(h_axes, 'XLim');
            old_y_lims = get(h_axes, 'YLim');
            
            % If the mouse isn't in the axes area, don't zoom.
            if    point(1) < old_x_lims(1) ...
               || point(1) > old_x_lims(2) ...
               || point(2) < old_y_lims(1) ...
               || point(2) > old_y_lims(2)
                return;
            end
            
            % Get where and in what direction user scrolled.
            exponent = double(event.VerticalScrollCount);

            % Calculate new limits.
            SelectionType = get (o.h_fig, 'SelectionType');
            switch SelectionType
                case 'normal'

                    range    = diff(old_x_lims);
                    alpha    = (point(1) - old_x_lims(1)) / range;
                    new_lims = 2.25^exponent * range *[-alpha 1-alpha] + point(1);

                    % Don't zoom out too far.
                    new_lims = max(min(new_lims, o.x_max), o.x_min);
            
                    % Update the axes.
                    set(h_axes, 'XLim', new_lims);

                case {'extend','alt'}

                    range    = diff(old_y_lims);
                    alpha    = (point(2) - old_y_lims(1)) / range;
                    new_lims = 2.25^exponent * range *[-alpha 1-alpha] + point(2);
            
                    % Update the axes.
                    set(h_axes, 'YLim', new_lims);

            end
            
            % If there's a callback attachment, execute it.
            execute_callback(o.wswf, h, event, varargin{:});

        end
        
        % The user has clicked and is holding.
        function ButtonDown(o, h, event, varargin)

            % Record what the axes were when the user clicked and where the
            % user clicked.
            o.button_down_axes   = get(o.h_fig, 'CurrentAxes');
            point                = get(o.button_down_axes, 'CurrentPoint');
            o.button_down_point  = point(1, 1:2);
            o.button_down        = true;

            % If there's a callback attachment, execute it.
            execute_callback(o.wbdf, h, event, varargin{:});
            
        end
        
        % The user has released the button.
        function ButtonUp(o, h, event, varargin)
            
            o.button_down = false;

            % Autoscale axes if double left mouse click
            SelectionType = get (o.h_fig, 'SelectionType');
            switch SelectionType
                case 'open'

                    h_axes = get(o.h_fig, 'CurrentAxes');
                    set(h_axes, 'XLim', o.x_reset);
                    set(h_axes, 'YLim', o.y_reset);

            end
            set (o.h_fig, 'SelectionType', 'normal');

            % If there's a callback attachment, execute it.
            execute_callback(o.wbuf, h, event, varargin{:});
            
        end
        
        % When the user moves the mouse with the button down, pan.
        function Motion(o, h, event, varargin)

            % Get current axes for this figure.
            h_axes = get(o.h_fig, 'CurrentAxes');

            % Disable autoscaling in axes properties
            set (h_axes, 'XLimMode', 'manual')
            set (h_axes, 'YLimMode', 'manual')

            if o.button_down

                SelectionType = get (o.h_fig, 'SelectionType');
                switch SelectionType
                    case 'normal'

                        % Get the mouse position and movement from original point.
                        point    = get(o.button_down_axes, 'CurrentPoint');
                        movement = point(1, 1) - o.button_down_point(1);
                        xlims    = get(o.button_down_axes, 'XLim');
              
                        % Don't let the user pan too far.
                        new_lims = xlims - movement;
                        if new_lims(1) < o.x_min
                            new_lims = o.x_min + [0 diff(new_lims)];
                        end
                        if new_lims(2) > o.x_max
                            new_lims = o.x_max - [diff(new_lims) 0];
                        end
        
                        % Update the axes.
                        set(o.button_down_axes, 'XLim', new_lims);

                    case {'extend','alt'}

                        % Get the mouse position and movement from original point.
                        point    = get(o.button_down_axes, 'CurrentPoint');
                        movement = point(1, 2) - o.button_down_point(2);
                        ylims    = get(o.button_down_axes, 'YLim');
              
                        % Change the limits.
                        new_lims = ylims - movement;
        
                        % Update the axes.
                        set(o.button_down_axes, 'YLim', new_lims);
                end
            end

            % If there's a callback attachment, execute it.
            execute_callback(o.wbmf, h, event, varargin{:});
            
        end

        % The user has pressed a key on the keyboard.
        function KeyPress(o, h, event, varargin)

            % Get current axes for this figure.
            h_axes = get(o.h_fig, 'CurrentAxes');

            % Disable autoscaling in axes properties
            set (h_axes, 'XLimMode', 'manual')
            set (h_axes, 'YLimMode', 'manual')

            switch event.Key
                case 'shift'

                    set (o.h_fig, 'SelectionType', 'extend');

                case 'leftarrow'

                    % Get current axes for this figure.
                    h_axes = get(o.h_fig, 'CurrentAxes');
                    if isempty(o.button_down_axes)
                        old_lims = get(h_axes, 'XLim');
                    else
                        old_lims = get(o.button_down_axes, 'XLim');
                    end

                    % Calculate the new limits
                    if (ismember (event.Modifier,{'shift'})) 

                        % Zoom
                        mid_lims = sum (old_lims) * 0.5;
                        new_lims = (old_lims - mid_lims) * 1.2 + mid_lims;

                        % Don't let the user zoom too far.
                        new_lims(1) = max (new_lims(1), o.x_min);
                        new_lims(2) = min (new_lims(2), o.x_max);

                    else

                        % Pan
                        new_lims = old_lims + diff(old_lims) * 0.1;

                        % Don't let the user pan too far.
                        if new_lims(1) < o.x_min
                            new_lims = o.x_min + [0 diff(new_lims)];
                        end
                        if new_lims(2) > o.x_max
                            new_lims = o.x_max - [diff(new_lims) 0];
                        end

                    end
                    
                    % Update the axes.
                    set(o.button_down_axes, 'XLim', new_lims);
                    set(h_axes, 'XLim', new_lims)

                case 'rightarrow'

                    % Get current axes for this figure.
                    h_axes = get(o.h_fig, 'CurrentAxes');
                    if isempty(o.button_down_axes)
                        old_lims = get(h_axes, 'XLim');
                    else
                        old_lims = get(o.button_down_axes, 'XLim');
                    end

                    % Calculate the new limits
                    if (ismember (event.Modifier,{'shift'})) 

                        % Zoom
                        mid_lims = sum (old_lims) * 0.5;
                        new_lims = (old_lims - mid_lims) * 0.8 + mid_lims;

                        % Don't let the user zoom too far.
                        new_lims(1) = max (new_lims(1), o.x_min);
                        new_lims(2) = min (new_lims(2), o.x_max);

                    else

                        % Pan
                        new_lims = old_lims - diff(old_lims) * 0.1;

                        % Don't let the user pan too far.
                        if new_lims(1) < o.x_min
                            new_lims = o.x_min + [0 diff(new_lims)];
                        end
                        if new_lims(2) > o.x_max
                            new_lims = o.x_max - [diff(new_lims) 0];
                        end

                    end

                    % Update the axes.
                    set(o.button_down_axes, 'XLim', new_lims);
                    set(h_axes, 'XLim', new_lims)

                case 'downarrow'

                    % Get current axes for this figure.
                    h_axes = get(o.h_fig, 'CurrentAxes');
                    if isempty(o.button_down_axes)
                        old_lims = get(h_axes, 'YLim');
                    else
                        old_lims = get(o.button_down_axes, 'YLim');
                    end

                    % Calculate the new limits
                    if (ismember (event.Modifier,{'shift'}))  
                        % Zoom
                        mid_lims = sum (old_lims) * 0.5;
                        new_lims = (old_lims - mid_lims) * 1.2 + mid_lims;
                    else
                        new_lims = old_lims + diff(old_lims) * 0.02; 
                    end

                    % Update the axes.
                    set(o.button_down_axes, 'YLim', new_lims);
                    set(h_axes, 'YLim', new_lims)

                case 'uparrow'

                    % Get current axes for this figure.
                    h_axes = get(o.h_fig, 'CurrentAxes');
                    if isempty(o.button_down_axes)
                        old_lims = get(h_axes, 'YLim');
                    else
                        old_lims = get(o.button_down_axes, 'YLim');
                    end

                    % Calculate the new limits
                    if (ismember (event.Modifier,{'shift'}))  
                        % Zoom
                        mid_lims = sum (old_lims) * 0.5;
                        new_lims = (old_lims - mid_lims) * 0.8 + mid_lims;
                    else
                        new_lims = old_lims - diff(old_lims) * 0.02; 
                    end

                    % Update the axes.
                    set(o.button_down_axes, 'YLim', new_lims);
                    set(h_axes, 'YLim', new_lims)

                case {'escape','return'}
                    
                    % Autoscale axes
                    h_axes = get(o.h_fig, 'CurrentAxes');
                    set(h_axes, 'XLim', o.x_reset);
                    set(h_axes, 'YLim', o.y_reset);
                    
            end

            % If there's a callback attachment, execute it.
            execute_callback(o.wkpf, h, event, varargin{:});
            
        end

        % The user has pressed a key on the keyboard.
        function KeyRelease(o, h, event, varargin)

            set (o.h_fig, 'SelectionType','normal');

            % If there's a callback attachment, execute it.
            execute_callback(o.wkpf, h, event, varargin{:});
            
        end
    end
    
end

% Execute whatever callback was requested.
function execute_callback(cb, h, event, varargin)
    if ~isempty(cb)
        if isa(cb, 'function_handle')
            cb(h, event)
        elseif iscell(cb)
            cb(h, event, varargin{:})
        else
            eval(cb);
        end
    end
end
