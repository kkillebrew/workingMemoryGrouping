clear all
close all

% Array for Frequency number
freqList = [3 5 12 20];

inputFile = '/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Color/Data/';

load(sprintf('%s%s',inputFile,'usableParticipants.mat'))

% Which electrode groups you want to average together
O1single = 124;
O2single = 149;

P1single = 100;
P2single = 129;

C1single = 45;
C2single = 132;

O1 = [116, 125, 124, 123, 136, 135];
O2 = [138, 150, 149, 148, 158, 157];

P1 =  [89, 89, 100, 110, 99, 87];
P2 = [128, 129, 130, 142, 141, 153];

C1 = [45, 53, 60, 52, 44, 43];
C2 = [132, 144, 155, 185, 184, 197];

channels = {'O1','O2','P1','P2','C1','C2'};

freqCombos = {'f1+f2','f1+2f2','2f1+f2','2f1+2f2'};
freqCombosInd = {'f1','f2','2f1','2f2'};
freqCombosSub = {'f1-f2','f1-2f2','2f1-f2','2f1-2f2'};

for a=1:length(usableParticipants)'
    
    % load in the freq arrays for no group and group
    for i=freqList
        load(sprintf('%s%s%s%s%d',inputFile,usableParticipants{a},'/FreqValues.test_freqs2/','noGrpFreq',i));
        load(sprintf('%s%s%s%s%d%s',inputFile,usableParticipants{a},'/FreqValues/','noGrpFreq',i,'_sub'));
        for j=freqList
            if j == i
                
            else
                load(sprintf('%s%s%s%s%d%s%d',inputFile,usableParticipants{a},'/FreqValues.test_freqs2/','grpFreq',i,'_',j));
                load(sprintf('%s%s%s%s%d%s%d%s',inputFile,usableParticipants{a},'/FreqValues/','grpFreq',i,'_',j,'_sub'));
            end
        end
    end
    
    % divide up the frequencies so you have arrays of the f1+f2 etc. for
    % each combination of frequencies. Ex. f1+f2 for 3hz 5hs, 3hz 12hz,
    % etc. 
    % Calculate the index for each frequency combination and store them in
    % each array combination (f1+f2, 2f1+f2 etc)
    combinedIndex = [];
        
    counter = 0;
    for j=freqList
        % take the no group f1,f2 etc
        noGroupTemp = eval(sprintf('%s%d','noGrpFreq',j));
        noGroupTempSub = eval(sprintf('%s%d%s','noGrpFreq',j,'_sub'));
        for k=freqList
            if k == j
                
            else
                groupTemp = eval(sprintf('%s%d%s%d','grpFreq',j,'_',k));
                groupTempSub = eval(sprintf('%s%d%s%d%s','grpFreq',j,'_',k,'_sub'));
                counter = counter+1;
                for i=1:4
                    for m=1:256
                        % 1=f1+f2 2=f1+2f2 3=2f1+f2 4=2f1+2f2
                        groupDiff = (groupTemp(m,i+4)-noGroupTemp(m,i+4));
                        groupSum = (groupTemp(m,i+4)+noGroupTemp(m,i+4));
                        combinedIndex(m,i,counter) = groupDiff/groupSum;
                        
                        % Make new index value for ANOVA
                        groupIndex(m,i,counter) = groupTemp(m,i+4)/groupSum;
                        nogroupIndex(m,i,counter) = noGroupTemp(m,i+4)/groupSum;
                        
                        % Make index for the probed and matched primary and
                        % secondary harmonics
                        groupDiffInd = groupTemp(m,i)-noGroupTemp(m,i);
                        groupSumInd = groupTemp(m,i)+noGroupTemp(m,i);
                        combinedIndexInd(m,i,counter) = groupDiffInd/groupSumInd;
                        
                        % 1=f1-f2 2=f1-2f2 3=2f1-f2 4=2f1-2f2
                        groupDiffSub = (groupTempSub(m,i)-noGroupTempSub(m,i));
                        groupSumSub = (groupTempSub(m,i)+noGroupTempSub(m,i));
                        combinedIndexSub(m,i,counter) = groupDiffSub/groupSumSub;
                        
                    end
                end
            end
        end
    end
    
    % Collapse across the different frequencies
    combinedIndexMean(:,:,a) = mean(combinedIndex,3);
    
    combGroupIndex(:,:,a) = mean(groupIndex,3);
    combNogroupIndex(:,:,a) = mean(nogroupIndex,3);
    
    combinedIndexIndMean(:,:,a) = mean(combinedIndexInd,3);
    
    combinedIndexSubMean(:,:,a) = mean(combinedIndexSub,3);
    
    for i = 1:length(channels)
        
        % Go through and pick off the specific electrodes corresponding to
        % each electrode group then average across the group
        % O1,O2,P1,P2,C1,C2
        for j=1:length(eval(channels{i}))
            temp = eval(channels{i});
            electrodeMean(j,:,a) = combinedIndexMean(temp(j),:,a);
        end
        eval(sprintf('%s%s%s',channels{i},'Mean(:,:,a)','= mean(electrodeMean(:,:,a),1)'));
        
    end
    
    
    % Plot each figure
    figure()
    set(gcf,'numbertitle','off','name',usableParticipants{a}) % See the help for GCF
    
    subplot(2,4,1)
    bar(combinedIndexMean(:,1,a))
    title(freqCombos{1});
    
    subplot(2,4,2)
    bar(combinedIndexMean(:,2,a))
    title(freqCombos{2});
    
    subplot(2,4,5)
    bar(combinedIndexMean(:,3,a))
    title(freqCombos{3});
    
    subplot(2,4,6)
    bar(combinedIndexMean(:,4,a))
    title(freqCombos{4});
    
