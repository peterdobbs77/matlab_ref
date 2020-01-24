% Application of Low Rank Approximation in Image Compression
clear; close all;
file='./Otis.jpg';

A = imread(file);

B = double(A(:,:,1))+1;       % converts A into double-precision format

B = B/256;                    % Gives values between 0 and 1
[U, S, V] = svd(B);

% 1) What are the dimensions of U, S, and V?
dimU = size(U);
dimS = size(S);
dimV = size(V);
%   Compute the best rank-r approx to B
r = 2952;  % change this value for rank number
rank_r = U(:,1:r)*S(1:r,1:r)*V(:,1:r)';

% three copies are necessary for RGB values
C(:,:,1) = rank_r;
C(:,:,2) = rank_r;
C(:,:,3) = rank_r;

% truncate the approximations to fit
C(:,:,:) = min(1,C(:,:,:));
C(:,:,:) = max(0,C(:,:,:));

% view the resulting image
figure
image(C); axis equal; axis off;

%find compression ratio
in = imfinfo(file);
imwrite(C,'rankNApproximation_Otis.jpg'); 
k = imfinfo('rankNApproximation_Otis.jpg'); 
original = in.FileSize;
compressed = k.FileSize;
compression_ratio = original/compressed;
disp(compression_ratio);