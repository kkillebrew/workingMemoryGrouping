
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


% fileListBadSeg = {'K003_20141111_110256_fil_seg_bcr.txt','MC_20141111_124003_fil_seg_bcr.txt',...
%     'KM_20141112_040211_fil_seg_bcr.txt','KK_20141112_051846_fil_seg_bcr.txt',...
%     'NS_20141113_011952_fil_seg_bcr.txt','K005_20141114_012954_fil_seg_bcr.txt','MG_20141114_103743_fil_seg_bcr.txt','CB_20141114_120106_fil_seg_bcr.txt',...
%     'CC_20141120_120137_fil_seg_bcr.txt','SR_20141119_043926_fil_seg_bcr.txt','CR_20141120_012801_fil_seg_bcr.txt','TL_20141202_110241_fil_seg_bcr.txt',...
%     'K006_20141202_125410_fil_seg_bcr.txt','AW_20141203_100502_fil_seg_bcr.txt','MM_20141218_112529_fil_seg_bcr.txt','GG_20141218_125845_fil_seg_bcr.txt',...
%     'K007_20150122_123120_fil_seg_bcr.txt','K008_20150123_103548_fil_seg_bcr.txt','K009_20150130_123120_fil_seg_bcr.txt','K010_20150210_105650_fil_seg_bcr.txt'};


subjID = {'K003','MC','KM','KK','NS','K005','MG','CB','CC','SR','CR','TL','K006','AW','MM','GG','K007','K008','K009','K010'};

inputFile = '/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Color/Data2/';

conditionList = {'grpPrb3_5','grpPrb3_12','grpPrb3_20','grpPrb5_3','grpPrb5_12','grpPrb5_20',...
    'grpPrb12_3','grpPrb12_5','grpPrb12_20','grpPrb20_3','grpPrb20_5','grpPrb20_12',...
    'noGrp3_5','noGrp3_12','noGrp3_20','noGrp5_3','noGrp5_12','noGrp5_20',...
    'noGrp12_3','noGrp12_5','noGrp12_20','noGrp20_3','noGrp20_5','noGrp20_12'};

% Figure out which participants are usable based on number of usable trials
usableCounter = 0;
usableParticipants = {};

for a=1:length(fileListRawdata)'
    a
    load(sprintf('%s%s%s%s',inputFile,subjID{a},'/',fileListRawdata{a}),'rateraw','rawdata');
    load(sprintf('%s%s%s%s',inputFile,subjID{a},'/',fileListEEGdata{a}));
    
    % Read in from the text file to determine which segments are usable
    %     fileID=fopen(sprintf('%s%s%s%s',inputFile,subjID{a},'/',fileListBadSeg{a}));
    fileID=fopen(sprintf('%s%s%s%s',inputFile,subjID{a},'/',fileListBadSeg{a}));
    formatSpec='%*s %*s %*s %s %*[^\n]';
    
    badSegments=textscan(fileID,formatSpec,max(rawdata(:,9)),'Headerlines',1);
    badSegments = badSegments';
    
    % if the participant has more than 25% bad segments exclude them from
    % analysis
    badSegNumber =  sum(strcmp(badSegments{:}, 'false'));
    
    % Calculate the number of bad segments
    if badSegNumber >= .25*(length(badSegments{1}))
%         save(sprintf('%s%s%s%s',inputFile,subjID{a},'/Updated/badSeg_',subjID{a}),'badSegments','badSegNumber');
        save(sprintf('%s%s%s%s',inputFile,subjID{a}),'badSegments','badSegNumber');
    else
        
        % Reassign the cell array containing the EEG data to a new cell array
