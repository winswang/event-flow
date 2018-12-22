function ev_im_test = extractEventsReadFrames(events,ev_im_test,images)
start_time = ev_im_test.start_time;
end_time = min(max(images.i_tstamp),ev_im_test.end_time);
ev_im_test.im_pair = {};
ev_im_test.ev_bucket = {};
ev_im_test.t_pair = {};
idx = 1;

for i = 1:size(images.i_tstamp,1)-1
    tstamp = images.i_tstamp(i);
    tstamp_next = images.i_tstamp(i+1);
    if tstamp >= start_time && tstamp_next < end_time
        if idx == 1
            im1 = im2double(imread(strcat(images.data_path,'/',images.i_filestr{i})));
            im2 = im2double(imread(strcat(images.data_path,'/',images.i_filestr{i+1})));
        else
            im1 = im2;
            im2 = im2double(imread(strcat(images.data_path,'/',images.i_filestr{i+1})));
        end
        ev_im_test.im_pair{idx} = cat(3,im1,im2);
        ev_im_test.ev_bucket{idx} = gatherEventsFromTimePair(events,tstamp,tstamp_next);
        ev_im_test.t_pair{idx} = [tstamp, tstamp_next];
        idx = idx + 1;
    end
end

end