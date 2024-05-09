% rawdata(n,1) = 1=grouped 2=no group
% rawdata(n,2) = 1=probed 2=non probed
% rawdata(n,3) = 1=old, 2=new
% rawdata(n,4) = frequency probed F1-F4
% rawdata(n,5) = responded it was 1=old, 2=new
% rawdata(n,6) = did they get it 1=correct or 0=incorrect
% rawdata(n,7) = probe; % which image was probed 1,2,3,4
% rawdata(n,8) = 0=no response, 1=response
% rawdata(n,9) = trial presentation order

close all;
clear all;

% Lists of all the data files that need to be loaded in
% fileListRawdata = {'MG_wmGrouping_100614_001','CB_wmGrouping_102114_001','KM_wmGrouping_102314_001',...
%     'SR_wmGrouping_102314_001','ZZ_wmGrouping_102414_001','MC_wmGrouping_102414_001','GG_wmGrouping_102714_001','CC_wmGrouping_102814_001',...
%     'JV_wmGrouping_102914_001','AW_wmGrouping_103014_001','TL_wmGrouping_110314_001','K001_wmGrouping_110614_001'};
% fileListEEGdata = {'MG_001_Grouping_20141006_023922_fil_seg_bcr','CB_20141021_021133_fil_seg_bcr',...
%     'KM_20141023_103643_fil_seg_bcr','SR_20141023_010548_fil_seg_bcr','ZZ_20141024_103430_fil_seg_bcr','MC_20141024_030625_fil_seg_bcr',...
%     'GG_20141027_010143_fil_seg_bcr','CC_20141028_095732_fil_seg_bcr','JV_20141029_042228_fil_seg_bcr','AW_20141030_022500_fil_seg_bcr',...
%     'TL_20141103_122241_fil_seg_bcr','K001_20141106_121758_fil_seg_bcr'};
% fileListBadSeg = {'MG_001_Grouping_20141006_023922_fil_seg.txt','CB_20141021_021133_fil_seg.txt',...
%     'KM_20141023_103643_fil_seg.txt','SR_20141023_010548_fil_seg.txt','ZZ_20141024_103430_fil_seg.txt','MC_20141024_030625_fil_seg.txt',...
%     'GG_20141027_010143_fil_seg.txt','CC_20141028_095732_fil_seg.txt','JV_20141029_042228_fil_seg.txt','AW_20141030_022500_fil_seg.txt',...
%     'TL_20141103_122241_fil_seg.txt','K001_20141106_121758_fil_seg.txt'};
% subjID = {'MG','CB','KM','SR','ZZ','MC','GG','CC','JV','AW','TL','K001'};

% fileListRawdata = {'KK_wmGrouping_111214_001_full','MC_wmGrouping_111114_002_full','K004_wmGrouping_111314_001_full'};
% fileListEEGdata = {'KK_20141112_051846_fil_seg_bcr','MC_20141111_124003_fil_seg_bcr','K004_20141113_100301_fil_seg_bcr'};
% fileListBadSeg = {'KK_20141112_051846_fil_seg_bcr.txt','MC_20141111_124003_fil_seg_bcr.txt','K004_20141113_100301_fil_seg_bcr.txt'};
% subjID = {'KK','MC','K004'};

fileListRawdata = {'K003_wmGrouping_111114_001_full','MC_wmGrouping_111114_002_full',...
    'KM_wmGrouping_111214_002_full','KK_wmGrouping_111214_001_full','NS_wmGrouping_111314_001_full',...
    'K005_wmGrouping_111414_001_full','MG_wmGrouping_111414_002_full','CB_wmGrouping_111414_002_full','CC_wmGrouping_112014_002_full',...
    'SR_wmGrouping_111914_002_full','CR_wmGrouping_112014_001_full','TL_wmGrouping_120214_002_full','K006_wmGrouping_120214_001_full',...
    'AW_wmGrouping_120314_002_full','MM_wmGrouping_121814_001_full','GG_wmGrouping_121814_002_full','K007_wmGrouping_012215_001_full',...
    'K008_wmGrouping_012315_001_full','K009_wmGrouping_013015_001_full','K010_wmGrouping_021015_001_full'};

fileListEEGdata = {'K003_20141111_110256_fil_seg_bcr','MC_20141111_124003_fil_seg_bcr',...
    'KM_20141112_040211_fil_seg_bcr','KK_20141112_051846_fil_seg_bcr',...
    'NS_20141113_011952_fil_seg_bcr','K005_20141114_012954_fil_seg_bcr','MG_20141114_103743_fil_seg_bcr','CB_20141114_120106_fil_seg_bcr',...
    'CC_20141120_120137_fil_seg_bcr','SR_20141119_043926_fil_seg_bcr','CR_20141120_012801_fil_seg_bcr','TL_20141202_110241_fil_seg_bcr',...
    'K006_20141202_125410_fil_seg_bcr','AW_20141203_100502_fil_seg_bcr','MM_20141218_112529_fil_seg_bcr','GG_20141218_125845_fil_seg_bcr',...
    'K007_20150122_123120_fil_seg_bcr','K008_20150123_103548_fil_seg_bcr','K009_20150130_123120_fil_seg_bcr','K010_20150210_105650_fil_seg_bcr'};

