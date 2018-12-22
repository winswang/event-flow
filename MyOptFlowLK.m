function flowLK = MyOptFlowLK(events)

plotIms = events.implay_images;


plotFlow = 1;

im_pair = events.im_pair{events.flow_idx};

im1 = im_pair(:,:,1);
im2 = im_pair(:,:,2);

if plotIms == 1
    implay(im_pair);
end

ww = 40;
w = round(ww/2);

image_resize = 1;
if image_resize == 1
    fr1 = imresize(im1,0.5);
    fr2 = imresize(im2,0.5);
else
    fr1 = im1;
    fr2 = im2;
end

% Lucas Kanade Here
% for each point, calculate I_x, I_y, I_t
Ix_m = conv2(fr1,[-1 1; -1 1], 'valid'); % partial on x
Iy_m = conv2(fr1, [-1 -1; 1 1], 'valid'); % partial on y
It_m = conv2(fr1, ones(2), 'valid') + conv2(fr2, -ones(2), 'valid'); % partial on t
u = zeros(size(fr1));
v = zeros(size(fr2));

% within window ww * ww
for i = w+1:size(Ix_m,1)-w
   for j = w+1:size(Ix_m,2)-w
      Ix = Ix_m(i-w:i+w, j-w:j+w);
      Iy = Iy_m(i-w:i+w, j-w:j+w);
      It = It_m(i-w:i+w, j-w:j+w);

      Ix = Ix(:);
      Iy = Iy(:);
      b = -It(:); % get b here

      A = [Ix Iy]; % get A here
      nu = pinv(A)*b; % get velocity here

      u(i,j)=nu(1);
      v(i,j)=nu(2);
   end;
end;
downsize = 1;
dstep = 5;
% downsize u and v
if downsize == 1
    u_deci = u(1:dstep:end, 1:dstep:end);
    v_deci = v(1:dstep:end, 1:dstep:end);
    % get coordinate for u and v in the original frame
    [m, n] = size(im1);
    [X,Y] = meshgrid(1:n, 1:m);
    if image_resize == 1
        X_deci = X(1:dstep*2:end, 1:dstep*2:end);
        Y_deci = Y(1:dstep*2:end, 1:dstep*2:end);

    else
        X_deci = X(1:dstep:end, 1:dstep:end);
        Y_deci = Y(1:dstep:end, 1:dstep:end);
    end
end

time_pair = events.t_pair{events.flow_idx};
T = ones(size(X_deci))*time_pair(1);
dT = ones(size(X_deci))*(time_pair(2)-time_pair(1));
Allzeros = u_deci == 0 | v_deci == 0;
dT(Allzeros) = 0;

if plotFlow == 1
    figure();
    imshow(mean(im_pair,3));
    hold on;
    % draw the velocity vectors
    q = quiver(X_deci, Y_deci, u_deci,v_deci);
    q.Color = 'y';
    q.AutoScale = 'off';
end
flowLK.x = X_deci;
flowLK.y = Y_deci;
flowLK.u = u_deci;
flowLK.v = v_deci;
flowLK.z = T;
flowLK.w = dT;
end