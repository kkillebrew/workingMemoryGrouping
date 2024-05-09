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
% usableParticipants = {'001', '002', '003', '004', '005'};

% Array for Frequency number
freqList = [3 5 12 20];

conditionList = {'grpPrb3_5','grpPrb3_12','grpPrb3_20','grpPrb5_3','grpPrb5_12','grpPrb5_20',...
    'grpPrb12_3','grpPrb12_5','grpPrb12_20','grpPrb20_3','grpPrb20_5','grpPrb20_12',...
    'noGrp3_5','noGrp3_12','noGrp3_20','noGrp5_3','noGrp5_12','noGrp5_20',...
    'noGrp12_3','noGrp12_5','noGrp12_20','noGrp20_3','noGrp20_5','noGrp20_12'};

inputFile = '/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Color/Data/';

iterationNumber = 10; % INSERT ITERATION HERE

xfreq = 0:1:999;

% How long does it take to run?
tic;

for a=1:length(usableParticipants)'
    
    if plotGraphs == 1
        % Create the figure handles for each participants average data
        eval(sprintf('%s', 'noGrpFig_',usableParticipants{a}, ' = figure(''name'',sprintf(''%s'',''Average Not Grouped '',usableParticipants{a}),''NumberTitle'',''off'')'));
        eval(sprintf('%s', 'grpFig_',usableParticipants{a}, ' = figure(''name'',sprintf(''%s'',''Average Grouped '',usableParticipants{a}),''NumberTitle'',''off'')'));
    end
    
    % Display which participant you are on
    disp(sprintf('%s%s%s%d','Participant ', usableParticipants{a}, ' or # ', a));
    % Display the total ellapsed time
    disp(sprintf('%s%d','Time elspased: ', toc/60));
    
    counter = 0;
    
    % Get the wanted frequencies for each probe and for each group
    for i=freqList
        
        % Display which freq is being run
        disp(sprintf('%s%d%s','Curently running for ', i, ' Hz probed'));
        
        for j=freqList
            
            if j == i
                
            else
                counter = counter+1;
                
                clear group noGroup
                
                % Make a list of the frequencies you want to pick
                % off of the FFT
                % Include the first and second harmonic of the
                % probe and grouped, F1+F2, F1+2F2, 2F1+F2, 2F1+2F2
                chosenFreq = [(i-2+j-2) (i-2+j-2+j-2) (i-2+i-2+j-2) (i-2+i-2+j-2+j-2)...
                    (i-1+j-1) (i-1+j-1+j-1) (i-1+i-1+j-1) (i-1+i-1+j-1+j-1)...
                    i+j i+i+j i+j+j i+i+j+j...
                    (i+1+j+1) (i+1+j+1+j+1) (i+1+i+1+j+1) (i+1+i+1+j+1+j+1)...
                    (i+2+j+2) (i+2+j+2+j+2) (i+2+i+2+j+2) (i+2+i+2+j+2+j+2)...
                    (i+3+j+3) (i+3+j+3+j+3) (i+3+i+3+j+3) (i+3+i+3+j+3+j+3)];
                %                 choosenFreq = [i+j i+i+j i+j+j i+i+j+j];
                % choosenFreq = [abs(i-j) abs(i-j+j) abs(i+i-j) abs(i+i-j+j)];
                
                % Load in the data
                load(sprintf('%s%s%s%d%s%d',inputFile,usableParticipants{a},'/noGrp',i,'_',j));

                % Create a temporary array for the probed non grouped data
                noGroup = eval(sprintf('%s%d%s%d','noGrp',i,'_',j));
                
                % Get the size of the no-group condition for prob freq
                % i
                noGroupedFreqLength = size(noGroup,1);
                
                % Display which freq is being run
                disp(sprintf('%s%d%s','Curently running for ', j, ' Hz matched'));
                
                % Load in the data
                load(sprintf('%s%s%s%d%s%d',inputFile,usableParticipants{a},'/grpPrb',i,'_',j));
                
                % Create a temporary array for the grouped data
                group = eval(sprintf('%s%d%s%d','grpPrb',i,'_',j));
                
                % Get the size of the group partner freq j
                groupedFreqLength = size(group,1);
                
                if plotGraphs == 1
                    % Create the figure you are plotting to
                    evalc(sprintf('%s%d%s%d%s%s%s','grp_fig_',i,'_',j,'_part_',usableParticipants{a},' = figure(''name'',conditionList{counter},''NumberTitle'',''off'')'));
                end
                for m=1:iterationNumber
                    
                    clear randNoGroup randGroup groupTemp noGroupTemp
                    
                    % Determine which list is longer
                    if noGroupedFreqLength >= groupedFreqLength
                        % Randomly pick a subset of the no group trials
                        randNoGroup = randperm(noGroupedFreqLength,groupedFreqLength);
                        noGroupTemp = noGroup(randNoGroup);
                        groupTemp = group;
                    elseif noGroupedFreqLength < groupedFreqLength
                        % Randomly pick a subset of the no group trials
                        randGroup = randperm(groupedFreqLength,noGroupedFreqLength);
                        groupTemp = group(randGroup);
                        noGroupTemp = noGroup;
                    end
                    
                    % Send the averages to the FFT function
                    %                     [freqNoGroupArray(:,:,m)] = FFT_Function_trashcan(cell2mat({mean(cat(3,noGroupTemp{:}),3)}),choosenFreq);
                    %                     [freqGroupArray(:,:,m)] = FFT_Function_trashcan(cell2mat({mean(cat(3,groupTemp{:}),3)}),choosenFreq);
                    
                    % Average all the waveforms together for both
                    % conditions
