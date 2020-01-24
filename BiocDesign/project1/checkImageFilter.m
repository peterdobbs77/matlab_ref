clear; close all;
%x=78;y=56;r=21;

im_spatial=readFloat('eye_test_image4.jpg.bin',90,130);
figure(1);
imagesc(im_spatial); colormap(gray); axis equal; axis off;

im_edge=readFloat('edgeDetection_output_XY.bin', 90, 130);
figure(2);
imagesc(im_edge); colormap(gray); axis equal; axis off;

%hold on;
%th = 0:pi/50:2*pi;
%xunit = r*cos(th)+x;
%yunit = r*sin(th)+y;
%h = plot(xunit,yunit);
%hold off;
