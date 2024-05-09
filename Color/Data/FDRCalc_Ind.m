close all 
clear all

inputFile = '/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Color/Data/';

load(sprintf('%s%s',inputFile,'finalIndex.mat'))
load(sprintf('%s%s',inputFile,'tvalAverageInd.mat'))

% Initially set the actual difference value to be high
differenceActual(1:4) = 100;

for i=1:size(combinedIndexIndMean,2)
    
    % Create a range of threshold values
    threshold = .001:.001:.1;
    
    % Loop through a range of threshold values to find the one that is
    % closest to a FDR of .1 (threshold at which the ratio of expected FA's
    % to number of significant electrods is .1)
    for j=1:length(threshold)
        
        for z=1:size(combinedIndexIndMean,1)
            % Calculate the tval that corresponds to the threshold that is set
            [S, P(z,i,j), CI, T{z,i,j}] = ttest(combinedIndexIndMean(z,i,:),0,threshold(j));
        end
        
        numSig(i,j) = 0;
        % Calculate the number of sig elecs 
        for z=1:size(P,1)
            % if the the value is below the tstat corresponding to the
            % threshold, then count up
            if P(z,i) < threshold(j)
                numSig(i,j) = numSig(i,j) + 1;
            end
        end
        
        % Calculate the expected number of false positives due to chance at the
        % threshold given
        expectedFA(i,j) = threshold(j)*size(combinedIndexIndMean,1);
        
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
    thresholdTStat(i) = abs(tinv((closestThreshP(i)/2),size(combinedIndexIndMean,3)-1));
end

% Calculate the tstat that corresp with pval of .05
alphaTStat = abs(tinv(.05/2,size(combinedIndexIndMean,3)-1));

% % Plot the abs vals with neg vals being red and pos vals being blue
% 
% % Place the tstats into standard arrays to plot
% for j=1:size(T,2)
%     for i=1:size(T,1)
%         % Determine which tstats are positive and negative and place them in
%         % seperate arrays
%         if T{i,j,thresholdIdx(j)}.tstat >= 0
%             tstatArray(i,j) = T{i,j,thresholdIdx(j)}.tstat;
%             tstatIdx(i,j) = 1;
%         elseif T{i,j,thresholdIdx(j)}.tstat < 0
%             tstatArray(i,j) = abs(T{i,j,thresholdIdx(j)}.tstat);
%             tstatIdx(i,j) = 2;
%         end
%     end
% end
% 
% for i=1:size(tstatArray,2)
%     
%     % Sort the array and the corresponding tstatIdx array from largest to
%     % smallest
%     [pSorted, pOrder] = sort(P(:,i),1,'ascend');
%     tstatSorted = tstatArray(pOrder,i);
%     tstatIdxSorted = tstatIdx(pOrder,i);
%     
%     figure(i)
%     hold on
% 
%     for j=1:size(tstatArray,1)
%         % Plot the tstats from highest to lowest
%         if tstatIdxSorted(j) == 1
%             bar([j],tstatSorted(j),'grouped','FaceColor','b','EdgeColor','none');
%         elseif tstatIdxSorted(j) == 2
%             bar([j],tstatSorted(j),'grouped','FaceColor','r','EdgeColor','none');
%         end
%         
%     end
%     
%     % Plot the value that corresponds to an FDR of .1 and an alhpa of .05
%     line([1,257],[thresholdTStat(i),thresholdTStat(i)],'Color',[0 1 0])
%     line([1,257],[alphaTStat,alphaTStat],'Color',[0 1 1])
%     
% end


% Plot the pos and neg values

% Place the tstats into standard arrays to plot
for j=1:size(T,2)
    for i=1:size(T,1)
        % Determine which tstats are positive and negative and place them in
        % seperate arrays
        if T{i,j,thresholdIdx(j)}.tstat >= 0
            tstatArray(i,j) = T{i,j,thresholdIdx(j)}.tstat;
            pArray(i,j) = P(i,j,thresholdIdx(j));
            tstatIdx(i,j) = 1;
        elseif T{i,j,thresholdIdx(j)}.tstat < 0
            tstatArray(i,j) = T{i,j,thresholdIdx(j)}.tstat;
            pArray(i,j) = P(i,j,thresholdIdx(j));
            tstatIdx(i,j) = 2;
        end
    end
end

for i=1:size(tstatArray,2)
    
    % Sort the array and the corresponding tstatIdx array from largest to
    % smallest
    [pSorted, pOrder] = sort(P(:,i),1,'ascend');
    tstatSorted = tstatArray(pOrder,i);
    
    figure(i+1)
    hold on
    
    for j=1:size(tstatArray,1)
        % Plot the tstats from highest to lowest
        bar([j],tstatSorted(j),'EdgeColor','none','BarWidth', 1);
        set(gca,'XLim',[0 257])
        set(gca,'YLim',[0 15])
    end
    
    % Plot the value that corresponds to an FDR of .1 and an alhpa of .05
    line([1,257],[thresholdTStat(i),thresholdTStat(i)],'Color',[0 1 0])
    line([1,257],[alphaTStat,alphaTStat],'Color',[0 1 1])
    
end












