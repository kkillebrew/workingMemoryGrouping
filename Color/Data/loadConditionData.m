clear all 
close all

subjID = 'KK';

inputFile = '/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Color/Data/';

conditionList = {'grpPrb3_5','grpPrb3_12','grpPrb3_20','grpPrb5_3','grpPrb5_12','grpPrb5_20',...
    'grpPrb12_3','grpPrb12_5','grpPrb12_20','grpPrb20_3','grpPrb20_5','grpPrb20_12',...
    'grpNoPrb3','grpNoPrb5','grpNoPrb12','grpNoPrb20',...
    'noGrp3','noGrp5','noGrp12','noGrp20',};

for i=1:length(conditionList)
   
    load(sprintf('%s%s%s%s',inputFile,subjID,'/',conditionList{i}));
    
end