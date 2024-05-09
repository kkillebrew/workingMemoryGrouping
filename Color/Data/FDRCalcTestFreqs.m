% close all 
clear all

inputFile = '/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Color/Data/';

load(sprintf('%s%s',inputFile,'finalIndex_1000it_noTrialsLess5.mat'))
% load(sprintf('%s%s',inputFile,'FakeData/tvalAverage_fakeData.mat'))

% Initially set the actual difference value to be high
differenceActual(1:size(indexValuesFreqAve,1)) = 100;
% Create a range of threshold values
threshold = .001:.001:.1;

numSig = zeros(size(indexValuesFreqAve,1),length(threshold));

% loop through for every frequency
for i=1:size(indexValuesFreqAve,1)

    % Loop through a range of threshold values to find the one that is
    % closest to a FDR of .1 (threshold at which the ratio of expected FA's
    % to number of significant electrodes is .1)
    for j=1:length(threshold)
        
        % loop through for all the electrodes
        for z=1:size(indexValuesFreqAve,2)
            % Calculate the tval that corresponds to the threshold that is set
            [S, P(i,z,j), CI, T{i,z,j}] = ttest(indexValuesFreqAve(i,z,:),0,threshold(j));
            
            % How many electrodes are sig for each frequency at each
            % threshold
            % If the the pval is less than the threshold count up
            if P(i,z,j) < threshold(j)
                numSig(i,j) = numSig(i,j) + 1;
            end
        end
        
        % Calculate the expected number of false positives due to chance at the
        % threshold given
        expectedFA(i,j) = threshold(j)*size(indexValuesFreqAve,2);
        
        % Calculate the FDR for the threshold chosen
        FDR(i,j) = expectedFA(i,j)/numSig(i,j);
        
        % Is the FDR for this threshold the closest to .1?
        differenceHolder = abs(FDR(i,j) - .1);
        if differenceHolder < differenceActual(i)
            differenceActual(i) = differenceHolder;
            closestThresh(i) = FDR(i,j);     
            closestThreshP(i) = threshold(j);
            thresholdIdx(i) = j;            
        end
    end 
end

% Calculate the tstat that corresponds with the pval
for i=1:length(closestThreshP)
    thresholdTStat(i) = abs(tinv((closestThreshP(i)/2),size(indexValuesFreqAve,3)-1));
end

% Calculate the tstat that corresp with pval of .05
alphaTStat = abs(tinv(.05/2,size(indexValuesFreqAve,3)-1));

% Plot the pos and neg values
% Place the tstats into standard arrays to plot
% loop through for all frequencies
for j=1:size(T,1)
    % loop through for all electrodes
    for i=1:size(T,2)
        % Determine which tstats are positive and negative and place them in
        % seperate arrays
        if T{j,i,thresholdIdx(j)}.tstat >= 0
            tstatArray(j,i) = T{j,i,thresholdIdx(j)}.tstat;
            pArray(j,i) = P(j,i,thresholdIdx(j));
            tstatIdx(j,i) = 1;
        elseif T{j,i,thresholdIdx(j)}.tstat < 0
            tstatArray(j,i) = T{j,i,thresholdIdx(j)}.tstat;
            pArray(j,i) = P(j,i,thresholdIdx(j));
            tstatIdx(j,i) = 2;
        end
    end
end

% % choosenFreq = [3 5 12 20];
% freqComb = {'1f1+1f2','1f1+2f2','2f1+1f2','2f1+2f2'};
% testList = {'-2','-1','+1','+2','+3'};
% counter = 0;
% for k=1:size(tstatArray,1)/4
%     figure(k)
% %     set(gcf,'units','normalized','position',[0 0 1 1]);
%     for i=1:4
%         
%         % Sort the array and the corresponding tstatIdx array from largest to
%         % smallest
%         [pSorted, pOrder] = sort(pArray(i+counter,:),1,'ascend');
%         tstatSorted = tstatArray(i+counter,pOrder);
%         
%         subplot(2,2,i)
%         hold on
%         
%         for j=1:size(tstatArray,2)
%             % Plot the tstats from highest to lowest
%             bar([j],tstatSorted(j),'EdgeColor','none','BarWidth', 1);
%             set(gca,'XLim',[0 257])
%             set(gca,'YLim',[0 15])
%         end
%         
% %         title(freqComb{i});
%         title(testList{i});
%         
%         % Plot the value that corresponds to an FDR of .1 and an alhpa of .05
%         line([1,257],[thresholdTStat(i+counter),thresholdTStat(i+counter)],'Color',[0 1 0])
%         line([1,257],[alphaTStat,alphaTStat],'Color',[1 0 0])
%         
%     end
%     counter = counter+4;
% %     savefig(sprintf('%s',inputFile,'TestFigs/FDR_fakeData.fig'));
% end

testList = {'1f1+1f2','1f1+2f2','2f1+1f2','2f1+2f2'; '1f1','2f1','1f2','2f2'; '7','9','10','12'};
counter = 0;
numSigElec = zeros(3,4);
for i=1:size(tstatArray,1)/4
    figure()
    for j=1:4
        % Sort the array and the corresponding tstatIdx array from largest to
        % smallest
        [pSorted, pOrder] = sort(pArray(j+counter,:),2,'ascend');
        tstatSorted = tstatArray(j+counter,pOrder);
        
        % Count the number of significant electrodes
        for k=1:length(tstatSorted)
            if abs(tstatSorted(1,k)) > alphaTStat
                numSigElec(i,j) = numSigElec(i,j)+1;
            end
        end
        
        subplot(2,2,j)
        
        bar(tstatSorted(:))
        set(gca,'XLim',[0 257])
        set(gca,'YLim',[-3 3])      
        title(testList{i,j});
        xlabel('Electrode (Ordered by significance)')
        ylabel('T-Stats')
        
        hold on
        
        % Plot the value that corresponds to an FDR of .1 and an alhpa of .05
%         line([1,257],[thresholdTStat(j+counter),thresholdTStat(j+counter)],'Color',[0 1 0])
        line([1,257],[alphaTStat,alphaTStat],'Color',[1 0 0])
        
%         line([1,257],[-thresholdTStat(j+counter),-thresholdTStat(j+counter)],'Color',[0 1 0])
        line([1,257],[-alphaTStat,-alphaTStat],'Color',[1 0 0])
        
    end
   counter = counter+4;
end

% save(sprintf('%s',inputFile,'finalIndex_TStat_1000it_noTrialsLess5.mat'),'thresholdTStat','thresholdIdx','tstatArray','pArray')