fileListBadSeg = {'K003_20141111_110256_fil_seg_bcr.txt','MC_20141111_124003_fil_seg_bcr.txt',...
    'KM_20141112_040211_fil_seg_bcr.txt','KK_20141112_051846_fil_seg_bcr.txt',...
    'NS_20141113_011952_fil_seg_bcr.txt','K005_20141114_012954_fil_seg_bcr.txt','MG_20141114_103743_fil_seg_bcr.txt','CB_20141114_120106_fil_seg_bcr.txt',...
    'CC_20141120_120137_fil_seg_bcr.txt','SR_20141119_043926_fil_seg_bcr.txt','CR_20141120_012801_fil_seg_bcr.txt','TL_20141202_110241_fil_seg_bcr.txt',...
    'K006_20141202_125410_fil_seg_bcr.txt','AW_20141203_100502_fil_seg_bcr.txt','MM_20141218_112529_fil_seg_bcr.txt','GG_20141218_125845_fil_seg_bcr.txt',...
    'K007_20150122_123120_fil_seg_bcr.txt','K008_20150123_103548_fil_seg_bcr.txt','K009_20150130_123120_fil_seg_bcr.txt','K010_20150210_105650_fil_seg_bcr.txt'};

subjID = {'K003','MC','KM','KK','NS','K005','MG','CB','CC','SR','CR','TL','K006','AW','MM','GG','K007','K008','K009','K010'};

inputFile = '/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Color/Data/';

conditionList = {'grpPrb3_5','grpPrb3_12','grpPrb3_20','grpPrb5_3','grpPrb5_12','grpPrb5_20',...
    'grpPrb12_3','grpPrb12_5','grpPrb12_20','grpPrb20_3','grpPrb20_5','grpPrb20_12',...
    'grpNoPrb3','grpNoPrb5','grpNoPrb12','grpNoPrb20',...
    'noGrp3','noGrp5','noGrp12','noGrp20',};

% Figure out which participants are usable based on number of usable trials
% usableCounter = 0;
% usableParticipants = {};

% If you already have a usableParticipants file load it in here
load(sprintf('%s%s',inputFile,'usableParticipants'));

