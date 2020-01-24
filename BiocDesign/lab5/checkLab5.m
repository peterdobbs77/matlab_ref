%read in a binary image.  Change the file name as needed
im_spatial=readFloat('lab5_spatial_image.bin', 256, 256);
%view the image
figure;
imagesc(im_spatial); colormap(gray); axis image; axis off;

%image = imread('lab5_spatial_image.bin');

%imshow(image);