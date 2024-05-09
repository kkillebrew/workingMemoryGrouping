clear all 
close all

inputFile = '/Volumes/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Color/Data/';

% subjID = {'K003','MC','KM','KK','NS','K005','MG','CB','CC','SR','CR','TL','K006','AW','MM','GG','K007','K008','K009','K010'};
load(sprintf('%s',inputFile,'/usableParticipants_VEP_BLC'));
subjID = usableParticipants;

conditionList = {'grpPrb3_5','grpPrb3_12','grpPrb3_20','grpPrb5_3','grpPrb5_12','grpPrb5_20',...
    'grpPrb12_3','grpPrb12_5','grpPrb12_20','grpPrb20_3','grpPrb20_5','grpPrb20_12',...
    'noGrp3_5','noGrp3_12','noGrp3_20','noGrp5_3','noGrp5_12','noGrp5_20',...
    'noGrp12_3','noGrp12_5','noGrp12_20','noGrp20_3','noGrp20_5','noGrp20_12'};

freqList = [3 5 12 20];

combinedGroupArray = [];
combinedNoGroupArray = [];
totalLengthNG = 0;
totalLengthG = 0;

for a=1:length(subjID)
    
    a
    % Average together the 'grouped' data
    for i=freqList
        i
        for j=freqList
            j
            if j == i
            else
                load(sprintf('%s%s%s%s%d%s%d',inputFile,subjID{a},'/VEP Data/Baseline_Correct/','grpPrb',i,'_',j));
                totalLengthG = totalLengthG + size(eval(sprintf('%s%d%s%d','grpPrb',i,'_',j)),1);
                
                for k=1:size(eval(sprintf('%s%d%s%d','grpPrb',i,'_',j)),1)
                    combinedGroupArray(length(combinedGroupArray)+1,:,:) = eval(sprintf('%s%d%s%d%s','grpPrb',i,'_',j,'(k,:,:)'));
                end
                
                load(sprintf('%s%s%s%s%d%s%d',inputFile,subjID{a},'/VEP Data/Baseline_Correct/','noGrp',i,'_',j));
                totalLengthNG = totalLengthNG + size(eval(sprintf('%s%d%s%d','noGrp',i,'_',j)),1);
                
                for k=1:size(eval(sprintf('%s%d%s%d','noGrp',i,'_',j)),1)
                    combinedNoGroupArray(length(combinedNoGroupArray)+1,:,:) = eval(sprintf('%s%d%s%d%s','noGrp',i,'_',j,'(k,:,:)'));
                end
            end
        end
    end
    
    
%     % Average together the 'not grouped' data
%     for i=freqList
%         load(sprintf('%s%s%s%s%d',inputFile,subjID{a},'/VEP Data/','noGrp',i));
%         totalLengthNG = totalLengthNG + length(eval(sprintf('%s%d','noGrp',i)));
%         
%         for k=1:length(eval(sprintf('%s%d','noGrp',i)))
%             combinedNoGroupArray{length(combinedNoGroupArray)+1} = eval(sprintf('%s%d%s','noGrp',i,'{k}'));
%         end
%     end
end

% Average over all trials
% Convert to 3d array for averaging
% holderArray = [];
% for i=1:totalLengthG
%     holderArray(:,:,i) = combinedGroupArray{i}(:,:);
% end

meanGroupArray = squeeze(mean(combinedGroupArray,1));
meanGroupArray = meanGroupArray;

% holderArray = [];
% for i=1:totalLengthNG
%      holderArray(:,:,i) = combinedNoGroupArray{i}(:,:);
% end

meanNoGroupArray = squeeze(mean(combinedNoGroupArray,1));
meanNoGroupArray = meanNoGroupArray;

% Create the difference waves
meanDiff = meanNoGroupArray - meanGroupArray;

figure()
subplot(1,3,1)
plot(meanGroupArray);
str = {'','Grouped VEP',''}; % cell-array method
xlabel('Time (s)','FontSize',15);
ylabel('Amplitude','FontSize',15);
title(str,'FontSize',15,'FontWeight','bold');
set(gca,'ylim',[-40,20])

subplot(1,3,2)
plot(meanNoGroupArray);
str = {'','Not Grouped VEP',''}; % cell-array method
xlabel('Time (s)','FontSize',15);
ylabel('Amplitude','FontSize',15);
title(str,'FontSize',15,'FontWeight','bold');
set(gca,'ylim',[-40,20])

subplot(1,3,3)
plot(meanDiff);
str = {'','Not Grouped - Grouped',''}; % cell-array method
xlabel('Time (s)','FontSize',15);
ylabel('Amplitude','FontSize',15);
title(str,'FontSize',15,'FontWeight','bold');
set(gca,'ylim',[-40,20])

save('VEPGrouped_BLC','meanGroupArray')
save('VEPNotGrouped_BLC','meanNoGroupArray')
save('VEPDiff_BLC','meanDiff')








