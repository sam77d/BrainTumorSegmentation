%1) Give MRI image of brain as input.
%2) Convert it to gray scale image.
%3) Apply high pass filter for noise removal.
%4) Apply median filter to enhance the quality of image.
%5) Compute threshold segmentation.
%6) Compute watershed segmentation.
%7) Compute morphological operation.
%8) Finally output will be a tumour region.

%image 1Perfect.jpg
%%
close all;
clear all;
X = imread('5Perfect.jpg');
X = imrotate(X,270);

I = rgb2gray(X);

H = padarray(2,[2 2]) - fspecial('gaussian' ,[5 5],2); % create unsharp mask

%Step 3
sharpened = imfilter(I,H);  % create a sharpened version of the image using that mask

%imshow([I sharpened]); %showing input & output images

%Step 4
Median = medfilt2(sharpened); %3x3 mean of pixels
figure;
imshow([I sharpened Median]);

%Step 5

level = multithresh(Median,2);

seg_I = imquantize(Median,level);
RGB = label2rgb(seg_I);
Threshold = rgb2gray(RGB);
figure;
imshow(Threshold)


im = Threshold;
t = 179;

im(find(im > t)) = 255;

im(find(im <= t)) = 0;


lvl = graythresh(im);
BW = im2bw(im,lvl);
imshow(BW);
%%
%Step 6 - watershed

C = ~BW;
D = -bwdist(C);
D(C) = -Inf;

L = watershed(D);
Wi=label2rgb(C,'gray','w');
%figure;
%imshow(Wi);

lvl2 = graythresh(Wi);
BW2 = im2bw(Wi,lvl2);
imshow(BW2)

%%
%Step 7 - Morphologial Operation

%BW3 = bwareaopen(BW2,40);
BW3 = BW2;
figure;
imshow(BW3)

[colBW2, num] = bwlabel(BW3);
imagesc(colBW2);
colormap jet;

%Trying to find largest connected region after getting rid of 1
% largest = 0;
% labelnum = 0;
% for i = 1:num 
%    if sum(colBW2(:)==i) > largest
%        largest = sum(colBW2(:)==i);
%        labelnum = i;
%    end 
% end

%Set all 1 labels to zero
colBW2(find(colBW2 == 1)) = 0;

% Trying to find largest connected region after getting rid of 1
largest = 0;
for i = 2:num 
   if sum(colBW2(:)==i) > largest
       largest = sum(colBW2(:)==i);
   end 
end

imagesc(colBW2)
colormap jet;
% Largest Connected Region

BW4 = bwareaopen(colBW2,largest);
figure;
imshow(BW4)
%%
%Step 8 - Overlay

% X is your image
[M,N] = size(BW4);
% Assign A as zero
A = zeros(M,N);
% Iterate through X, to assign A
for i=1:M
   for j=1:N
      if(BW4(i,j) == 0)   % Assuming uint8, 0 would be black
         A(i,j) = 1;      % Assign 1 to transparent color(black)
      end
   end
end

figure;
h = imshow(I);
hold on;
set(h,'AlphaData',A);
hold off;
figure;
imshow(I)