%     subplot(2,8,3)
%     bar([O1Mean(1,1,a),O2Mean(1,1,a),P1Mean(1,1,a),P2Mean(1,1,a),C1Mean(1,1,a),C2Mean(1,1,a)])
%     title(freqCombos{1});
%     set(gca,'XTickLabel',channels)
%     
%     subplot(2,8,4)
%     bar([O1Mean(1,2,a),O2Mean(1,2,a),P1Mean(1,2,a),P2Mean(1,2,a),C1Mean(1,2,a),C2Mean(1,2,a)])
%     title(freqCombos{2});
%     set(gca,'XTickLabel',channels)
%     
%     subplot(2,8,11)
%     bar([O1Mean(1,3,a),O2Mean(1,1,a),P1Mean(1,3,a),P2Mean(1,3,a),C1Mean(1,3,a),C2Mean(1,3,a)])
%     title(freqCombos{3});
%     set(gca,'XTickLabel',channels)
%     
%     subplot(2,8,12)
%     bar([O1Mean(1,4,a),O2Mean(1,1,a),P1Mean(1,4,a),P2Mean(1,4,a),C1Mean(1,4,a),C2Mean(1,4,a)])
%     title(freqCombos{4});
%     set(gca,'XTickLabel',channels)
    
    subplot(2,4,3)
    bar(combinedIndexIndMean(:,1,a))
    title(freqCombosInd{1});
    
    subplot(2,4,4)
    bar(combinedIndexIndMean(:,2,a))
    title(freqCombosInd{2});
    
    subplot(2,4,7)
    bar(combinedIndexIndMean(:,3,a))
    title(freqCombosInd{3});
    
    subplot(2,4,8)
    bar(combinedIndexIndMean(:,4,a))
    title(freqCombosInd{4});
%     
%     subplot(2,8,7)
%     bar(combinedIndexSubMean(:,1,a))
%     title(freqCombosSub{1});
%     
%     subplot(2,8,8)
%     bar(combinedIndexSubMean(:,2,a))
%     title(freqCombosSub{2});
%     
%     subplot(2,8,15)
%     bar(combinedIndexSubMean(:,3,a))
%     title(freqCombosSub{3});
%     
%     subplot(2,8,16)
%     bar(combinedIndexSubMean(:,4,a))
%     title(freqCombosSub{4});
    
