function displayLPflow(par)

ev_all = par.e_data; % t x y p
neg_all = ev_all(4,:) <=0;
pos_all = ev_all(4,:) > 0;
figure;
% x, y, t
scatter3(ev_all(2,neg_all),ev_all(1,neg_all),ev_all(3,neg_all),'.','MarkerEdgeColor','b','MarkerEdgeAlpha',.3);

hold on
scatter3(ev_all(2,pos_all),ev_all(1,pos_all),ev_all(3,pos_all),'.','MarkerEdgeColor','r','MarkerEdgeAlpha',.3);

xytpv = par.xytpv; % x, y, t, p, vx, vy, vt
neg_id = xytpv(4,:) <= 0;
pos_id = xytpv(4,:) > 0;


% x, y, t
scatter3(xytpv(1,neg_id),xytpv(3,neg_id),xytpv(2,neg_id),'.','MarkerEdgeColor','b','MarkerEdgeAlpha',.7);

hold on
scatter3(xytpv(1,pos_id),xytpv(3,pos_id),xytpv(2,pos_id),'.','MarkerEdgeColor','r','MarkerEdgeAlpha',.7);




hold on;
scale = 1;
q = quiver3(xytpv(1,:),xytpv(3,:),xytpv(2,:),xytpv(5,:)*scale,xytpv(7,:)*scale,xytpv(6,:)*scale);
q.Color = [228,192,44]/255;
q.AutoScale = 'off';
daspect([1,1,1]);

xlabel('x');
zlabel('y');
ylabel('t');
axis tight;
view(120,70);
sdf('plot_chart');
%% Set up recording parameters (optional), and record
OptionZ.FrameRate=10;OptionZ.Duration=8;OptionZ.Periodic=true;
CaptureFigVid([-20,10;-110,10;-190,80;-290,10;-380,10], 'events_flow',OptionZ)
end