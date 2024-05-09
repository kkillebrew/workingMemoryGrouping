close all
clear all

inputFile = '/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Color/Data/';

freqCombs = {'1f1+1f1','2f1+1f2','1f1+2f2','2f1+2f2','1f1','2f1','1f2','2f2','7', '9', '10', '12'};
figNameInd = {'Target Additivie Frequencies (Index)','Target Individual Frequencies (Index)','Control Frequencies (Index)'};
figNameTStat = {'Target Additivie Frequencies (TStat)','Target Individual Frequencies (TStat)','Control Frequencies (TStat)'};
numIterations = 10000;
threshold = .05;

for i=1:length(numIterations)
    clear indexValuesFreqAve indexValuesPartAve indexValuesPartSTE P T
    load(sprintf('%s%s%d%s',inputFile,'finalIndex_',numIterations(i),'it_noTrialsLess5'));
    temp1 = indexValuesPartAve;
    temp1err = indexValuesPartSTE;
    
    % Calculate the tstats and pvals
    for j=1:size(indexValuesFreqAve,1)
        for k=1:size(indexValuesFreqAve,2)
            [S(j,k), P(j,k), CI, T(j,k)] = ttest(indexValuesFreqAve(j,k,:),0,threshold);
            
            % Convert the tstats into a matrix
            tstatArray(j,k) = T(j,k).tstat;
        end
    end

    
    % Order the tstats by pvals
    [pSorted, pOrder] = sort(P,2,'ascend');
    for j=1:size(pOrder,1)
        tstatSorted(j,:) = tstatArray(j,pOrder(j,:));
    end
    alphaTStat = abs(tinv(threshold/2,size(indexValuesFreqAve,3)-1));   % TStat corresponding to p of threshold
    
    counter1 = 0;
    counter2 = 0;
    for j=1:size(indexValuesFreqAve,1)/4
        
        % Plot the index values
        figure()
        set(gcf,'numbertitle','off','name',figNameInd{j}) 
        for k=1:4
            counter1 = counter1+1;
            subplot(2,2,k)
            bar(temp1(counter1,:));
            hold on
            h=errorbar(temp1(counter1,:),temp1err(counter1,:));
            set(h,'Color','k');
            str = {'',freqCombs{counter1},''}; 
            xlabel('Electrode','FontSize',15);
            ylabel('Index','FontSize',15);
            title(str,'FontSize',15,'FontWeight','bold');
            set(gca,'ylim',[-.1,.1])
        end
        
        % Plot the tstats
        figure()
        set(gcf,'numbertitle','off','name',figNameTStat{j}) 
        for k=1:4
            counter2 = counter2+1;
            subplot(2,2,k)
            bar(tstatSorted(counter2,:));
            line([1,257],[alphaTStat,alphaTStat],'Color',[1 0 0])
            line([1,257],[-alphaTStat,-alphaTStat],'Color',[1 0 0])
            str = {'',freqCombs{counter2},''}; 
            xlabel('Electrode','FontSize',15);
            ylabel('Index','FontSize',15);
            title(str,'FontSize',15,'FontWeight','bold');
            set(gca,'ylim',[-2.5,2.5])
        end
        
    end
    
    
    
 
    
end