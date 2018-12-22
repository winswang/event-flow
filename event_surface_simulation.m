close all
[x,y] = meshgrid(linspace(2,8,20),linspace(2,8,20));
z = x.*sin(0.5*y);
figure;
clear co
co(:,:,1) = zeros(20);
[co(:,:,2),co(:,:,3)] = meshgrid(linspace(0,1,20),linspace(205/255.0,127/255.0,20));
s = surf(x,y,z,co,'EdgeColor','none','FaceColor','interp','FaceAlpha',0.5);
xlabel('x');
ylabel('y');
zlabel('t');
axis([0,10,0,10,-10,10]);
daspect([1,1,5]);
view(-118,23);
print('event_surface','-dpng','-r220');
surface_vid(:,:,:,1) = imread('event_surface.png');
point = [7,4,7*sin(0.5*4)];
hold on 
p = scatter3(point(1),point(2),point(3),20,[178,34,34]/255.0,'filled');
xlabel('x');
ylabel('y');
zlabel('t');
axis([0,10,0,10,-10,10]);
daspect([1,1,5]);
view(-118,23);
print('event_surface','-dpng','-r220');
surface_vid(:,:,:,2) = imread('event_surface.png');
[px,py] = meshgrid(linspace(6,8,10),linspace(3,5,10));
dzx = sin(0.5*point(2));
dzy = cos(0.5*point(2))*0.5*point(1);
pz = dzx*(px - point(1)) + dzy*(py - point(2)) + point(3);
hold on
%[csp(:,:,1),csp(:,:,2),csp(:,:,3)] = meshgrid(linspace(220/255.0,1,10),linspace(20/255.0,215/255.0,10),linspace(60/255.0,0,10));
sp = surf(px,py,pz,'EdgeColor','none','FaceColor','interp','FaceAlpha',0.7);
colormap autumn
% q = quiver3(point(1),point(2),point(3),1/dzx,1/dzy,1);
% q.Color = [128,0,0]/255.0;
xlabel('x');
ylabel('y');
zlabel('t');
axis([0,10,0,10,-10,10]);
daspect([1,1,5]);
view(-118,23);
print('event_surface','-dpng','-r220');
surface_vid(:,:,:,3) = imread('event_surface.png');
saveVideo(surface_vid,'event_surface',1);