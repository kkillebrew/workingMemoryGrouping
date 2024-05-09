clear all
close all

% Stat parralell computing
% parpool(4);

% Shuffle random number generator
rng('shuffle')

% Would you like to see the FFT's for each subject and condition?
plotGraphs = 0;

% Set max priority
% topPriorityLevel = MaxPriority('Frequency_Output_Trashcan'); % Maximum priority level for the current operating system
% Priority(9);

load('usableParticipants.mat')
% usableParticipants = {'001', '002', '003'};

% Array for Frequency number
freqList = [3 5 12 20];

conditionList = {'grpPrb3_5','grpPrb3_12','grpPrb3_20','grpPrb5_3','grpPrb5_12','grpPrb5_20',...
    'grpPrb12_3','grpPrb12_5','grpPrb12_20','grpPrb20_3','grpPrb20_5','grpPrb20_12',...
    'noGrp3_5','noGrp3_12','noGrp3_20','noGrp5_3','noGrp5_12','noGrp5_20',...
    'noGrp12_3','noGrp12_5','noGrp12_20','noGrp20_3','noGrp20_5','noGrp20_12'};

% inputFile = '/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Color/Data/FakeData/';
inputFile = '/Volumes/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Color/Data/';

iterationNumber = 10; % INSERT ITERATION HERE

xfreq = 0:1:999;

% How long does it take to run?
tic;

numUsableTrials = zeros(length(usableParticipants),1);

