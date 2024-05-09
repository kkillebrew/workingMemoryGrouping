clear all
close all

% Array for Frequency number
freqList = [3 5 12 20];

inputFile = '/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Color/Data/';

% load(sprintf('%s%s',inputFile,'usableParticipants.mat'))
usableParticipants = {'001','002','003','004','005'};

choosenFreq = [3 5 12 20];

for a=1:length(usableParticipants)'
    
    % load in the freq arrays for no group and group
    for i=freqList
        for j=freqList
            if j == i
                
            else
%                         load(sprintf('%s%s%s%s%d%s%d%s',inputFile,usableParticipants{a},'/Updated/FreqValues.updated/','noGrpFreq',i,'_',j,'_updated'));
                                load(sprintf('%s%s%s%s%d%s%d',inputFile,'FakeData/',usableParticipants{a},'/FreqValues/noGrpFreq',i,'_',j));
%                 load(sprintf('%s%s%s%s%s%d%s%d',inputFile,'FakeData/',usableParticipants{a},'/FreqValues/','noGrpFreq',i,'_',j));
                %                 load(sprintf('%s%s%s%s%d%s%d',inputFile,usableParticipants{a},'/FreqValues/','noGrpFreq',i,'_',j));
                
%                                 load(sprintf('%s%s%s%s%d%s%d%s',inputFile,usableParticipants{a},'/Updated/FreqValues.updated/','grpFreq',i,'_',j,'_updated'));
                                load(sprintf('%s%s%s%s%d%s%d',inputFile,'FakeData/',usableParticipants{a},'/FreqValues/grpFreq',i,'_',j));
%                 load(sprintf('%s%s%s%s%s%d%s%d',inputFile,'FakeData/',usableParticipants{a},'/FreqValues/','grpFreq',i,'_',j));
                %                 load(sprintf('%s%s%s%s%d%s%d%s',inputFile,usableParticipants{a},'/FreqValues/','grpFreq',i,'_',j));
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
        for k=freqList
            if k == j
                
            else
                noGroupTemp = eval(sprintf('%s%d%s%d','noGrpFreq',j,'_',k));
                groupTemp = eval(sprintf('%s%d%s%d','grpFreq',j,'_',k));
                counter = counter+1;
                for i=1:size(groupTemp,2)
                    for m=1:256
                        % For each frequency 
                        % 1=f1+f2 2=f1+2f2 3=2f1+f2 4=2f1+2f2
%                         groupDiff = (groupTemp(m,i+4)-noGroupTemp(m,i+4));
%                         groupSum = (groupTemp(m,i+4)+noGroupTemp(m,i+4));
                        groupDiff = (groupTemp(m,i)-noGroupTemp(m,i));
                        groupSum = (groupTemp(m,i)+noGroupTemp(m,i));
                        combinedIndex(m,i,counter) = groupDiff/groupSum;   
                    end
                end
            end
        end
    end
    
    % Collapse across the different frequencies
    combinedIndexMean(:,:,a) = mean(combinedIndex,3);
end

% Collapse across paticipants
finalIndex = mean(combinedIndexMean,3);
finalIndexSTE = ste(combinedIndexMean,3);

counter = 0;
for i=1:size(finalIndex,2)/4
    figure(i)
    set(gcf,'units','normalized','position',[0 0 1 1]);
    subplot(2,2,1)
    bar(finalIndex(:,1+counter))
    hold on
    errorbar([finalIndex(:,1+counter)],[finalIndexSTE(:,1+counter)],'k.');
    str = {'','1f1+1f2 1/2',''}; % cell-array method
    xlabel('Electrode','FontSize',15);
    ylabel('Index','FontSize',15);
    title(str,'FontSize',15,'FontWeight','bold');
    set(gca,'ylim',[-1.2,1.2])
    
    subplot(2,2,2)
    bar(finalIndex(:,2+counter))
    hold on
    errorbar([finalIndex(:,2+counter)],[finalIndexSTE(:,2+counter)],'k.');
    str = {'','1f1+2f2 1/2',''}; % cell-array method
    xlabel('Electrode','FontSize',15);
    ylabel('Index','FontSize',15);
    title(str,'FontSize',15,'FontWeight','bold');
    set(gca,'ylim',[-1.2,1.2])
    
    subplot(2,2,3)
    bar(finalIndex(:,3+counter))
    hold on
    errorbar([finalIndex(:,3+counter)],[finalIndexSTE(:,3+counter)],'k.');
    str = {'','2f1+1f2 1/2',''}; % cell-array method
    xlabel('Electrode','FontSize',15);
    ylabel('Index','FontSize',15);
    title(str,'FontSize',15,'FontWeight','bold');
    set(gca,'ylim',[-1.2,1.2])
    
    subplot(2,2,4)
    bar(finalIndex(:,4+counter))
    hold on
    errorbar([finalIndex(:,4+counter)],[finalIndexSTE(:,4+counter)],'k.');
    str = {'','2f1+2f2 1/2',''}; % cell-array method
    xlabel('Electrode','FontSize',15);
    ylabel('Index','FontSize',15);
    title(str,'FontSize',15,'FontWeight','bold');
    set(gca,'ylim',[-1.2,1.2])
    
    counter = counter+4;
    
    savefig(sprintf('%s',inputFile,'TestFigs/fakeData_.5.fig'));
end


% Calculate the p-vals across participants for each freq combo for each electrode
% Use the values at each electrode at each freq combo for all subjects to
% calculate the pval and tstat
alphaVals = [.001 .01 .05 .1];
for z=1:length(alphaVals)
    for i=1:size(combinedIndexMean,1)
        for j=1:size(combinedIndexMean,2)
            [S(i,j,z), P(i,j,z), CI(:,i,j,z), T(i,j,z)] = ttest(combinedIndexMean(i,j,:),0,alphaVals(z));
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
            else
                TArrayThreshold(j,i,z) = 0;
            end
        end
    end
end

% Make an array out of the cell array for the t-stat for use in brainstorm
for z=1:size(T,3)
    for i=1:size(T,2)
        for j=1:size(T,1)
            TArray(j,i,z) = T(j,i,z).tstat;
        end
    end
end

tvalAverage = TArray(:,:,1);

save(sprintf('%s%s',inputFile,'/FakeData/tvalAverage_fakeData'),'tvalAverage');
% save(sprintf('%s%s',inputFile,'/FakeData/tvalAverage_fakeData'),'tvalAverage');
% save(sprintf('%s%s',inputFile,'/tvalAverage_fakeData'),'tvalAverage');
save(sprintf('%s%s',inputFile,'/FakeData/finalIndex_fakeData'),'finalIndex','combinedIndexMean','usableParticipants')
% save(sprintf('%s%s',inputFile,'/FakeData/finalIndex_fakeData'),'finalIndex','combinedIndexMean','usableParticipants')
% save(sprintf('%s%s',inputFile,'/finalIndex_fakeData'),'finalIndex','combinedIndexMean','usableParticipants')


