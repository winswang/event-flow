function plotFlowAndEvents(events,flow)
% assume right now only two frames
txyp = events.ev_bucket{events.flow_idx};
plot_name = strcat(events.data_folder,'/EventsAndFlowLK');
polarity = txyp(4,:);
pos_rid = polarity > 0;
neg_rid = polarity <= 0;

mode = events.plot_mode;
figure;
if mode == 0 || mode == 2
    scatter3(txyp(2,neg_rid),txyp(3,neg_rid),txyp(1,neg_rid),'.','MarkerEdgeColor','b','MarkerEdgeAlpha',.7);
end
if mode > 0
    hold on
    scatter3(txyp(2,pos_rid),txyp(3,pos_rid),txyp(1,pos_rid),'.','MarkerEdgeColor','r','MarkerEdgeAlpha',.7)
end

xlabel('x');
zlabel('Time [s]');
ylabel('y');

hold on;
q = quiver3(flow.x,flow.y,flow.z,flow.u,flow.v,flow.w);
q.Color = [228,192,44]/255;
q.AutoScale = 'off';
daspect([1,1,0.003]);
axis tight;
% axis square
sdf('plot_chart');
OptionZ.FrameRate=10;OptionZ.Duration=8;OptionZ.Periodic=true;
CaptureFigVid([-20,10;-110,10;-190,80;-290,10;-380,10], plot_name,OptionZ)
end