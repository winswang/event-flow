function saveVideo(video, name, framerate)
if nargin < 3
    framerate = 30;
end
if nargin < 2
    name = 'video';
end
if size(video,4) == 1
    [n1,n2,n3] = size(video);
    video = reshape(video,n1,n2,1,n3);
end
vi = VideoWriter(name,'MPEG-4');
vi.FrameRate = framerate;
vi.Quality = 80;
open(vi);
writeVideo(vi,video(:,:,:,:));
close(vi);

end