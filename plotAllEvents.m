function plotAllEvents(events)
%% This is a function to plot events data
%% input: t_x_y_p: time, x and y position, polarity (0 or 1)
%% input: mode: 0-> show only negative events; 1-> only positive events; 2-> both;

t_x_y_p = events.e_data;
mode = events.plot_mode;
ev_plot_name = strcat(events.data_folder,'/Events3dPlot');
[s1,s2] = size(t_x_y_p);
if s1 ~= 4
    t_x_y_p = t_x_y_p';
end
if nargin < 2
    mode = 2;
end

polarity = t_x_y_p(4,:);
pos_rid = polarity > 0;
neg_rid = polarity <= 0;

figure;clf;
if mode == 0 || mode == 2
    scatter3(t_x_y_p(2,neg_rid),t_x_y_p(1,neg_rid),t_x_y_p(3,neg_rid),'.','MarkerEdgeColor','b','MarkerEdgeAlpha',.7);
end
if mode > 0
    hold on
    scatter3(t_x_y_p(2,pos_rid),t_x_y_p(1,pos_rid),t_x_y_p(3,pos_rid),'.','MarkerEdgeColor','r','MarkerEdgeAlpha',.7)
end

xlabel('x');
ylabel('Time [s]');
zlabel('y');
%% Set up 3D plot to record
daspect([1,0.003,1]);
axis tight;
% axis square
sdf('plot_chart');
%% Set up recording parameters (optional), and record
OptionZ.FrameRate=10;OptionZ.Duration=8;OptionZ.Periodic=true;
CaptureFigVid([-20,10;-110,10;-190,80;-290,10;-380,10], ev_plot_name,OptionZ)