%         eegData = eval(sprintf('%s%s',fileListEEGdata{a},'mff'));
        
        countRawdata = 0;
        
        % Grouped-probed 3hz
        grpPrb3_5 = [];
        grpPrb3_12 = [];
        grpPrb3_20 = [];
        count_grpPrb3_5 = 0;
        count_grpPrb3_12 = 0;
        count_grpPrb3_20 = 0;
        
        % Gropued-probed 5hz
        grpPrb5_3 = [];
        grpPrb5_12 = [];
        grpPrb5_20 = [];
        count_grpPrb5_3 = 0;
        count_grpPrb5_12 = 0;
        count_grpPrb5_20 = 0;
        
        % Grouped-probed 12hz
        grpPrb12_3 = [];
        grpPrb12_5 = [];
        grpPrb12_20 = [];
        count_grpPrb12_3 = 0;
        count_grpPrb12_5 = 0;
        count_grpPrb12_20 = 0;
        
        % Groped-probed 20hz
        grpPrb20_3 = [];
        grpPrb20_5 = [];
        grpPrb20_12 = [];
        count_grpPrb20_3 = 0;
        count_grpPrb20_5 = 0;
        count_grpPrb20_12 = 0;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Grouped not probed 3hz
        grpNoPrb3_5 = [];
        grpNoPrb3_12 = [];
        grpNoPrb3_20 = [];
        count_grpNoPrb3_5 = 0;
        count_grpNoPrb3_12 = 0;
        count_grpNoPrb3_20 = 0;
        
        % Grouped not probed 5hz
        grpNoPrb5_3 = [];
        grpNoPrb5_12 = [];
        grpNoPrb5_20 = [];
        count_grpNoPrb5_3 = 0;
        count_grpNoPrb5_12 = 0;
        count_grpNoPrb5_20 = 0;
        
        % Grouped not probed 12hz
        grpNoPrb12_3 = [];
        grpNoPrb12_5 = [];
        grpNoPrb12_20 = [];
        count_grpNoPrb12_3 = 0;
        count_grpNoPrb12_5 = 0;
        count_grpNoPrb12_20 = 0;
        
        % Grouped not probed 20hz
        grpNoPrb20_3 = [];
        grpNoPrb20_5 = [];
        grpNoPrb20_12 = [];
        count_grpNoPrb20_3 = 0;
        count_grpNoPrb20_5 = 0;
        count_grpNoPrb20_12 = 0;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Non-grouped 3hz
        noGrp3_5 = [];
        noGrp3_12 = [];
        noGrp3_20 = [];
        count_noGrp3_5 = 0;
        count_noGrp3_12 = 0;
        count_noGrp3_20 = 0;
        
        % Non-grouped 5hz
        noGrp5_3 = [];
        noGrp5_12 = [];
        noGrp5_20 = [];
        count_noGrp5_3 = 0;
        count_noGrp5_12 = 0;
        count_noGrp5_20 = 0;
        
        % Non-grouped 12hz
        noGrp12_3 = [];
        noGrp12_5 = [];
        noGrp12_20 = [];
        count_noGrp12_3 = 0;
        count_noGrp12_5 = 0;
        count_noGrp12_20 = 0;
        
        % Non-grouped 20hz
        noGrp20_3 = [];
        noGrp20_5 = [];
        noGrp20_12 = [];
        count_noGrp20_3 = 0;
        count_noGrp20_5 = 0; 
        count_noGrp20_12 = 0; 
                
        
        
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
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                    % Grouped probed 3 hz
                    if rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 1 && rawdata(countRawdata,4) == 1 && groupedFreq(countRawdata,2,a) == 2
                        count_grpPrb3_5=count_grpPrb3_5+1;
                        grpPrb(count_grpPrb3_5,:,:) = cell2mat(eegData(1,i));
                        
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 1 && rawdata(countRawdata,4) == 1 && groupedFreq(countRawdata,2,a) == 3
                        count_grpPrb3_12=count_grpPrb3_12+1;
                        
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 1 && rawdata(countRawdata,4) == 1 && groupedFreq(countRawdata,2,a) == 4
                        count_grpPrb3_20=count_grpPrb3_20+1;
                        
                        
                        % Grouped probed 5 hz
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 1 && rawdata(countRawdata,4) == 2 && groupedFreq(countRawdata,2,a) == 1
                        count_grpPrb5_3=count_grpPrb5_3+1;
                        
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 1 && rawdata(countRawdata,4) == 2 && groupedFreq(countRawdata,2,a) == 3
                        count_grpPrb5_12=count_grpPrb5_12+1;
                        
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 1 && rawdata(countRawdata,4) == 2 && groupedFreq(countRawdata,2,a) == 4
                        count_grpPrb5_20=count_grpPrb5_20+1;
                        
                        
                        % Grouped probed 12 hz
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 1 && rawdata(countRawdata,4) == 3 && groupedFreq(countRawdata,2,a) == 1
                        count_grpPrb12_3=count_grpPrb12_3+1;
                        
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 1 && rawdata(countRawdata,4) == 3 && groupedFreq(countRawdata,2,a) == 2
                        count_grpPrb12_5=count_grpPrb12_5+1;
                        
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 1 && rawdata(countRawdata,4) == 3 && groupedFreq(countRawdata,2,a) == 4
                        count_grpPrb12_20=count_grpPrb12_20+1;
                        
                        
                        % Grouped probed 20 hz
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 1 && rawdata(countRawdata,4) == 4 && groupedFreq(countRawdata,2,a) == 1
                        count_grpPrb20_3=count_grpPrb20_3+1;
                        
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 1 && rawdata(countRawdata,4) == 4 && groupedFreq(countRawdata,2,a) == 2
                        count_grpPrb20_5=count_grpPrb20_5+1;
                        
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 1 && rawdata(countRawdata,4) == 4 && groupedFreq(countRawdata,2,a) == 3
                        count_grpPrb20_12=count_grpPrb20_12+1;
                        
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%
                        
                        % Grouped not probed 3 hz
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 2 && rawdata(countRawdata,4) == 1 && groupedFreq(countRawdata,2,a) == 2
                        count_grpNoPrb3_5=count_grpNoPrb3_5+1;
                        
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 2 && rawdata(countRawdata,4) == 1 && groupedFreq(countRawdata,2,a) == 3
                        count_grpNoPrb3_12=count_grpNoPrb3_12+1;
                        
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 2 && rawdata(countRawdata,4) == 1 && groupedFreq(countRawdata,2,a) == 4
                        count_grpNoPrb3_20=count_grpNoPrb3_20+1;
                        
                        % Grouped not probed 5 hz
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 2 && rawdata(countRawdata,4) == 2 && groupedFreq(countRawdata,2,a) == 1
                        count_grpNoPrb5_3=count_grpNoPrb5_3+1;
                        
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 2 && rawdata(countRawdata,4) == 2 && groupedFreq(countRawdata,2,a) == 3
                        count_grpNoPrb5_12=count_grpNoPrb5_12+1;
                        
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 2 && rawdata(countRawdata,4) == 2 && groupedFreq(countRawdata,2,a) == 4
                        count_grpNoPrb5_20=count_grpNoPrb5_20+1;
                        
                        % Grouped not probed 12 hz
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 2 && rawdata(countRawdata,4) == 3 && groupedFreq(countRawdata,2,a) == 1
                        count_grpNoPrb12_3=count_grpNoPrb12_3+1;
                        
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 2 && rawdata(countRawdata,4) == 3 && groupedFreq(countRawdata,2,a) == 2
                        count_grpNoPrb12_5=count_grpNoPrb12_5+1;
                        
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 2 && rawdata(countRawdata,4) == 3 && groupedFreq(countRawdata,2,a) == 4
                        count_grpNoPrb12_20=count_grpNoPrb12_20+1;
                        
                        % Grouped not probed 20 hz
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 2 && rawdata(countRawdata,4) == 4 && groupedFreq(countRawdata,2,a) == 1
                        count_grpNoPrb20_3=count_grpNoPrb20_3+1;
                        
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 2 && rawdata(countRawdata,4) == 4 && groupedFreq(countRawdata,2,a) == 2
                        count_grpNoPrb20_5=count_grpNoPrb20_5+1;
                        
                    elseif rawdata(countRawdata,1) == 1 && rawdata(countRawdata,2) == 2 && rawdata(countRawdata,4) == 4 && groupedFreq(countRawdata,2,a) == 3
                        count_grpNoPrb20_12=count_grpNoPrb20_12+1;
                        
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%    
                        
                     % Not Grouped 3Hz
                    elseif rawdata(countRawdata,1) == 2 && rawdata(countRawdata,4) == 1  && groupedFreq(countRawdata,2,a) == 2
                        count_noGrp3_5=count_noGrp3_5+1;
                        
                    elseif rawdata(countRawdata,1) == 2 && rawdata(countRawdata,4) == 1  && groupedFreq(countRawdata,2,a) == 3
                        count_noGrp3_12=count_noGrp3_12+1;
                        
                    elseif rawdata(countRawdata,1) == 2 && rawdata(countRawdata,4) == 1  && groupedFreq(countRawdata,2,a) == 4
                        count_noGrp3_20=count_noGrp3_20+1;
                        
                        
                        % Not Grouped 5Hz
                    elseif rawdata(countRawdata,1) == 2 && rawdata(countRawdata,4) == 2 && groupedFreq(countRawdata,2,a) == 1
                        count_noGrp5_3=count_noGrp5_3+1;
                        
                    elseif rawdata(countRawdata,1) == 2 && rawdata(countRawdata,4) == 2 && groupedFreq(countRawdata,2,a) == 3
                        count_noGrp5_12=count_noGrp5_12+1;
                        
                    elseif rawdata(countRawdata,1) == 2 && rawdata(countRawdata,4) == 2 && groupedFreq(countRawdata,2,a) == 4
                        count_noGrp5_20=count_noGrp5_20+1;
                        
                        
                        % Not Grouped 12Hz
                    elseif rawdata(countRawdata,1) == 2 && rawdata(countRawdata,4) == 3 && groupedFreq(countRawdata,2,a) == 1
                        count_noGrp12_3=count_noGrp12_3+1;
                        
                    elseif rawdata(countRawdata,1) == 2 && rawdata(countRawdata,4) == 3 && groupedFreq(countRawdata,2,a) == 2
                        count_noGrp12_5=count_noGrp12_5+1;
                        
                    elseif rawdata(countRawdata,1) == 2 && rawdata(countRawdata,4) == 3 && groupedFreq(countRawdata,2,a) == 4
                        count_noGrp12_20=count_noGrp12_20+1;
                        
                        % Not Grouped 20Hz
                    elseif rawdata(countRawdata,1) == 2 && rawdata(countRawdata,4) == 4 && groupedFreq(countRawdata,2,a) == 1
                        count_noGrp20_3=count_noGrp20_3+1;
                        
                    elseif rawdata(countRawdata,1) == 2 && rawdata(countRawdata,4) == 4 && groupedFreq(countRawdata,2,a) == 2
                        count_noGrp20_5=count_noGrp20_5+1;
                        
                    elseif rawdata(countRawdata,1) == 2 && rawdata(countRawdata,4) == 4 && groupedFreq(countRawdata,2,a) == 3
                        count_noGrp20_12=count_noGrp20_12+1;
                        
                    end
                end
            end
        end
    end

    % Total the number of trials
    grpPrb_count(a,1) = count_grpPrb3_5;
    grpPrb_count(a,2) = count_grpPrb3_12;
    grpPrb_count(a,3) = count_grpPrb3_20;
    grpPrb_count(a,4) = count_grpPrb5_3;
    grpPrb_count(a,5) = count_grpPrb5_12;
    grpPrb_count(a,6) = count_grpPrb5_20;
    grpPrb_count(a,7) = count_grpPrb12_3;
    grpPrb_count(a,8) = count_grpPrb12_5;
    grpPrb_count(a,9) = count_grpPrb12_20;
    grpPrb_count(a,10) = count_grpPrb20_3;
    grpPrb_count(a,11) = count_grpPrb20_5;
    grpPrb_count(a,12) = count_grpPrb20_12;
    
    grpNoPrb_count(a,1) = count_grpNoPrb3_5;
    grpNoPrb_count(a,2) = count_grpNoPrb3_12;
    grpNoPrb_count(a,3) = count_grpNoPrb3_20;
    grpNoPrb_count(a,4) = count_grpNoPrb5_3;
    grpNoPrb_count(a,5) = count_grpNoPrb5_12;
    grpNoPrb_count(a,6) = count_grpNoPrb5_20;
    grpNoPrb_count(a,7) = count_grpNoPrb12_3;
    grpNoPrb_count(a,8) = count_grpNoPrb12_5;
    grpNoPrb_count(a,9) = count_grpNoPrb12_20;
    grpNoPrb_count(a,10) = count_grpNoPrb20_3;
    grpNoPrb_count(a,11) = count_grpNoPrb20_5;
    grpNoPrb_count(a,12) = count_grpNoPrb20_12;
    
    noGrp_count(a,1) = count_noGrp3_5;
    noGrp_count(a,2) = count_noGrp3_12;
    noGrp_count(a,3) = count_noGrp3_20;
    noGrp_count(a,4) = count_noGrp5_3;
    noGrp_count(a,5) = count_noGrp5_12;
    noGrp_count(a,6) = count_noGrp5_20;
    noGrp_count(a,7) = count_noGrp12_3;
    noGrp_count(a,8) = count_noGrp12_5;
    noGrp_count(a,9) = count_noGrp12_20;
    noGrp_count(a,10) = count_noGrp20_3;
    noGrp_count(a,11) = count_noGrp20_5;
    noGrp_count(a,12) = count_noGrp20_12;
end