end

% Average across participants
finalIndex = mean(combinedIndexMean,3);
finalIndexSTE = std(combinedIndexMean,0,3)/sqrt(size(combinedIndexMean,3)-1);

finalGroupIndex = mean(combGroupIndex,3);
finalNogroupIndex = mean(combNogroupIndex,3);

% Average accross part for matched and probed prim and secondary harmonics
finalIndexInd = mean(combinedIndexIndMean,3);
finalIndexIndSTE = ste(combinedIndexIndMean,3);

finalIndexSub = mean(combinedIndexSubMean,3);
finalIndexSubSTE = ste(combinedIndexSubMean,3);

O1Final = mean(O1Mean,3);
O2Final = mean(O2Mean,3);
O1FinalSTE = std(O1Mean,0,3)/sqrt(size(O1Mean,3)-1);
O2FinalSTE = std(O2Mean,0,3)/sqrt(size(O2Mean,3)-1);

P1Final = mean(P1Mean,3);
P2Final = mean(P2Mean,3);
P1FinalSTE = std(P1Mean,0,3)/sqrt(size(P1Mean,3)-1);
P2FinalSTE = std(P2Mean,0,3)/sqrt(size(P2Mean,3)-1);

C1Final = mean(C1Mean,3);
C2Final = mean(C2Mean,3);
C1FinalSTE = std(C1Mean,0,3)/sqrt(size(C1Mean,3)-1);
C2FinalSTE = std(C2Mean,0,3)/sqrt(size(C2Mean,3)-1);

figure()
set(gcf,'numbertitle','off','name','Mean') % See the help for GCF

% Plots for additive freqs
subplot(2,4,1)
bar(finalIndex(:,1))
hold on
errorbar(finalIndex(:,1),finalIndexSTE(:,1),'k.')
title(freqCombos{1});

subplot(2,4,2)
bar(finalIndex(:,2))
hold on
errorbar(finalIndex(:,2),finalIndexSTE(:,2),'k.')
title(freqCombos{2});

subplot(2,4,5)
bar(finalIndex(:,3))
hold on
errorbar(finalIndex(:,3),finalIndexSTE(:,3),'k.')
title(freqCombos{3});

subplot(2,4,6)
bar(finalIndex(:,4))
hold on
errorbar(finalIndex(:,4),finalIndexSTE(:,4),'k.')
title(freqCombos{4});

% % Plots for electrode groups for additive freqs
% subplot(2,8,3)
% bar([O1Final(1,1),O2Final(1,1),P1Final(1,1),P2Final(1,1),C1Final(1,1),C2Final(1,1)])
% hold on
% errorbar([O1Final(1,1),O2Final(1,1),P1Final(1,1),P2Final(1,1),C1Final(1,1),C2Final(1,1)],...
%     [O1FinalSTE(1,1),O2FinalSTE(1,1),P1FinalSTE(1,1),P2FinalSTE(1,1),C1FinalSTE(1,1),C2FinalSTE(1,1)],'k.')
% title(freqCombos{1});
% set(gca,'XTickLabel',channels)
% 
% subplot(2,8,4)
% bar([O1Final(1,2),O2Final(1,2),P1Final(1,2),P2Final(1,2),C1Final(1,2),C2Final(1,2)])
% hold on
% errorbar([O1Final(1,2),O2Final(1,2),P1Final(1,2),P2Final(1,2),C1Final(1,2),C2Final(1,2)],...
%     [O1FinalSTE(1,2),O2FinalSTE(1,2),P1FinalSTE(1,2),P2FinalSTE(1,2),C1FinalSTE(1,2),C2FinalSTE(1,2)],'k.')
% title(freqCombos{2});
% set(gca,'XTickLabel',channels)
% 
% subplot(2,8,11)
% bar([O1Final(1,3),O2Final(1,3),P1Final(1,3),P2Final(1,3),C1Final(1,3),C2Final(1,3)])
% hold on
% errorbar([O1Final(1,3),O2Final(1,3),P1Final(1,3),P2Final(1,3),C1Final(1,3),C2Final(1,3)],...
%     [O1FinalSTE(1,3),O2FinalSTE(1,3),P1FinalSTE(1,3),P2FinalSTE(1,3),C1FinalSTE(1,3),C2FinalSTE(1,3)],'k.')
% title(freqCombos{3});
% set(gca,'XTickLabel',channels)
% 
% subplot(2,8,12)
% bar([O1Final(1,4),O2Final(1,4),P1Final(1,4),P2Final(1,4),C1Final(1,4),C2Final(1,4)])
% hold on
% errorbar([O1Final(1,4),O2Final(1,4),P1Final(1,4),P2Final(1,4),C1Final(1,4),C2Final(1,4)],...
%     [O1FinalSTE(1,4),O2FinalSTE(1,4),P1FinalSTE(1,4),P2FinalSTE(1,4),C1FinalSTE(1,4),C2FinalSTE(1,4)],'k.')
% title(freqCombos{4});
% set(gca,'XTickLabel',channels)

