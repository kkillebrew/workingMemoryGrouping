
clear all 
close all

load('PreallSimpleShapes');

datafolder = '/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Simple Shapes/';
datafile = sprintf('%s%s',datafolder,'PreallSimpleShapes');

% Create the color array
colors = [255 0 0; 0 255 0; 0 0 255; 255 255 0; 255 0 255; 0 255 255];

% Where you can change the stimulus image files, etc. 
% We are loading in 20 where the 1st 10 are black and the second 10 are same-shape white
nimages = 10;
for i=i:nimages
    i
    images=imread(sprintf('%s%d%s','/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Simple Shapes/shape_stimuli/',i,'.tif'));
    for j=1:length(colors)
        j
        imageArrayColor(:,:,:,i,j) = images;
        for a=1:size(imageArrayColor,1)
            for b=1:size(imageArrayColor,2)
                if imageArrayColor(a,b,1,i,j)>60
                    imageArrayColor(a,b,:,i,j)=[128 128 128];
                else
                    imageArrayColor(a,b,:,i,j)=colors(j,:);
                end
            end
        end
    end
end

% Have another loop for the black alternative shapes so only one array
for i=1:nimages
    images=imread(sprintf('%s%d%s','/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Simple Shapes/shape_stimuli/',i,'.tif'));
    imageArrayBlack(:,:,:,i) = images;
    for a=1:size(imageArrayBlack,1)
        for b=1:size(imageArrayBlack,2)
            if imageArrayBlack(a,b,1,i)>60
                imageArrayBlack(a,b,:,i)=[128 128 128];
            else
                imageArrayBlack(a,b,:,i)=[0 0 0];
            end
        end
    end
end

imageSquare=imread(sprintf('%s%d%s','/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Simple Shapes/shape_stimuli2/',1,'.tif'));
imageSquare=imageSquare(:,:,1);

for a=1:size(imageSquare,1)
    for b=1:size(imageSquare,2)
        if imageSquare(a,b)>60
            imageSquare(a,b)=128;
        else
            imageSquare(a,b)=0;
        end
    end
end


save(datafile,'imageArrayColor','imageArrayBlack','imageSquare','colors');



