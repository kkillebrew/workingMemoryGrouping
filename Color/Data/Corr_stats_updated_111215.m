% This program calculates the correlations between the neural and
% behavioral indices for each subject for each electrode and plots them. It
% then runs paired samlple t-tests for each electrode and plots the t-stats
% ranked by p val as a bar graph. 

close all
clear all

inputFile = '/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Color/Data/';

% Load in the usable participants list
load(sprintf('%s%s%s',inputFile,'/usableParticipants'));

% Load in the behavioral index values
load(sprintf('%s%s',inputFile,'behavioralIndex'));

% Load in the neural index values
load(sprintf('%s%s',inputFile,'/finalIndex_1000it_noTrialsLess5'));

% Array for Frequency number
freqList = [3 5 12 20];

freqCombos = {'1f1+1f2','1f1+2f2','2f1+1f2','2f1+2f2'};

for i=1:size(indexValuesFreqAve,1)
    for j=1:size(indexValuesFreqAve,2)
        
        % Calculate the correlations for each electrode across all participants
        [RValCell{i,j}, PValCell{i,j}] = corrcoef(AccIndex(1,[1:10,12:20]),indexValuesFreqAve(i,j,[1:10,12:20]));
        RVal(i,j) = RValCell{i,j}(2);
        PVal(i,j) = PValCell{i,j}(2);
        
        % Run a paired samples ttest on the correlations
        % Formula for tstat using r val:
        % t = r / ([(1-r^2) / (N-2)])
        TVal(i,j) = RVal(i,j) / sqrt((1-RVal(i,j)^2)/(size(indexValuesFreqAve,3)-2));
    end
    
    % Sort the r vals in order of significance
    [pSorted(i,:), pOrder(i,:)] = sort(PVal(i,:),2,'ascend');
    rSorted(i,:) = RVal(i,pOrder(i,:));
    
end

% Calculate the value at p of .05


% % Plot the correlation
% for i=1:4
%     figure()
%     set(gcf,'numbertitle','off','name',freqCombos{i}) % See the help for GCF
%     for j=1:size(indexValuesFreqAve,2)-1
%         subplot(16,16,j)
%         plot(AccIndex(1,[1:10,12:20]),squeeze(indexValuesFreqAve(i,j,[1:10,12:20])),'ko')
%         lsline
%         
%         hold on
%     end
%     [ax1,h1] = suplabel(freqCombos{i},'t');
%     [ax2,h2] = suplabel('Behavioral','x');
%     [ax3,h3] = suplabel('Neural','y');
%     set(h1,'FontSize',30)
%     set(h2,'FontSize',30)
%     set(h3,'FontSize',30)
% end

% Plot the sorted RVals
for i=1:4
    figure()
    set(gcf,'numbertitle','off','name',freqCombos{i}) % See the help for GCF
    
    bar(rSorted(i,:))
    hold on
    plot(1:257,.445,'r-')
    title(freqCombos{i},'FontSize',15,'FontWeight','bold');
    xlabel('Electrodes','FontSize',15);
    ylabel('R Value','FontSize',15);

end

% Save an array to use with the topo maps
save(sprintf('%s',inputFile,'/RVal'),'RVal');












