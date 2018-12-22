function plotEventsAndFrames(evfr)
start_time = evfr.start_time;
end_time = evfr.end_time;
e_tstamp = evfr.e_data(1,:);
f_idx = 1;
for i = 1:size(evfr.i_tstamp,1)
    tstamp = evfr.i_tstamp(i);
    if tstamp >= start_time && tstamp < end_time
        if f_idx == 1
            frame = im2double(imread(strcat(evfr.data_path,'/',evfr.i_filestr{i})));
            t_frame = tstamp;
            f_idx = f_idx + 1;
        else
            temp = im2double(imread(strcat(evfr.data_path,'/',evfr.i_filestr{i})));
            frame = cat(3,frame,temp);
            t_frame = [t_frame,tstamp];
            f_idx = f_idx + 1;
        end
    end
end

fr_col = size(frame,2);
fr_row = size(frame,1);
fr_alpha = 0.6;
t_list = linspace(start_time,end_time,80);
idx = 1;
figure;
for t = 1:length(t_list)-1
    if t_list(t) >= t_frame(idx)
        % plot frame
        plot_dim1 = [fr_col,fr_col;1,1];
        plot_dim2 = ones(2,2)*t_frame(idx);
        plot_dim3 = [fr_row,1;fr_row,1];
        fr_disp = surf(plot_dim1,plot_dim2,plot_dim3,'CData',frame(:,:,idx)','FaceColor','texturemap','EdgeColor','none');
        alpha(fr_disp,fr_alpha);
        colormap gray
        if idx < length(t_frame)
            idx = idx + 1;
        end
    end
    ev2plot_idx = e_tstamp >= t_list(t) & e_tstamp < t_list(t+1);
    ev2plot = evfr.e_data(:,ev2plot_idx);
    ev_pos_idx = ev2plot(4,:)>0;
    ev_pos = ev2plot(1:3,ev_pos_idx);
    ev_neg_idx = ev2plot(4,:)<=0;
    ev_neg = ev2plot(1:3,ev_neg_idx);
    % ev in t x y
    hold on
    scatter3(fr_col - ev_pos(2,:),ev_pos(1,:),fr_row - ev_pos(3,:),'.','MarkerEdgeColor',[30,144,255]/255,'MarkerEdgeAlpha',.4);
    hold on
    scatter3(fr_col - ev_neg(2,:),ev_neg(1,:),fr_row - ev_neg(3,:),'.','MarkerEdgeColor',[220,20,60]/255,'MarkerEdgeAlpha',.4);
    xlabel('x');
    ylabel('Time [s]');
    zlabel('y');
    axis([0,fr_col,start_time,end_time,0,fr_row]);
    daspect([1,0.0007,1]);
    view(115,15);
    fig = gcf;
    print('evfr_disp','-dpng','-r220');
    if t == 1
        disp_frame = imread('evfr_disp.png');
    else
        disp_frame = cat(4,disp_frame,imread('evfr_disp.png'));
    end
    
end

saveVideo(disp_frame, 'event_frame_vis', 10);