for a=length(fileListRawdata)'-5:length(fileListRawdata)'

    load(sprintf('%s%s%s%s',inputFile,subjID{a},'/VEP Data/',fileListRawdata{a}),'rateraw','rawdata');
    load(sprintf('%s%s%s%s',inputFile,subjID{a},'/VEP Data/',fileListEEGdata{a}));
    
    % Read in from the text file to determine which segments are usable
    fileID=fopen(sprintf('%s%s%s%s',inputFile,subjID{a},'/',fileListBadSeg{a}));
    formatSpec='%*s %*s %*s %s %*[^\n]';
    
    badSegments=textscan(fileID,formatSpec,max(rawdata(:,9)),'Headerlines',1);
    badSegments = badSegments';
    
    % if the participant has more than 25% bad segments exclude them from
    % analysis
    badSegNumber =  sum(strcmp(badSegments{:}, 'false'));
    
    % Calculate the number of bad segments
    if badSegNumber >= .25*(length(badSegments{1}))
        save(sprintf('%s%s%s%s',inputFile,subjID{a},'/VEP Data/badSeg_',subjID{a}),'badSegments','badSegNumber');
    else
        % Make an array of indices for segments that have been re-recorded due
        % to no response
        counter = 1;
        for i=1:length(rawdata)-1
            if ((rawdata(i+1,9))-rawdata(i,9))>1
                noResponseIndexArray(counter) = i;
                counter = counter+1;
            end
        end
        
        % Reassign the cell array containing the EEG data to a new cell array
        eegData = eval(sprintf('%s%s',fileListEEGdata{a},'mff'));
        
        countRawdata = 0;
        
        % Grouped-probed 3hz
        grpPrb3_5 = {};
        grpPrb3_12 = {};
        grpPrb3_20 = {};
        count_grpPrb3_5 = 0;
        count_grpPrb3_12 = 0;
        count_grpPrb3_20 = 0;
        
        % Gropued-probed 5hz
        grpPrb5_3 = {};
        grpPrb5_12 = {};
        grpPrb5_20 = {};
        count_grpPrb5_3 = 0;
        count_grpPrb5_12 = 0;
        count_grpPrb5_20 = 0;
        
        % Grouped-probed 12hz
        grpPrb12_3 = {};
        grpPrb12_5 = {};
        grpPrb12_20 = {};
        count_grpPrb12_3 = 0;
        count_grpPrb12_5 = 0;
        count_grpPrb12_20 = 0;
        
        % Groped-probed 20hz
        grpPrb20_3 = {};
        grpPrb20_5 = {};
        grpPrb20_12 = {};
        count_grpPrb20_3 = 0;
        count_grpPrb20_5 = 0;
        count_grpPrb20_12 = 0;
        
        % Grouped not probed
        grpNoPrb3 = {};
        grpNoPrb5 = {};
        grpNoPrb12 = {};
        grpNoPrb20 = {};
        count_grpNoPrb3 = 0;
        count_grpNoPrb5 = 0;
        count_grpNoPrb12 = 0;
        count_grpNoPrb20 = 0;
        
        % Non-grouped conditions
        noGrp3 = {};
        noGrp5 = {};
        noGrp12 = {};
        noGrp20 = {};
        count_noGrp3 = 0;
        count_noGrp5 = 0;
        count_noGrp12 = 0;
        count_noGrp20 = 0;
        
        % Segment data into different arrays based on conditions
        for i = rawdata(:,9)'
            
            countRawdata = countRawdata+1;
            
            groupedFreq(countRawdata,1,a) = rawdata(countRawdata,4);
            % Figure out what the gourped frequency is
            if rateraw(countRawdata,1) == rawdata(countRawdata,4)
                groupedFreq(countRawdata,2,a) = rateraw(countRawdata,3);
            elseif rateraw(countRawdata,3) == rawdata(countRawdata,4)
                groupedFreq(countRawdata,2,a) = rateraw(countRawdata,1);
            elseif rateraw(countRawdata,2) == rawdata(countRawdata,4)
                groupedFreq(countRawdata,2,a) = rateraw(countRawdata,4);
            elseif rateraw(countRawdata,4) == rawdata(countRawdata,4)
                groupedFreq(countRawdata,2,a) = rateraw(countRawdata,2);
            end
            
            
            if strcmp(badSegments{1}{i},'true')
                if rawdata(countRawdata,6) == 1
                    % Grouped probed 3 hz
                    if rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 1 && rawdata(countRawdata,4) == 1 && groupedFreq(countRawdata,2,a) == 2
                        count_grpPrb3_5=count_grpPrb3_5+1;
                        grpPrb3_5{count_grpPrb3_5} = eegData{1,i};
                        
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 1 && rawdata(countRawdata,4) == 1 && groupedFreq(countRawdata,2,a) == 3
                        count_grpPrb3_12=count_grpPrb3_12+1;
                        grpPrb3_12{count_grpPrb3_12} = eegData{1,i};
                        
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 1 && rawdata(countRawdata,4) == 1 && groupedFreq(countRawdata,2,a) == 4
                        count_grpPrb3_20=count_grpPrb3_20+1;
                        grpPrb3_20{count_grpPrb3_20} = eegData{1,i};
                        
                        
                        % Grouped probed 5 hz
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 1 && rawdata(countRawdata,4) == 2 && groupedFreq(countRawdata,2,a) == 1
                        count_grpPrb5_3=count_grpPrb5_3+1;
                        grpPrb5_3{count_grpPrb5_3} = eegData{1,i};
                        
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 1 && rawdata(countRawdata,4) == 2 && groupedFreq(countRawdata,2,a) == 3
                        count_grpPrb5_12=count_grpPrb5_12+1;
                        grpPrb5_12{count_grpPrb5_12} = eegData{1,i};
                        
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 1 && rawdata(countRawdata,4) == 2 && groupedFreq(countRawdata,2,a) == 4
                        count_grpPrb5_20=count_grpPrb5_20+1;
                        grpPrb5_20{count_grpPrb5_20} = eegData{1,i};
                        
                        
                        % Grouped probed 12 hz
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 1 && rawdata(countRawdata,4) == 3 && groupedFreq(countRawdata,2,a) == 1
                        count_grpPrb12_3=count_grpPrb12_3+1;
                        grpPrb12_3{count_grpPrb12_3} = eegData{1,i};
                        
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 1 && rawdata(countRawdata,4) == 3 && groupedFreq(countRawdata,2,a) == 2
                        count_grpPrb12_5=count_grpPrb12_5+1;
                        grpPrb12_5{count_grpPrb12_5} = eegData{1,i};
                        
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 1 && rawdata(countRawdata,4) == 3 && groupedFreq(countRawdata,2,a) == 4
                        count_grpPrb12_20=count_grpPrb12_20+1;
                        grpPrb12_20{count_grpPrb12_20} = eegData{1,i};
                        
                        
                        % Grouped probed 20 hz
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 1 && rawdata(countRawdata,4) == 4 && groupedFreq(countRawdata,2,a) == 1
                        count_grpPrb20_3=count_grpPrb20_3+1;
                        grpPrb20_3{count_grpPrb20_3} = eegData{1,i};
                        
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 1 && rawdata(countRawdata,4) == 4 && groupedFreq(countRawdata,2,a) == 2
                        count_grpPrb20_5=count_grpPrb20_5+1;
                        grpPrb20_5{count_grpPrb20_5} = eegData{1,i};
                        
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 1 && rawdata(countRawdata,4) == 4 && groupedFreq(countRawdata,2,a) == 3
                        count_grpPrb20_12=count_grpPrb20_12+1;
                        grpPrb20_12{count_grpPrb20_12} = eegData{1,i};
                        
                        
                        % Grouped non probed
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 2 && rawdata(countRawdata,4) == 1
                        count_grpNoPrb3=count_grpNoPrb3+1;
                        grpNoPrb3{count_grpNoPrb3} = eegData{1,i};
                        
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 2 && rawdata(countRawdata,4) == 2
                        count_grpNoPrb5=count_grpNoPrb5+1;
                        grpNoPrb5{count_grpNoPrb5} = eegData{1,i};
                        
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 2 && rawdata(countRawdata,4) == 3
                        count_grpNoPrb12=count_grpNoPrb12+1;
                        grpNoPrb12{count_grpNoPrb12} = eegData{1,i};
                        
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 2 && rawdata(countRawdata,4) == 4
                        count_grpNoPrb20=count_grpNoPrb20+1;
                        grpNoPrb20{count_grpNoPrb20} = eegData{1,i};
                        
                        
                        % Not Grouped
                    elseif rawdata(countRawdata,1) == 2 && rawdata(countRawdata,4) == 1
                        count_noGrp3=count_noGrp3+1;
                        noGrp3{count_noGrp3} = eegData{1,i};
                        
                    elseif rawdata(countRawdata,1) == 2 && rawdata(countRawdata,4) == 2
                        count_noGrp5=count_noGrp5+1;
                        noGrp5{count_noGrp5} = eegData{1,i};
                        
                    elseif rawdata(countRawdata,1) == 2 && rawdata(countRawdata,4) == 3
                        count_noGrp12=count_noGrp12+1;
                        noGrp12{count_noGrp12} = eegData{1,i};
                        
                    elseif rawdata(countRawdata,1) == 2 && rawdata(countRawdata,4) == 4
                        count_noGrp20=count_noGrp20+1;
                        noGrp20{count_noGrp20} = eegData{1,i};
                    end
                end
            end
        end
        
        %         % put the data in the format that brainstorm expects
        %         % 3hz
        %         grpPrb3_5 = horzcat(grpPrb3_5{:});
        %         grpPrb3_12 = horzcat(grpPrb3_12{:});
        %         grpPrb3_20 = horzcat(grpPrb3_20{:});
        %
        %         % 5hz
        %         grpPrb5_3 = horzcat(grpPrb5_3{:});
        %         grpPrb5_12 = horzcat(grpPrb5_12{:});
        %         grpPrb5_20 = horzcat(grpPrb5_20{:});
        %
        %         % 12hz
        %         grpPrb12_3 = horzcat(grpPrb12_3{:});
        %         grpPrb12_5 = horzcat(grpPrb12_5{:});
        %         grpPrb12_20 = horzcat(grpPrb12_20{:});
        %
        %         % 20hz
        %         grpPrb20_3 = horzcat(grpPrb20_3{:});
        %         grpPrb20_5 = horzcat(grpPrb20_5{:});
        %         grpPrb20_12 = horzcat(grpPrb20_12{:});
        %
        %         grpNoPrb3 = horzcat(grpNoPrb3{:});
        %         grpNoPrb5 = horzcat(grpNoPrb5{:});
        %         grpNoPrb12 = horzcat(grpNoPrb12{:});
        %         grpNoPrb20 = horzcat(grpNoPrb20{:});
        %         noGrp3 = horzcat(noGrp3{:});
        %         noGrp5 = horzcat(noGrp5{:});
        %         noGrp12 = horzcat(noGrp12{:});
        %         noGrp20 = horzcat(noGrp20{:});
        
        for p=1:length(conditionList)
            % Save all the different files to the individual subject folders
            save(sprintf('%s%s%s%s',inputFile,subjID{a},'/VEP Data/',conditionList{p}),conditionList{p})
        end
        
%         for p = length(usableParticipants)+1
%             usableParticipants{p} = subjID{a};
%         end
    end
    save(sprintf('%s%s%s%s',inputFile,subjID{a},'/VEP Data/badSeg_',subjID{a}),'badSegments','badSegNumber');
    
    
end

% save(sprintf('%s%s',inputFile,'/usableParticipants'),'usableParticipants');










