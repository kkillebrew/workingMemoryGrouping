% This program plots correlations for the calculated index for the
% behavioral value vs the neural index

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

% Calculate and plot the correlations for the average across all electrodes

% Averge the index accross all electrodes
aveElectrode = squeeze(nanmean(indexValuesFreqAve(:,:,[1:10,12:20]),2));

figure()
set(gcf,'numbertitle','off','name','Behavioral Index vs Neural Index (All Electrodes)') % See the help for GCF
for i=1:length(freqList)
    
    subplot(2,2,i)
    
    aveRValCell{i} = corrcoef(AccIndex(1,[1:10,12:20]),aveElectrode(i,:));
    aveRVal(i) = aveRValCell{i}(2);
    
    %     p = polyfit(AccIndex(1,:),holderElectrode(i,:),1);
    %     f = polyval(p,AccIndex(1,:));
    plot(AccIndex(1,[1:10,12:20]),aveElectrode(i,:),'ko');
    %     hold on
    %     plot(AccIndex(1,:),f,'--r');
    lsline
    
    title(freqCombos{i},'FontSize',15,'FontWeight','bold');
    xlabel('Behavioral','FontSize',15);
    ylabel('Neural','FontSize',15);
end












