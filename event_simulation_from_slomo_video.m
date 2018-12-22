clear all; close all
addpath('/Users/winstonwang/Google_Drive/Northwestern/ReImagine/slow_motion_video/');
slomo_video_folder = 'car_moving_right_16bit';
%% read frames (2 each time)
video_list = dir('/Users/winstonwang/Google_Drive/Northwestern/ReImagine/slow_motion_video/car_moving_right_16bit');
video_folder_str = '/Users/winstonwang/Google_Drive/Northwestern/ReImagine/slow_motion_video/car_moving_right_16bit/';
video_list(1:2) = [];
start_frame_idx = 1;
inter_frame_idx = [25,75];
end_frame_idx = 10;
flag_crop = 1;
crop_idx = [151,1102,351,1702];
flag_resize = 1;
rsz = 0.25;
event_eps = 0.95*1e-1;
ev_pos_xyt = [];
ev_neg_xyt = [];
tstamp_noisy = 0;
inter_disp_frame = [];
for i = start_frame_idx:end_frame_idx
    whole_frame = im2double(rgb2gray(imread(strcat(video_folder_str,video_list(i).name))));
    if flag_crop == 1
        crop_frame = whole_frame(crop_idx(1):crop_idx(2),crop_idx(3):crop_idx(4));
    else
        crop_frame = whole_frame;
    end
    if flag_resize == 1
        current_frame = imresize(crop_frame,rsz,'bicubic');
    else
        current_frame = crop_frame;
    end
    [fr_row,fr_col] = size(current_frame);
    switch i
        case start_frame_idx
            start_frame = current_frame;
            pre_frame = current_frame;
            inter_disp_frame = current_frame;
            inter_disp_idx = i;
        otherwise
            if i == inter_frame_idx(1)
                ref_frames = current_frame;
            elseif i == inter_frame_idx(2)
                ref_frames = cat(3,ref_frames,current_frame);
            end
            events_frame = log(current_frame) - log(pre_frame);
            for rr = 1:fr_row
                for cc = 1:fr_col
                    if tstamp_noisy == 1
                        tstamp = i-0.5 + (rand-0.5);
                    else
                        tstamp = i-0.5;
                    end
                    if events_frame(rr,cc) >= event_eps
                        if isempty(ev_pos_xyt)
                            ev_pos_xyt = [cc, fr_row - rr, tstamp];
                        else
                            ev_pos_xyt = vertcat(ev_pos_xyt,[cc, fr_row - rr, tstamp]);
                        end
                    elseif events_frame(rr,cc) <= - event_eps
                        if isempty(ev_neg_xyt)
                            ev_neg_xyt = [cc, fr_row - rr, tstamp];
                        else
                            ev_neg_xyt = vertcat(ev_neg_xyt,[cc, fr_row - rr, tstamp]);
                        end
                    end
                end
            end
            
            if isempty(inter_disp_frame)
                inter_disp_frame = current_frame;
                inter_disp_idx = i;
            else
                if i <= end_frame_idx
                    inter_disp_frame = cat(3,inter_disp_frame,current_frame);
                    inter_disp_idx = [inter_disp_idx, i];
                end
            end
            if i == end_frame_idx
                end_frame = current_frame;
            end
            pre_frame = current_frame;
    end
end

%% scatter events
start_end_edge_color = 'none';%[199,21,133]/255;
start_end_alpha = 0.95;
inter_edge_color = [0.9,0.9,0.9]; %[255,182,223]/255
ev_edge_color = [199,21,133]/255;
ev_fr_offset = 0;
ev_face_color = [255,182,223]/255;
inter_alpha = 0.5;
plot_events = 0;
plot_ev_frame = 0;
plot_ev_leg = 0;
plot_inter_fr = 1;
inter_face_color = 'texturemap';
figure();
asratio = [1,0.08/3,1];
if plot_events ==1
    scatter3(ev_pos_xyt(:,1)+ev_fr_offset,ev_pos_xyt(:,3)-0.5,ev_pos_xyt(:,2)+ev_fr_offset,'.','MarkerEdgeColor',[30,144,255]/255,'MarkerEdgeAlpha',.7);
    hold on
    scatter3(ev_neg_xyt(:,1)+ev_fr_offset,ev_neg_xyt(:,3)-0.5,ev_neg_xyt(:,2)+ev_fr_offset,'.','MarkerEdgeColor',[220,20,60]/255,'MarkerEdgeAlpha',.7);
    if plot_ev_leg == 1
        legend('Positive','Negative')
        xlabel('x [pixel]');
        ylabel('Time [s]');
        zlabel('y [pixel]');
    end
