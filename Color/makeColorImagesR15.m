% Create the color array
colors = [255 0 0; 0 255 0; 0 0 255; 255 255 0; 255 0 255; 0 255 255];

colorName = {'Red','Green','Blue','Yellow','Purple','Cyan'};

% Where you can change the stimulus image files, etc. We are loading in 20 where the 1st 10 are black and the second 10 are same-shape white
nimages = 20;
image_tex=[];
for j=1:length(colors)
    for i=1:10
        images=imread(sprintf('%s%d%s','/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Color/shape_stimuli/',i,'.tif'));
        images2=images;
        
        for a=1:size(images,1)
            for b=1:size(images,2)
                if images(a,b,1)>60
                    images(a,b,1)=128;
                    images(a,b,2)=128;
                    images(a,b,3)=128;
                    images2(a,b,1)=128;
                    images2(a,b,2)=128;
                    images2(a,b,3)=128;
                else
                    images(a,b,1)=0;
                    images(a,b,2)=0;
                    images(a,b,3)=0;
                    images2(a,b,:)=colors(j,:);
                end
            end
        end
%         image_tex(i,j)=Screen('MakeTexture',w,images);
%         image_tex(i+10,j)=Screen('MakeTexture',w,images2);
        
        imwrite(images2,sprintf('%s%d%s%s','/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Color/color_stimuli/',i,colorName{j},'.tif'),'tif');
    end
end


