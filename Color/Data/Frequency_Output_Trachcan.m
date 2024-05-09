clear all
close all

% Stat parralell computing 
% parpool(4);

% Shuffle random number generator
rng('shuffle')

% Set max priority
% topPriorityLevel = MaxPriority('Frequency_Output_Trashcan'); % Maximum priority level for the current operating system
% Priority(9);

load('usableParticipants.mat')
% Array for Frequency number
freqList = [3 5 12 20];

conditionList = {'grpPrb3_5','grpPrb3_12','grpPrb3_20','grpPrb5_3','grpPrb5_12','grpPrb5_20',...
    'grpPrb12_3','grpPrb12_5','grpPrb12_20','grpPrb20_3','grpPrb20_5','grpPrb20_12',...
    'grpNoPrb3','grpNoPrb5','grpNoPrb12','grpNoPrb20',...
    'noGrp3','noGrp5','noGrp12','noGrp20',};

inputFile = '/Users/imaginguser/Documents/Kyle/R15 Grouping/Data/';

iterationNumber = 50000; % INSERT ITERATION HERE

% How long does it take to run?
tic;

for a=1:length(usableParticipants)'
    
    % Display which participant you are on
    disp(sprintf('%s%s%s%d','Participant ', usableParticipants{a}, ' or # ', a));
    % Display the total ellapsed time
    disp(sprintf('%s%d','Time elspased: ', toc/60));
    
    % Get the wanted frequencies for each probe and for each group
    for i=freqList
        
        % Display which freq is being run
        disp(sprintf('%s%d%s','Curently running for ', i, ' Hz probed'));
        
        % Load in the data
        load(sprintf('%s%s%s%d',inputFile,usableParticipants{a},'/noGrp',i));
        
        % Get the size of the no-group condition for prob freq
        % i
        noGroupedFreqLength = length(eval(sprintf('%s%d','noGrp',i)));
        
        % Create a temporary array for the probed non grouped data
        noGroup = eval(sprintf('%s%d','noGrp',i));
        
        for j=freqList
            
            if j == i
                
            else
                
                % Display which freq is being run
                disp(sprintf('%s%d%s','Curently running for ', j, ' Hz matched'));
                
                % Make a list of the frequencies you want to pick
                % off of the FFT
                % Include the first and second harmonic of the
                % probe and grouped, F1+F2, F1+2F2, 2F1+F2, 2F1+2F2
                choosenFreq = [i i+i j j+j i+j i+j+j i+i+j i+i+j+j];
                % choosenFreq = [abs(i-j) abs(i-j+j) abs(i+i-j) abs(i+i-j+j)];
                
                % Load in the data
                load(sprintf('%s%s%s%d%s%d',inputFile,usableParticipants{a},'/grpPrb',i,'_',j));
                
                % Create a temporary array for the probed grouped data
                groupTemp = eval(sprintf('%s%d%s%d','grpPrb',i,'_',j));
                
                % Get the size of the group partner freq j
                groupedFreqLength = length(eval(sprintf('%s%d%s%d','grpPrb',i,'_',j)));
                
                % Preallocate all variables in the parfor loop
%                 randNoGroup = zeros(iterationNumber,groupedFreqLength);
%                 noGroupTemp = cell(iterationNumber,groupedFreqLength);
%                 for w=1:iterationNumber
%                     for t=1:groupedFreqLength
%                         noGroupTemp{w,t} = zeros(257,1000);
%                     end
%                 end
%                 groupTempMean = cell(iterationNumber,1);
%                 noGroupTempMean = cell(iterationNumber,1);
%                 for w=1:iterationNumber
%                     groupTempMean{w} = zeros(257,1000);
%                     noGroupTempMean{w} = zeros(257,1000);
%                 end
%                 groupTempMeanArray = zeros(257,1000,iterationNumber);
%                 noGroupTempMeanArray = zeros(257,1000,iterationNumber);
                freqNoGroupArray = zeros(257,length(choosenFreq),iterationNumber);
                freqGroupArray = zeros(257,length(choosenFreq),iterationNumber);
                
                for m=1:iterationNumber
                    
                    % Randomly pick a subset of the no group trials
                    randNoGroup = randperm(noGroupedFreqLength,groupedFreqLength);
                    noGroupTemp = noGroup(randNoGroup);
                    
                    % Average across trials
%                     groupTempMean{m} = {mean(cat(3,groupTemp{:}),3)};
%                     noGroupTempMean{m} = {mean(cat(3,noGroupTemp{m,:}),3)};
                    
                    % Convert the cell arrays to arrays
%                     groupTempMeanArray(:,:,m) = cell2mat(groupTempMean{m});
%                     noGroupTempMeanArray(:,:,m) = cell2mat(noGroupTempMean{m});

                    % Send the averages to the FFT function
                    [freqNoGroupArray(:,:,m)] = FFT_Function_trashcan(cell2mat({mean(cat(3,groupTemp{:}),3)}),choosenFreq);
                    [freqGroupArray(:,:,m)] = FFT_Function_trashcan(cell2mat({mean(cat(3,noGroupTemp{:}),3)}),choosenFreq); 
                    
                end
                evalc(sprintf('%s%d%s','noGrpFreq',i, '= mean(freqNoGroupArray,3)'));
                evalc(sprintf('%s%d%s%d%s','grpFreq',i,'_',j, '= mean(freqGroupArray,3)'));
                save(sprintf('%s%s%s%s%d%s%d%s',inputFile,usableParticipants{a},'/FreqValues/','grpFreq',i,'_',j,'_sub'),sprintf('%s%d%s%d','grpFreq',i,'_',j));
                clear (sprintf('%s%d%s%d','grpPrb',i,'_',j));
                clear (sprintf('%s%d%s%d','grpFreq',i,'_',j));
            end
        end
        save(sprintf('%s%s%s%s%d%s',inputFile,usableParticipants{a},'/FreqValues/','noGrpFreq',i,'_sub'),sprintf('%s%d','noGrpFreq',i));
        clear (sprintf('%s%d','noGrp',i));
        clear (sprintf('%s%d','noGrpFreq',i));
    end
end

% Priority(0);

totalTime = toc;

% Stops parrallel computing
% delete(gcp);