% Plots for individual frequency harmonics
subplot(2,4,3)
bar(finalIndexInd(:,1))
hold on
errorbar(finalIndexInd(:,1),finalIndexIndSTE(:,1),'k.')
title(freqCombosInd{1});

subplot(2,4,4)
bar(finalIndexInd(:,2))
hold on
errorbar(finalIndexInd(:,2),finalIndexIndSTE(:,2),'k.')
title(freqCombosInd{2});

subplot(2,4,7)
bar(finalIndexInd(:,3))
hold on
errorbar(finalIndexInd(:,3),finalIndexIndSTE(:,3),'k.')
title(freqCombosInd{3});

subplot(2,4,8)
bar(finalIndexInd(:,4))
hold on
errorbar(finalIndexInd(:,4),finalIndexIndSTE(:,4),'k.')
title(freqCombosInd{4});

% % Plots for subtractive freqs
% subplot(2,8,7)
% bar(finalIndexSub(:,1))
% hold on
% errorbar(finalIndexSub(:,1),finalIndexSubSTE(:,1),'k.')
% title(freqCombosSub{1});
% 
% subplot(2,8,8)
% bar(finalIndexSub(:,2))
% hold on
% errorbar(finalIndexSub(:,2),finalIndexSubSTE(:,2),'k.')
% title(freqCombosSub{2});
% 
% subplot(2,8,15)
% bar(finalIndexSub(:,3))
% hold on
% errorbar(finalIndexSub(:,3),finalIndexSubSTE(:,3),'k.')
% title(freqCombosSub{3});
% 
% subplot(2,8,16)
% bar(finalIndexSub(:,4))
% hold on
% errorbar(finalIndexSub(:,4),finalIndexSubSTE(:,4),'k.')
% title(freqCombosSub{4});

% Calculate the p-vals across participants for each freq combo for each electrode
% Use the values at each electrode at each freq combo for all subjects to
% calculate the pval and tstat
alphaVals = [.001 .01 .05 .1];
for z=1:length(alphaVals)
    for i=1:size(combinedIndexMean,1)
        for j=1:size(combinedIndexMean,2)
            [S(i,j,z), P(i,j,z), CI(:,i,j,z), T(i,j,z)] = ttest(combinedIndexMean(i,j,:),0,alphaVals(z));
            [SInd(i,j,z), PInd(i,j,z), CIInd(:,i,j,z), TInd(i,j,z)] = ttest(combinedIndexIndMean(i,j,:),0,alphaVals(z));
            [SSub(i,j,z), PSub(i,j,z), CISub(:,i,j,z), TSub(i,j,z)] = ttest(combinedIndexSubMean(i,j,:),0,alphaVals(z));
        end
    end
