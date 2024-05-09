clear all
% close all

load('usableParticipants.mat')
% Array for Frequency number
freqList = [3 5 12 20];

conditionList = {'grpPrb3_5','grpPrb3_12','grpPrb3_20','grpPrb5_3','grpPrb5_12','grpPrb5_20',...
    'grpPrb12_3','grpPrb12_5','grpPrb12_20','grpPrb20_3','grpPrb20_5','grpPrb20_12',...
    'grpNoPrb3','grpNoPrb5','grpNoPrb12','grpNoPrb20',...
    'noGrp3','noGrp5','noGrp12','noGrp20',};

inputFile = '/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Color/Data/';


for a=1:length(usableParticipants)'
    
    % Get the wanted frequencies for each probe and for each group
    for i=freqList
        i
        
        % Load in the data
        load(sprintf('%s%s%s%d',inputFile,usableParticipants{a},'/noGrp',i));
        
        % Get the size of the no-group condition for prob freq
        % i
        noGroupedFreqLength = length(eval(sprintf('%s%d','noGrp',i)));
        
        % Create a temporary array for the probed non grouped data
        noGroup = eval(sprintf('%s%d','noGrp',i));
        
        for j=freqList
            j
            if j == i
                
            else
                
                % Load in the data
                load(sprintf('%s%s%s%d%s%d',inputFile,usableParticipants{a},'/grpPrb',i,'_',j));
                
                % Create a temporary array for the probed grouped data
                groupTemp = eval(sprintf('%s%d%s%d','grpPrb',i,'_',j));
                
                for m=1:1000 % INSERT ITERATION HERE
                                        
                    % Get the size of the group partner freq j
                    groupedFreqLength = length(eval(sprintf('%s%d%s%d','grpPrb',i,'_',j)));
                    
                    % Randomly pick a subset of the no group trials
                    randNoGroup = randperm(noGroupedFreqLength,groupedFreqLength);
                    noGroupTemp = noGroup(randNoGroup);
                    
                    % Average across trials
                    groupTempMean = {mean(cat(3,groupTemp{:}),3)};
                    %                         eval([conditionList{i} '=  tempArray ;'])
                    noGroupTempMean = {mean(cat(3,noGroupTemp{:}),3)};
                    
                    % Convert the cell arrays to arrays
                    groupTempMean = cell2mat(groupTempMean);
                    noGroupTempMean = cell2mat(noGroupTempMean);
                    
                    % Make a list of the frequencies you want to pick
                    % off of the FFT
                    % Include the first and second harmonic of the
                    % probe and grouped, F1+F2, F1+2F2, 2F1+F2, 2F1+2F2
%                     choosenFreq = [i i+i j j+j i+j i+j+j i+i+j i+i+j+j];
                    choosenFreq = [abs(i-j) abs(i-j+j) abs(i+i-j) abs(i+i-j+j)];

                    % Send the averages to the FFT function
                    [freqNoGroup,freqNoGroup_full] = FFT_Function(noGroupTempMean,choosenFreq);
                    [freqGroup,freqGroup_full] = FFT_Function(groupTempMean,choosenFreq);
                    
                    % Store each set in a 3D array to collapse after
                    % iterating 
                    freqNoGroupArray(:,:,m) = freqNoGroup;
                    freqGroupArray(:,:,m) = freqGroup;
                    
                end
                eval(sprintf('%s%d%s','noGrpFreq',i, '= mean(freqNoGroupArray,3)'));
                eval(sprintf('%s%d%s%d%s','grpFreq',i,'_',j, '= mean(freqGroupArray,3)'));
                save(sprintf('%s%s%s%s%d%s%d%s',inputFile,usableParticipants{a},'/FreqValues/','grpFreq',i,'_',j,'_sub'),sprintf('%s%d%s%d','grpFreq',i,'_',j));
                
            end
        end
        save(sprintf('%s%s%s%s%d%s',inputFile,usableParticipants{a},'/FreqValues/','noGrpFreq',i,'_sub'),sprintf('%s%d','noGrpFreq',i));
    end
end







