% This program plots correlations for the calculated index for the
% behavioral value vs the index for the neural data

close all
clear all

inputFile = '/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Color/Data/';

% Load in the usable participants list
load(sprintf('%s%s%s',inputFile,'/usableParticipants'));

% Load in the behavioral index values
load(sprintf('%s%s',inputFile,'behavioralIndex'));

% Load in the neural index values
load(sprintf('%s%s',inputFile,'/finalIndex'));

% Array for Frequency number
freqList = [3 5 12 20];

% Which electrode groups you want to average together
O1 = 124;
O2 = 149;

P1 = 100;
P2 = 129;

C1 = 45;
C2 = 132;

channels = {'O1','O2','P1','P2','C1','C2'};

freqCombos = {'f1+f2','f1+2f2','2f1+f2','2f1+2f2'};

% Calculate and plot the correlations for each array region
counter = 0;
figure()
for j=1:length(freqList)
    for i=1:length(channels)
        counter=counter+1;
        subplot(length(freqList),length(channels),counter)
        hold on
        for k=1:length(usableParticipants)
            
            % Make a matix that holds the values of accuracy and neural
            % data for each correlation
            corrBehavioral(counter,k) = AccIndex(k);
            corrNeural(counter,k) = eval(sprintf('%s%s',eval('channels{i}'),'Mean(1,j,k)'));
            
            
        end
        
        % Calculate the R val for each correlation
        clusterRVal{counter} = corrcoef(corrBehavioral(counter,:), corrNeural(counter,:));
        
        % Plot the values in both arrays
        plot(corrBehavioral(counter,:), corrNeural(counter,:),'ko')
        lsline
        
        title(sprintf('%s%s',freqCombos{j},' for ',channels{i}));
        xlabel('Behavioral');
        ylabel('Neural');
        hold off
    end
end


% Calculate and plot the correlations for the average across all electrodes

% Averge the index accross all electrodes
aveElectrode = mean(combinedIndexMean,1);

figure()
set(gcf,'numbertitle','off','name','Behavioral Index vs Neural (All Electrodes)') % See the help for GCF
for i=1:length(freqList)
    
    subplot(2,2,i)
    
    for j=1:size(aveElectrode,3)
        holderElectrode(i,j) = aveElectrode(1,i,j);
    end
    
    aveRValCell{i} = corrcoef(AccIndex(1,:),holderElectrode(i,:));
    aveRVal(i) = aveRValCell{i}(2);
    
    %     p = polyfit(AccIndex(1,:),holderElectrode(i,:),1);
    %     f = polyval(p,AccIndex(1,:));
    plot(AccIndex(1,:),holderElectrode(i,:),'ko');
    %     hold on
    %     plot(AccIndex(1,:),f,'--r');
    lsline
    
    title(freqCombos{i});
    xlabel('Behavioral');
    ylabel('Neural');
    
end


% Calculate the correlation using the average Accuracy values instead of
% accuracy indices
% Correlate against grouped acc
figure()
set(gcf,'numbertitle','off','name','Grouped Acc vs Neural') % See the help for GCF
for i=1:length(freqList)
    
    subplot(2,2,i)
    
    for j=1:size(aveElectrode,3)
        holderElectrode(i,j) = aveElectrode(1,i,j);
    end
    
    groupedKValCell{i} = corrcoef(group(:,1),holderElectrode(i,:));
    groupedKVal(i) = groupedKValCell{i}(2);
    
    plot(group(:,1),holderElectrode(i,:),'ko');
    lsline
    
    title(freqCombos{i});
    xlabel('Behavioral');
    ylabel('Neural');
    
end
% Correlate against no grouped acc
figure()
set(gcf,'numbertitle','off','name','Not Grouped Acc vs Neural') % See the help for GCF
for i=1:length(freqList)
    
    subplot(2,2,i)
    
    for j=1:size(aveElectrode,3)
        holderElectrode(i,j) = aveElectrode(1,i,j);
    end
    
    nogroupedKValCell{i} = corrcoef(group(:,3),holderElectrode(i,:));
    nogroupedKVal(i) = nogroupedKValCell{i}(2);
    
    plot(group(:,3),holderElectrode(i,:),'ko');
    lsline
    
    title(freqCombos{i});
    xlabel('Behavioral');
    ylabel('Neural');
    
end











