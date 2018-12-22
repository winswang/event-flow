clear all;clc;close all
%% import events
% events.data_path = '/Users/winstonwang/Google_Drive/Data/DAVIS_events/';
% events.data_folder = 'shapes_rotation';
% events.data_fname = strcat(events.data_path,events.data_folder,'/events.txt');
% read_info.e_fileID = fopen(events.data_fname,'r');
% read_info.e_formatSpec = '%f %d %d %d';
% read_info.e_size = [4 1e5];
% events.e_data = fscanf(read_info.e_fileID,read_info.e_formatSpec,read_info.e_size);
% fclose(read_info.e_fileID);
% mkdir(events.data_folder)


%% import images
% images.data_path = strcat(events.data_path,events.data_folder);
% read_info.i_infoID = fopen(strcat(images.data_path,'/images.txt'),'r');
% read_info.i_formatSpec = '%f %s';
% read_info.i_size = [2, Inf];
% images.raw_read = textscan(read_info.i_infoID,read_info.i_formatSpec);
% images.i_tstamp = images.raw_read{1,1};
% images.i_filestr = images.raw_read{1,2};
% fclose(read_info.i_infoID);

%% load previously-saved data
load('shapes_rotation.mat');
%% extract frames
evim_test.start_time = 0.0;
evim_test.end_time = 0.08;
events.e_data(:,events.e_data(1,:)<evim_test.start_time) = [];
evim_test = extractEventsReadFrames(events,evim_test,images);

%% scale timestamp
% operate on evim_test
tscale = 400;
toffset = 100;
evim_test.tscale = tscale;
evim_test.toffset = toffset;
clear evim_test.ev_bucket_scale
for i = 1:size(evim_test.ev_bucket,2)
    temp_ev = evim_test.ev_bucket{i};
    temp_tmin = evim_test.t_pair{i}(1);
    temp_tmax = evim_test.t_pair{i}(2);
    evim_test.exposure = temp_tmax - temp_tmin;
    temp_ev(1,:) = (temp_ev(1,:) - temp_tmin)/(temp_tmax - temp_tmin)*tscale+toffset;
    evim_test.ev_bucket_scale{i} = temp_ev;
end
clear temp_ev temp_tmin temp_tmax toffset tscale i
%% OF-LK
clear flowLK
evim_test.flow_idx = 1;
evim_test.plot_mode = 2;
evim_test.implay_images = 0;
evim_test.data_folder = events.data_folder;
flowLK = MyOptFlowLK(evim_test);
plotFlowAndEvents(evim_test,flowLK);
%% OF-Local Plane Fitting
evim_test.th1 = 1e-2 * 100;
evim_test.th2 = 0.01* 100;
evim_test.s_wid = 4;
evim_test.flow_idx = 1;
evim_test.t_wid = 1e-2/evim_test.exposure*evim_test.tscale;
par = MyOptFlowEvPF(evim_test);
par.e_data = evim_test.ev_bucket_scale{evim_test.flow_idx};
displayLPflow(par);
%% plot 3D flow

%% plot events
events.plot_mode = 2; % 0-negative; 1-positive; 2-both
plotAllEvents(events);
%% plot events and frames
events_frames = images;
events_frames.e_data = events.e_data;
events_frames.start_time = 0.5;
events_frames.end_time = 0.9;
plotEventsAndFrames(events_frames);

%% visualize events
vid_from_ev.dt = 1/50;
vid_from_ev.fps = 15;
vid_from_ev.fname = strcat(events.data_folder,'/FrameVideo','_fps_',num2str(1/vid_from_ev.dt));
[vid_from_ev.video] = dispEventsVideo(events,vid_from_ev);

% event histogram
eventsHist(events,vid_from_ev);
saveas(gcf,strcat(events.data_folder,'/Events_histogram'),'epsc');



















































%% save dataset
save(strcat(events.data_folder,'/Events_data'));