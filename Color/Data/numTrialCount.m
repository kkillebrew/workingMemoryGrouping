clear all
close all


load('usableParticipants.mat')
% usableParticipants = {'001', '002', '003'};

% Array for Frequency number
freqList = [3 5 12 20];

conditionList = {'grpPrb3_5','grpPrb3_12','grpPrb3_20','grpPrb5_3','grpPrb5_12','grpPrb5_20',...
    'grpPrb12_3','grpPrb12_5','grpPrb12_20','grpPrb20_3','grpPrb20_5','grpPrb20_12',...
    'noGrp3_5','noGrp3_12','noGrp3_20','noGrp5_3','noGrp5_12','noGrp5_20',...
    'noGrp12_3','noGrp12_5','noGrp12_20','noGrp20_3','noGrp20_5','noGrp20_12'};

inputFile = '/Volumes/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Color/Data/';
% inputFile = '/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Color/Data/';


for i=1:length(usableParticipants)
   counter = 0;
   for j=freqList
       for k=freqList
           if j==k
           else
               counter=counter+1;
               holderArrayGroup = cell2mat(struct2cell(load(sprintf('%s%s%s%d%s%d',inputFile,usableParticipants{i},'/grpPrb',j,'_',k))));
               holderArrayNoGroup = cell2mat(struct2cell(load(sprintf('%s%s%s%d%s%d',inputFile,usableParticipants{i},'/noGrp',j,'_',k))));
               
               % Store the number of trials per condition per participant
               numTrials(counter,i,1) = size(holderArrayGroup,1);
               numTrials(counter,i,2) = size(holderArrayNoGroup,1);
    
               clear holderArrayGroup holderArrayNoGroup    
           end
       end
   end
end