function [frame_video] = dispEventsVideo(events,vid)
%%% 
% txyp: timestamp, x, y, polarity
% dt: time window for each frame
% fps: frames per second for video
%%%
saveVid = 1;
txyp = events.e_data;
dt = vid.dt;
fps = vid.fps;
vid_name = vid.fname;
if size(txyp,1) ~=4
    txyp = txyp';
end

e_num = size(txyp, 2);

timer = dt;
frame_video = [];
event_id = 1;
frame = 0.5*ones(180,240);
while e_num ~= 0
    
    event_time = txyp(1,event_id);
    if event_time < timer
        frame(txyp(3,event_id)+1,txyp(2,event_id)+1) = txyp(4,event_id);
    else
        if timer == dt
            frame_video = frame;
        else
            frame_video = cat(3,frame_video,frame);
        end
        timer = timer + dt;
        frame = 0.5*ones(180,240);
    end
    event_id = event_id + 1;

    e_num = e_num - 1;
    
end

if nargin < 3
    fps = 10;
end

if saveVid == 1
    saveVideo(frame_video,vid_name,fps);
end
end