for a=1:length(usableParticipants)'
    
    if plotGraphs == 1 && a == 1
        % Create the figure handles for each participants average data
        eval(sprintf('%s', 'noGrpFig_',usableParticipants{a}, ' = figure(''name'',sprintf(''%s'',''Average Not Grouped '',usableParticipants{a}),''NumberTitle'',''off'')'));
        eval(sprintf('%s', 'grpFig_',usableParticipants{a}, ' = figure(''name'',sprintf(''%s'',''Average Grouped '',usableParticipants{a}),''NumberTitle'',''off'')'));
    end
    
    % Display which participant you are on
    disp(sprintf('%s%s%s%d','Participant ', usableParticipants{a}, ' or # ', a));
    % Display the total ellapsed time
    disp(sprintf('%s%d','Time elspased: ', roundn(toc/60,-2)));
    
    counter = 0;
    condCounter = 0;
    
    % Get the wanted frequencies for each probe and for each group
    for i=freqList
        
        % Display which freq is being run
        disp(sprintf('%s%d%s','Curently running for ', i, ' Hz probed'));
        
        for j=freqList
            
            if j == i
                
            else
                clear group noGroup
                
                condCounter = condCounter+1;
                
                % Display which freq is being run
                disp(sprintf('%s%d%s','Curently running for ', j, ' Hz matched'));
                
                % Make a list of the frequencies you want to pick
                % off of the FFT
                %                 chosenFreq = [(i-2+j-2) (i-2+i-2+j-2) (i-2+j-2+j-2) (i-2+i-2+j-2+j-2)...
                %                     (i-1+j-1) (i-1+i-1+j-1) (i-1+j-1+j-1) (i-1+i-1+j-1+j-1)...
                %                     (i+j) (i+i+j) (i+j+j) (i+i+j+j)...
                %                     (i+1+j+1) (i+1+i+1+j+1) (i+1+j+1+j+1) (i+1+i+1+j+1+j+1)...
                %                     (i+2+j+2) (i+2+i+2+j+2) (i+2+j+2+j+2) (i+2+i+2+j+2+j+2)...
                %                     (i+3+j+3) (i+3+i+3+j+3) (i+3+j+3+j+3) (i+3+i+3+j+3+j+3)];
                %                 choosenFreq = [i+j i+i+j i+j+j i+i+j+j];
                chosenFreq = [i+j i+i+j i+j+j i+i+j+j i i+i j j+j 7 9 10 12];
                
                % Load in the data
                group = cell2mat(struct2cell(load(sprintf('%s%s%s%d%s%d',inputFile,usableParticipants{a},'/Include All/grpPrb',i,'_',j))));
                groupFreqLength(a,condCounter) = size(group,1);
                
                noGroup = cell2mat(struct2cell(load(sprintf('%s%s%s%d%s%d',inputFile,usableParticipants{a},'/Include All/noGrp',i,'_',j))));
                noGroupFreqLength(a,condCounter) = size(noGroup,1);
                
                if plotGraphs == 1 && a == 1
                    % Create the figure you are plotting to
                    evalc(sprintf('%s%d%s%d%s%s%s','grp_fig_',i,'_',j,'_part_',usableParticipants{a},' = figure(''name'',conditionList{counter},''NumberTitle'',''off'')'));
                end
                
                % If there are too few trials exclude that frequecy
                % combination from the group
                if size(group,1) <= 6 || size(noGroup,1) <= 6
                else
                    counter = counter+1;
                    numUsableTrials(a) = numUsableTrials(a)+1;
                    
                    for m=1:iterationNumber
                        
                        clear randNoGroup randGroup groupTemp noGroupTemp
                        
                        % Determine which list is longer
                        if noGroupFreqLength(a,condCounter) >= groupFreqLength(a,condCounter)
                            % Randomly pick a subset of the no group trials
                            randNoGroup = randperm(noGroupFreqLength(a,condCounter),groupFreqLength(a,condCounter));
                            noGroupTemp = noGroup(randNoGroup,:,:);
                            groupTemp = group;
                        elseif noGroupFreqLength(a,condCounter) < groupFreqLength(a,condCounter)
                            % Randomly pick a subset of the no group trials
                            randGroup = randperm(groupFreqLength(a,condCounter),noGroupFreqLength(a,condCounter));
                            groupTemp = group(randGroup,:,:);
                            noGroupTemp = noGroup;
                        end
                        
                        % Average all the waveforms together for both
                        % conditions
                        groupAve = squeeze(mean(groupTemp,1));
                        noGroupAve = squeeze(mean(noGroupTemp,1));
                        
                        % Take the FFT and calculate the index value
                        for k=1:size(groupAve,1)
                            % Do the fft
                            freqGroupArrayFull(:,k,m) = abs(fft(groupAve(:,k)));
                            freqNoGroupArrayFull(:,k,m) = abs(fft(noGroupAve(:,k)));
                            
                            freqGroupArrayFull(freqGroupArrayFull(:,k,m) < .000001,k,m) = 0;
                            freqNoGroupArrayFull(freqNoGroupArrayFull(:,k,m) < .000001,k,m) = 0;
                            
                            % Pick off only the specific freqs you are looking for
                            freqCounter = 0;
                            for l=chosenFreq
                                freqCounter = freqCounter+1;
                                freqNoGroupArraySpec(freqCounter,k,m) = freqNoGroupArrayFull(l+1,k,m);
                                freqGroupArraySpec(freqCounter,k,m) = freqGroupArrayFull(l+1,k,m);
                                
                                % Calculate the index
                                indexValues(freqCounter,k,m) = (freqGroupArraySpec(freqCounter,k,m)-freqNoGroupArraySpec(freqCounter,k,m))/(freqGroupArraySpec(freqCounter,k,m)+freqNoGroupArraySpec(freqCounter,k,m));
                                
                            end
                        end
                        
                        if plotGraphs == 1 && a == 1
                            figure(eval(sprintf('%s%d%s%d%s','grp_fig_',i,'_',j,'_part_',usableParticipants{a})))
                            subplot(5,2,m)
                            stem(xfreq,mean(freqGroupArrayFull(:,:,m),1))
                            set(gca,'ylim',[0,500])
                            set(gca,'xlim',[0,100])
                        end
                    end
                    
                    % Average across the iterations of the FFT
                    freqGroupArrayFullAve = mean(freqGroupArrayFull,3);
                    freqNoGroupArrayFullAve = mean(freqNoGroupArrayFull,3);
                    
                    freqGroupArraySpecAve(:,:,counter) = mean(freqGroupArraySpec,3);
                    freqNoGroupArraySpecAve(:,:,counter) = mean(freqNoGroupArraySpec,3);
                    
                    % Average the index values across iterations
                    indexValuesAve(:,:,counter) = mean(indexValues,3);
                    
                    if plotGraphs == 1 && a == 1
                        figure(eval(sprintf('%s', 'grpFig_',usableParticipants{a})))
                        subplot(6,2,counter)
                        stem(xfreq,mean(freqGroupArrayFullAve,1))
                        title(conditionList{counter});
                        set(gca,'ylim',[0,500])
                        set(gca,'xlim',[0,100])
                        
                        figure(eval(sprintf('%s', 'noGrpFig_',usableParticipants{a})))
                        subplot(6,2,counter)
                        stem(xfreq,mean(freqNoGroupArrayFullAve,1))
                        title(conditionList{counter});
                        set(gca,'ylim',[0,500])
                        set(gca,'xlim',[0,100])
                    end
                end
                %                 evalc(sprintf('%s%d%s%d','grpFreq',i,'_',j, '= mean(freqGroupArraySpecAve,3)'));
                %                 evalc(sprintf('%s%d%s%d%s','noGrpFreq',i,'_',j, '= mean(freqNoGroupArraySpecAve,3)'));
                
                %                 save(sprintf('%s%s%s%d%s%d',inputFile,usableParticipants{a},'/FreqValues/grpFreq',i,'_',j),sprintf('%s%d%s%d','grpFreq',i,'_',j));
                clear (sprintf('%s%d%s%d','grpPrb',i,'_',j));
                %                 clear (sprintf('%s%d%s%d','grpFreq',i,'_',j));
                
                %                 save(sprintf('%s%s%s%d%s%d',inputFile,usableParticipants{a},'/FreqValues/noGrpFreq',i,'_',j),sprintf('%s%d%s%d','noGrpFreq',i,'_',j));
                clear (sprintf('%s%d%s%d','noGrp',i,'_',j));
                %                 clear (sprintf('%s%d%s%d','noGrpFreq',i,'_',j));
                
                % Clear all temporary variables used in the iteration loop
                clear freqNoGroupArrayFullAve freqGroupArrayFullAve freqGroupArray freqNoGroupArray freqGroupArrayFull freqNoGroupArrayFull groupAve noGroupAve indexValues
                clear freqGroupArraySpec freqNoGroupArraySpec
            end
        end
    end
    
    % Average the index values across frequency combinations
    indexValuesFreqAve(:,:,a) = mean(indexValuesAve,3);
    
    freqGroupArrayFreqAve(:,:,a) = mean(freqGroupArraySpecAve,3);
    freqNoGroupArrayFreqAve(:,:,a) = mean(freqNoGroupArraySpecAve,3);    
