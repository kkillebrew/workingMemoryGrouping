clear all
close all

% Stat parralell computing 
% parpool(4);

% Shuffle random number generator
rng('shuffle')

% Set max priority
% topPriorityLevel = MaxPriority('Frequency_Output_Trashcan'); % Maximum priority level for the current operating system
% Priority(9);

% load('usableParticipants.mat')
usableParticipants = {'001','002','003','004','005'};
% Array for Frequency number
freqList = [3 5 12 20];

conditionList = {'grpPrb3_5','grpPrb3_12','grpPrb3_20','grpPrb5_3','grpPrb5_12','grpPrb5_20',...
    'grpPrb12_3','grpPrb12_5','grpPrb12_20','grpPrb20_3','grpPrb20_5','grpPrb20_12',...
    'grpNoPrb3','grpNoPrb5','grpNoPrb12','grpNoPrb20',...
    'noGrp3','noGrp5','noGrp12','noGrp20',};

inputFile = '/Users/imaginguser/Documents/Kyle/R15 Grouping/Data/FakeData/';

iterationNumber = 500; % INSERT ITERATION HERE

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
%                 choosenFreq = [(i-2+j-2) (i-2+j-2+j-2) (i-2+i-2+j-2) (i-2+i-2+j-2+j-2)...
%                     (i-1+j-1) (i-1+j-1+j-1) (i-1+i-1+j-1) (i-1+i-1+j-1+j-1)...
%                     (i+1+j+1) (i+1+j+1+j+1) (i+1+i+1+j+1) (i+1+i+1+j+1+j+1)...
%                     (i+2+j+2) (i+2+j+2+j+2) (i+2+i+2+j+2) (i+2+i+2+j+2+j+2)...
%                     (i+3+j+3) (i+3+j+3+j+3) (i+3+i+3+j+3) (i+3+i+3+j+3+j+3)];
                choosenFreq = [i+j i+i+j i+j+j i+i+j+j];
                % choosenFreq = [abs(i-j) abs(i-j+j) abs(i+i-j) abs(i+i-j+j)];
                
                % Load in the data
                load(sprintf('%s%s%s%d%s%d',inputFile,usableParticipants{a},'/grpPrb',i,'_',j));
                
                % Create a temporary array for the probed grouped data
                groupTemp = eval(sprintf('%s%d%s%d','grpPrb',i,'_',j));
                
                % Get the size of the group partner freq j
                groupedFreqLength = length(eval(sprintf('%s%d%s%d','grpPrb',i,'_',j)));
    
                freqNoGroupArray = zeros(257,length(choosenFreq),iterationNumber);
                freqGroupArray = zeros(257,length(choosenFreq),iterationNumber);
                
                for m=1:iterationNumber
                    
                    % Randomly pick a subset of the no group trials
                    randNoGroup = randperm(noGroupedFreqLength,groupedFreqLength);
                    noGroupTemp = noGroup(randNoGroup);

                    % Send the averages to the FFT function
                    [freqNoGroupArray(:,:,m)] = FFT_Function_trashcan(cell2mat({mean(cat(3,groupTemp{:}),3)}),choosenFreq);
                    [freqGroupArray(:,:,m)] = FFT_Function_trashcan(cell2mat({mean(cat(3,noGroupTemp{:}),3)}),choosenFreq); 
                    
                end
                evalc(sprintf('%s%d%s','noGrpFreq',i, '= mean(freqNoGroupArray,3)'));
                evalc(sprintf('%s%d%s%d','grpFreq',i,'_',j, '= mean(freqGroupArray,3)'));
                save(sprintf('%s%s%s%d%s%d',inputFile,usableParticipants{a},'/FreqValues/grpFreq',i,'_',j),sprintf('%s%d%s%d','grpFreq',i,'_',j));
                clear (sprintf('%s%d%s%d','grpPrb',i,'_',j));
                clear (sprintf('%s%d%s%d','grpFreq',i,'_',j));
            end
        end
        save(sprintf('%s%s%s%d',inputFile,usableParticipants{a},'/FreqValues/noGrpFreq',i),sprintf('%s%d','noGrpFreq',i));
        clear (sprintf('%s%d','noGrp',i));
        clear (sprintf('%s%d','noGrpFreq',i));
    end
end

totalTime = toc;





