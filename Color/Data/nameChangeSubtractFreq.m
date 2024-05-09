clear all
close all

% Array for Frequency number
freqList = [3 5 12 20];

inputFile = '/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Color/Data/';

load(sprintf('%s%s',inputFile,'usableParticipants.mat'))

for a=1:length(usableParticipants)'
    for i=freqList
        load(sprintf('%s%s%s%s%d%s',inputFile,usableParticipants{a},'/FreqValues2/','noGrpFreq',i,'_sub'));
        for j=freqList
            if j == i
                
            else
                load(sprintf('%s%s%s%s%d%s%d%s',inputFile,usableParticipants{a},'/FreqValues2/','grpFreq',i,'_',j,'_sub'));
                
                eval(sprintf('%s%d%s%d%s%d%s%d','grpFreq',i,'_',j, '_sub= grpFreq',i,'_',j));
                
                save(sprintf('%s%s%s%s%d%s%d%s',inputFile,usableParticipants{a},'/FreqValues2/','grpFreq',i,'_',j,'_sub'),...
                    sprintf('%s%d%s%d%s','grpFreq',i,'_',j,'_sub'));
                
            end
        end
        
        eval(sprintf('%s%d%s%d','noGrpFreq',i, '_sub= noGrpFreq',i));
        
        save(sprintf('%s%s%s%s%d%s',inputFile,usableParticipants{a},'/FreqValues2/','noGrpFreq',i,'_sub'),...
            sprintf('%s%d%s','noGrpFreq',i,'_sub'));
    end
end