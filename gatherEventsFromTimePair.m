function ev_bucket = gatherEventsFromTimePair(ev,start_time,end_time)

ev_all = ev.e_data;
ev_bucket = [];
for i = 1:size(ev_all,2)
    ts = ev_all(1,i);
    if ts >= start_time && ts <= end_time
        ev_bucket = [ev_bucket, ev_all(:,i)];
    end
end

end