end


% plot event frames
if plot_ev_frame == 1
    ev_fr = ones(fr_row,fr_col);
    for k = 1:end_frame_idx-1
        hold on
        plot_dim1 = [1,1;fr_col,fr_col]+ev_fr_offset;
        plot_dim2 = ones(2,2)*k;
        plot_dim3 = [1,fr_row;1,fr_row]+ev_fr_offset;
        ev_fr_disp = surf(plot_dim1,plot_dim2,plot_dim3,'CData',ev_fr','FaceColor',ev_face_color,'EdgeColor',ev_edge_color);
        alpha(ev_fr_disp,inter_alpha);
    end
    axis([1,fr_col+ev_fr_offset,0,(end_frame_idx),1,fr_row+ev_fr_offset]);
    axis off
    view(-55,15)
end

if plot_events == 1
    if plot_ev_leg == 1
        legend('Positive events','Negative events');
    end
    axis([1,fr_col+ev_fr_offset,0,(end_frame_idx),1,fr_row+ev_fr_offset]);
    grid off
    view(-55,15)
end


% plot intermediate frames
emp_frame = ones(fr_row,fr_col)*0.5;
%inter_disp_idx = 0:11;
if plot_inter_fr == 1
    for k = 1:length(inter_disp_idx)
        hold on
        plot_dim1 = [1,1;fr_col,fr_col];
        plot_dim2 = ones(2,2)*(inter_disp_idx(k)-0.5);
        plot_dim3 = [fr_row,1;fr_row,1];
        inter_fr_disp = surf(plot_dim1,plot_dim2,plot_dim3,'CData',inter_disp_frame(:,:,k)','FaceColor',inter_face_color,'EdgeColor',inter_edge_color);
        %inter_fr_disp = surf(plot_dim1,plot_dim2,plot_dim3,'CData',emp_frame','FaceColor',inter_face_color,'EdgeColor',inter_edge_color);
        alpha(inter_fr_disp,inter_alpha);
        colormap gray
    end
    axis([1,fr_col+ev_fr_offset,0,(end_frame_idx),1,fr_row+ev_fr_offset]);
    axis off

end

% plot start frame
start_frame = ref_frames(:,:,1);
hold on
plot_dim1 = [1,1;fr_col,fr_col];
plot_dim2 = ones(2,2)*(inter_frame_idx(1)/10.0);
plot_dim3 = [fr_row,1;fr_row,1];
start_fr_disp = surf(plot_dim1,plot_dim2,plot_dim3,'CData',start_frame','FaceColor','texturemap','EdgeColor',start_end_edge_color);
alpha(start_fr_disp,start_end_alpha);
colormap gray
% plot end frame
end_frame = ref_frames(:,:,2);

hold on
plot_dim1 = [1,1;fr_col,fr_col];
plot_dim2 = ones(2,2)*(inter_frame_idx(2)/10.0);
plot_dim3 = [fr_row,1;fr_row,1];
end_fr_disp = surf(plot_dim1,plot_dim2,plot_dim3,'CData',end_frame','FaceColor','texturemap','EdgeColor',start_end_edge_color);
alpha(end_fr_disp,start_end_alpha);
colormap gray

daspect(asratio);
view(-60,15)

%%


%% save data
frames = cat(3,start_frame,inter_disp_frame,end_frame);
save('car_moving_right_events_simulation.mat','frames','ev_neg_xyt','ev_pos_xyt','event_eps','fr_row','fr_col','-v7.3')