end

% Average the index values across participants
indexValuesPartAve = mean(indexValuesFreqAve,3);
indexValuesPartSTE = ste(indexValuesFreqAve,3);

freqGroupArrayPartAve = mean(freqGroupArrayFreqAve,3);
freqGroupArrayPartSTE = ste(freqGroupArrayFreqAve,3);
freqNoGroupArrayPartAve = mean(freqNoGroupArrayFreqAve,3);
freqNoGroupArrayPartSTE = ste(freqNoGroupArrayFreqAve,3);

% Plot the indices
chosenFreqNames = {'Freq Combinations','Test Freqs'};
% chosenFreqNames = {'-2','-1','0','+1','+2','+3'};
counter = 0;
for i=1:size(indexValuesPartAve,1)/4
    figure('name',chosenFreqNames{i},'NumberTitle','off');
    set(gcf,'units','normalized','position',[0 0 1 1]);
    subplot(2,2,1)
    bar(indexValuesPartAve(1+counter,:))
    hold on
    errorbar(indexValuesPartAve(1+counter,:),indexValuesPartSTE(1+counter,:),'k.');
    str = {'','1f1+1f2',''}; % cell-array method
    xlabel('Electrode','FontSize',15);
    ylabel('Index','FontSize',15);
    title(str,'FontSize',15,'FontWeight','bold');
    set(gca,'ylim',[-.1,.1])
    
    subplot(2,2,2)
    bar(indexValuesPartAve(2+counter,:))
    hold on
    errorbar(indexValuesPartAve(2+counter,:),indexValuesPartSTE(2+counter,:),'k.');
    str = {'','2f1+1f2',''}; % cell-array method
    xlabel('Electrode','FontSize',15);
    ylabel('Index','FontSize',15);
    title(str,'FontSize',15,'FontWeight','bold');
    set(gca,'ylim',[-.1,.1])
    
    subplot(2,2,3)
    bar(indexValuesPartAve(3+counter,:))
    hold on
    errorbar(indexValuesPartAve(3+counter,:),indexValuesPartSTE(3+counter,:),'k.');
    str = {'','1f1+2f2',''}; % cell-array method
    xlabel('Electrode','FontSize',15);
    ylabel('Index','FontSize',15);
    title(str,'FontSize',15,'FontWeight','bold');
    set(gca,'ylim',[-.1,.1])
    
    subplot(2,2,4)
    bar(indexValuesPartAve(4+counter,:))
    hold on
    errorbar(indexValuesPartAve(4+counter,:),indexValuesPartSTE(4+counter,:),'k.');
    str = {'','2f1+2f2',''}; % cell-array method
    xlabel('Electrode','FontSize',15);
    ylabel('Index','FontSize',15);
    title(str,'FontSize',15,'FontWeight','bold');
    set(gca,'ylim',[-.1,.1])
    
    counter = counter+4;
    
    %     savefig(sprintf('%s',inputFile,'TestFigs/fakeData_.5.fig'));
end

totalTime = toc;

% save(sprintf('%s%s',inputFile,'/tvalAverage'),'tvalAverage');
save(sprintf('%s%s',inputFile,'/finalIndex_10it_noTrialsLess5_include_all'),'indexValuesPartAve','indexValuesPartSTE','indexValuesFreqAve','freqGroupArrayPartAve',...
    'freqGroupArrayPartSTE','freqNoGroupArrayPartAve','freqNoGroupArrayPartSTE','numUsableTrials','groupFreqLength','noGroupFreqLength')










