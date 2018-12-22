function eventsHist(events,vid)
% input event ev must have size of [4, ev#]

ev = events.e_data;
dt = vid.dt;

e_time = ev(1,:);
e_p = ev(4,:);
pos_id = e_p == 1;

nbins = floor(max(e_time)/dt);
figure;
histogram(e_time,nbins,'FaceColor',[220,20,60]/255,'EdgeColor','w','FaceAlpha',0.7);
hold on
histogram(e_time(pos_id),nbins,'FaceColor',[30,144,255]/255,'EdgeColor','w','FaceAlpha',0.7);
xlabel('Time');
ylabel('Number of events');
legend('Negative','Positive');
sdf('plot_chart');
end