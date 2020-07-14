function [ ] = plotGraph( mode, y, handles, n )
%% FUNCTION TO PLOT GIVEN VECTORS

axesNames = {'axes7', 'axes9', 'axes8', 'axes10'};
if (mode == -1)
    %for i = 1 : n,
    %set(handles.sumAxes, 'Visible', 'on');
    %set(handles.closeSum, 'Visible', 'on');
        figure;
        plot(y{1,1},y{1,2});%, 'Parent', handles.sumAxes);
        %set((handles.sumAxes), 'XAxisLocation', 'top');
        %set((handles.sumAxes), 'YAxisLocation', 'right');
    %end;
elseif (mode == 1)
    if( n == 1 )
        figure;
    end;
    subplot(2,1,n);
    plot(y{1,1}, y{1,2});
else
    % CLEAR PREVIOUS PLOTS
    cla(handles.axes7); cla(handles.axes9); cla(handles.axes8); cla(handles.axes10);
    for i = 1 : n,
        plot(y{i, 1}, y{i, 2}, 'Parent', handles.(axesNames{i}));
        set(handles.(axesNames{i}), 'XAxisLocation', 'top');
        set(handles.(axesNames{i}), 'YAxisLocation', 'left');
    end;

end