%                     for l=1:length(groupTemp)
%                         groupCat(:,:,l) = groupTemp{l};
%                     end
%                     for l=1:length(noGroupTemp)
%                         noGroupCat(:,:,l) = noGroupTemp{l};
%                     end
                    
                    groupAve = mean(groupTemp,1);
                    noGroupAve = mean(noGroupTemp,1);
                    
                    % Take the FFT
                    for k=1:size(groupAve,1)
                        freqGroupArrayFull(k,:,m) = abs(fft(groupAve(k,:)));
                        freqNoGroupArrayFull(k,:,m) = abs(fft(noGroupAve(k,:)));
                    end
                    
                    if plotGraphs == 1
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
                
                if plotGraphs == 1
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
                
                % Pick off only the specific freqs you are looking for
                freqCounter = 0;
                for l=1:length(chosenFreq)
                    freqCounter = freqCounter+1;
                    freqNoGroupArray(:,freqCounter) = freqNoGroupArrayFullAve(:,l+1);
                    freqGroupArray(:,freqCounter) = freqGroupArrayFullAve(:,l+1);
                end
                
                evalc(sprintf('%s%d%s%d','grpFreq',i,'_',j, '= mean(freqGroupArray,3)'));
                evalc(sprintf('%s%d%s%d%s','noGrpFreq',i,'_',j, '= mean(freqNoGroupArray,3)'));
                
                save(sprintf('%s%s%s%d%s%d',inputFile,usableParticipants{a},'/FreqValues/grpFreq',i,'_',j),sprintf('%s%d%s%d','grpFreq',i,'_',j));
                clear (sprintf('%s%d%s%d','grpPrb',i,'_',j));
                clear (sprintf('%s%d%s%d','grpFreq',i,'_',j));
                
                save(sprintf('%s%s%s%d%s%d',inputFile,usableParticipants{a},'/FreqValues/noGrpFreq',i,'_',j),sprintf('%s%d%s%d','noGrpFreq',i,'_',j));
                clear (sprintf('%s%d%s%d','noGrp',i,'_',j));
                clear (sprintf('%s%d%s%d','noGrpFreq',i,'_',j));
                
                % Clear all temporary variables used in the iteration loop
                clear freqNoGroupArrayFullAve freqGroupArrayFullAve freqGroupArray freqNoGroupArray freqGroupArrayFull freqNoGroupArrayFull groupAve groupCat noGroupAve noGroupCat
            end
        end
    end
end

totalTime = toc;