end

% Calculate the tstat that corresp with pval of .05
alphaTStat = abs(tinv(.05/2,size(combinedIndexMean,3)-1));
% Make a thresholded array at t corresponding to p=.05 for brainstorm
for z=1:size(T,3)
    for i=1:size(T,2)
        for j=1:size(T,1)
            if T(j,i,z).tstat >= alphaTStat || T(j,i,z).tstat <= alphaTStat
                TArrayThreshold(j,i,z) = T(j,i,z).tstat;
                TArrayIndThreshold(j,i,z) = TInd(j,i,z).tstat;
                TArraySubThreshold(j,i,z) = TSub(j,i,z).tstat;
            else
                TArrayThreshold(j,i,z) = 0;
                TArrayIndThreshold(j,i,z) = 0;
                TArraySubThreshold(j,i,z) = 0;
            end
        end
    end
end

% Make an array out of the cell array for the t-stat for use in brainstorm
for z=1:size(T,3)
    for i=1:size(T,2)
        for j=1:size(T,1)
            TArray(j,i,z) = T(j,i,z).tstat;
            TArrayInd(j,i,z) = TInd(j,i,z).tstat;
            TArraySub(j,i,z) = TSub(j,i,z).tstat;
        end
    end
end

tvalAverageInd = TArrayInd(:,:,1);
tvalAverageIndThreshold = TArrayIndThreshold(:,:,1);
tvalAverage = TArray(:,:,1);
tvalAverageThreshold = TArrayThreshold(:,:,1);
pvalAverage = P(:,:,1);
svalAverage001 = S(:,:,1);
svalAverage01 = S(:,:,2);
svalAverage05 = S(:,:,3);
svalAverage1 = S(:,:,4);

% Save the pvals for use in brainstorm
save(sprintf('%s%s',inputFile,'/finalIndexBS'),'finalIndex');
save(sprintf('%s%s',inputFile,'/finalIndexInd'),'finalIndexInd');
save(sprintf('%s%s',inputFile,'/pvalAverage'),'pvalAverage');
save(sprintf('%s%s',inputFile,'/tvalAverage'),'tvalAverage');
save(sprintf('%s%s',inputFile,'/tvalAverageThreshold'),'tvalAverageThreshold');
save(sprintf('%s%s',inputFile,'/svalAverage001'),'svalAverage001');
save(sprintf('%s%s',inputFile,'/svalAverage01'),'svalAverage01');
save(sprintf('%s%s',inputFile,'/svalAverage05'),'svalAverage05');
save(sprintf('%s%s',inputFile,'/svalAverage1'),'svalAverage1');
save(sprintf('%s%s',inputFile,'/tvalAverageInd'),'tvalAverageInd');
save(sprintf('%s%s',inputFile,'/tvalAverageIndThreshold'),'tvalAverageIndThreshold');


save(sprintf('%s%s',inputFile,'/finalIndex'),'finalIndex','combinedIndexMean','usableParticipants',...
    'O1Final','O2Final','P1Final','P2Final','C1Final','C2Final',...
    'O1Mean','O2Mean','P1Mean','P2Mean','C1Mean','C2Mean','finalGroupIndex','finalNogroupIndex','combGroupIndex','combNogroupIndex',...
    'finalIndexInd','combinedIndexIndMean','finalIndexSub','combinedIndexSubMean')

% Save the average index array for use in brainstorm
save(sprintf('%s%s',inputFile,'/indexAverage'),'finalIndex')


% Will seperate out the variables to save in individual files for use in
% brainstorm
for i=1:length(usableParticipants)

    eval(sprintf('%s%s%s%s','index',usableParticipants{i}, '= combinedIndexMean(:,:,i)'));
    save(sprintf('%s%s%s%s',inputFile,usableParticipants{i},'/index',usableParticipants{i}),sprintf('%s%s','index',usableParticipants{i}));

end






