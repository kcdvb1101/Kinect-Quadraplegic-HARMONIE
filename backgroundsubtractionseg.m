function [] = backgroundsubtractionseg(blankfilename,trialfilename)
disp(blankfilename);
disp(trialfilename);
%Parameters
threshold = 4000;

G = fspecial('gaussian',[10 10], 40);

%trial = importdata('C:\Users\guy\Desktop\Segmentation_testing\spread apart\trial\IR\IR_bright_spread1.txt');
%blank = importdata('C:\Users\guy\Desktop\Segmentation_testing\blank\IR\IR_bright_blank1.txt');
blank = importdata(blankfilename);
trial = importdata(trialfilename); 

%Reshape and perform background subtraction
A = reshape(blank,512,424);
B = reshape(trial,512,424);
C = B - A;
E = mat2gray(B); 

D = C .* (C>threshold);
%fill any holes, so that regionprops can be used to estimate
%the area enclosed by each of the boundaries
D = imfill(D,'holes'); 
D = bwareaopen(D, 50);
D=D~=0; 
D = imfilter(D,G,'same');
%imagesc(D'); 
%4000 is a parameter that can later be fine-tuned

figure, imagesc(D'); 

BW2 = edge(D,'canny');

imshow(BW2');  

st = regionprops(BW2', 'BoundingBox'); 
for k = 1 : length(st)
    thisBB = st(k).BoundingBox;
    rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
    'EdgeColor', 'r', 'LineWidth',2)   
end

for k = 1 : length(st)
    thisBB = st(k).BoundingBox;
    CroppedImage = imcrop(E',[thisBB(1),thisBB(2),thisBB(3),thisBB(4)]);
    CroppedImage2 = imresize(CroppedImage, [200,200]); 
    %Repeat to save the binary images
    CroppedImage3 = imcrop(D',[thisBB(1),thisBB(2),thisBB(3),thisBB(4)]);
    CroppedImage3 = imresize(CroppedImage3, [200,200]); 
    imwrite(CroppedImage3,['object_BIN_',num2str(k),'.png']);
     
    centroid = regionprops(CroppedImage3,'Centroid');
    cent_x = centroid(1).Centroid(1); 
    cent_y = centroid(1).Centroid(2); 
    %BW = double(im2bw(BW));


    % Get the boundary.
    boundaries = bwboundaries(CroppedImage3);
    thisBoundary = boundaries{1};
    % Get the distances of the boundary pixels from the centroid.
    distances = sqrt((thisBoundary(:,1) - cent_x).^2 + (thisBoundary(:,2) - cent_y).^2);
    % Scan the boundary to find the pixel on it that is
    % farthest from the centroid.
    maxRadius = max(distances);
    minRadius = min(distances);

    %figure
    imwrite(CroppedImage2,['object',num2str(k),'.png',])
    imshow(CroppedImage2); 
    
    %Test script for dialog input 
    x = inputdlg('Enter space-separated numbers:',...
             'Sample', [1 50]);
    label = str2num(x{:});
    
    save(['object', num2str(k),'_', datestr(now, 'dd-mmm-yyyy_HH.MM.SS'),  '.mat'], ...
    'CroppedImage2', 'label','maxRadius', 'minRadius');

end

