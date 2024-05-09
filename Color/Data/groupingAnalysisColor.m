
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

% fileList = {'MG_wmGrouping_100614_001','CB_wmGrouping_102114_001','KM_wmGrouping_102314_001',...
%     'SR_wmGrouping_102314_001','ZZ_wmGrouping_102414_001','MC_wmGrouping_102414_001','GG_wmGrouping_102714_001',...
%     'CC_wmGrouping_102814_001','JV_wmGrouping_102914_001','AW_wmGrouping_103014_001','TL_wmGrouping_110314_001',...
%     'K001_wmGrouping_110614_001'};
% subjID = {'MG','CB','KM','SR','ZZ','MC','GG','CC','JV','AW','TL','K001'};
fileList = {'K002_wmGrouping_110714_001','K003_wmGrouping_111114_001','MC_wmGrouping_111114_002','ZZ_wmGrouping_111114_002',...
    'KM_wmGrouping_111214_002','KK_wmGrouping_111214_001','K004_wmGrouping_111314_001','NS_wmGrouping_111314_001',...
    'MG_wmGrouping_111414_002','CB_wmGrouping_111414_002','K005_wmGrouping_111414_001','SR_wmGrouping_111914_002',...
    'CC_wmGrouping_112014_002','CR_wmGrouping_112014_001','TL_wmGrouping_120214_002','K006_wmGrouping_120214_001',...
    'AW_wmGrouping_120314_002','MM_wmGrouping_121814_001','GG_wmGrouping_121814_002','K007_wmGrouping_012215_001',...
    'K008_wmGrouping_012315_001','K009_wmGrouping_013015_001','K010_wmGrouping_021015_001'};

subjID = {'K002','K003','MC','ZZ','KM','KK','K004','NS','MG','CB','K005','SR','CC','CR','TL','K006','AW','MM','GG','K007','K008','K009','K010'};
% fileList = {'CC_wmGrouping_091114_001','RC_wmGrouping_091214_001','LL_wmGrouping_091514_001',...
%     'CR_wmGrouping_091514_002','TL_wmGrouping_091614_001'};

inputFile = '/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Color/Data/';

% Load in the usable participants list
load(sprintf('%s%s%s',inputFile,'/usableParticipants'));

% make an index list for each of the usable participants in fileList
counter = 0;
for i = 1:length(fileList)
    if ismember(subjID(i),usableParticipants)
        counter = counter+1;
        subjUsableID(counter) = i;
    end
end

xAxisLabels = {'Grouped Probed','Grouped Non-Probed','Not Grouped'};

counter = 0;
for a=subjUsableID
    
    counter = counter+1;
    
    load(sprintf('%s%s%s%s',inputFile,subjID{a},'/',fileList{a}));
    
    % Calculate accuracy for the three grouping conditions (ignore
    % old/new)
    group(counter,1) = 100*mean(rawdata(and(and(rawdata(:,1)==1,rawdata(:,8)==1),rawdata(:,2)==1),6)==1);
    group(counter,2) = 100*mean(rawdata(and(and(rawdata(:,1)==1,rawdata(:,8)==1),rawdata(:,2)==2),6)==1);
    group(counter,3) = 100*mean(rawdata(and(rawdata(:,1)==2,rawdata(:,8)==1),6)==1);
    
    % HR it was new and they said it was new
    % FAR it was old and they said it was new
    HR(counter,1) = mean(rawdata(and(rawdata(:,1)==1,(and(rawdata(:,2)==1,rawdata(:,3)==1))),5)==1);
    FAR(counter,1) = mean(rawdata(and(rawdata(:,1)==1,(and(rawdata(:,2)==1,rawdata(:,3)==2))),5)==1);
    
    HR(counter,2) = mean(rawdata(and(rawdata(:,1)==1,(and(rawdata(:,2)==2,rawdata(:,3)==1))),5)==1);
    FAR(counter,2) = mean(rawdata(and(rawdata(:,1)==1,(and(rawdata(:,2)==2,rawdata(:,3)==2))),5)==1);
    
    HR(counter,3) = mean(rawdata(and(rawdata(:,1)==2,rawdata(:,3)==1),5)==1);
    FAR(counter,3) = mean(rawdata(and(rawdata(:,1)==2,rawdata(:,3)==2),5)==1);
    
    % Calculate KScores for each conditiong
    KScore(counter,:) = 4*(HR(counter,:)-FAR(counter,:));
    
%     % Precentage of times participant isn't responding
%     responsePrecent(a) = 100*(sum(rawdata(:,8))/length(rawdata));
%     responseNumber(a) = length(rawdata)-sum(rawdata(:,8));
%     disp(responsePrecent(a))
%     disp(responseNumber(a))
    
    figure()
    set(gcf,'numbertitle','off','name',subjID{a}) % See the help for GCF
    % Plots for individuals
    subplot(1,2,1)
    c = group(counter,:);
    bar(c);
    str = {'','Accuracy Average',''}; % cell-array method
    xlabel('Condition','FontSize',15);
    ylabel('Accuracy (% Correct)','FontSize',15);
    set(gca, 'XTickLabel',xAxisLabels, 'XTick',1:numel(xAxisLabels),'ylim',[50,90])
    title(str,'FontSize',15,'FontWeight','bold');
    %     legend(xLabelsAcc);
    
    subplot(1,2,2)
    c = KScore(counter,:);
    bar(c);
    str = {'','Cowan''s K Average',''}; % cell-array method
    xlabel('Grouping Condition','FontSize',15);
    ylabel('Number of Items','FontSize',15);
    set(gca, 'XTickLabel',xAxisLabels, 'XTick',1:numel(xAxisLabels),'ylim',[0,4])
    title(str,'FontSize',15,'FontWeight','bold');
    %     legend(xLabelsAcc);
    
end

figure()
set(gcf,'numbertitle','off','name','Mean') % See the help for GCF

for i=1:3
    meanK(i) = mean(KScore(:,i));
    meanAcc(i) = mean(group(:,i));
    steK(i) = ste(KScore(:,i));
    steAcc(i) = ste(group(:,i));
    
    % Plot accuracy
    subplot(1,2,1)
    c = meanAcc(i);
    b = steAcc(i);
    bar(i,c);
    hold on
    errorbar(i,c,b,'k.','LineWidth',2);
    
    % % Code from barweb.m to align the error bars with the bar groups
    % set(h,'BarWidth',1);    % The bars will now touch each other
    % set(gca,'XTicklabel','Modelo1|Modelo2|Modelo3')
    % set(get(gca,'YLabel'),'String','U')
    % hold on;
    % numgroups = size(c, 1);
    % numbars = size(c, 2);
    % groupwidth = min(0.8, numbars/(numbars+1.5));
    % for i = 1:numbars
    %     % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
    %     x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
    %     errorbar(x, c(:,i), b(:,i), '.k', 'linewidth', 2);
    % end
    %%%%%%%%
    str = {'','Group Accuracy Values',''}; % cell-array method
    xlabel('Grouping Condition','FontSize',15);
    ylabel('Accuracy (% Correct)','FontSize',15);
    set(gca, 'XTickLabel',xAxisLabels, 'XTick',1:numel(xAxisLabels),'ylim',[50,90])
    title(str,'FontSize',15,'FontWeight','bold');
    % legend(xLabelsAcc);
    
    % Plot K Vals
    subplot(1,2,2)
    c = meanK(i);
    b = steK(i);
    bar(i,c);
    hold on
    errorbar(i,c,b,'k.','LineWidth',2);     % Code from barweb.m to align the error bars with the bar groups
    %     set(h,'BarWidth',1);    % The bars will now touch each other
    %     set(gca,'XTicklabel','Modelo1|Modelo2|Modelo3')
    %     set(get(gca,'YLabel'),'String','U')
    %     hold on;
%     numgroups = size(c, 1);
%     numbars = size(c, 2);
%     groupwidth = min(0.8, numbars/(numbars+1.5));
%     for i = 1:numbars
%         % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
%         x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
%         errorbar(x, c(:,i), b(:,i), '.k', 'linewidth', 2);
%     end
%     %%%%%%%%
    str = {'','Group K Values',''}; % cell-array method
    xlabel('Grouping Condition','FontSize',15);
    ylabel('Number of Items','FontSize',15);
    set(gca, 'XTickLabel',xAxisLabels, 'XTick',1:numel(xAxisLabels),'ylim',[0,3])
    title(str,'FontSize',15,'FontWeight','bold');
    % legend(xLabelsAcc);
    
    %     % Number of times participant made no response
    %     subplot(1,3,3)
    %     bar(responseNumber);
    %     str = {'','Number of Times No Response Was Made',''}; % cell-array method
    %     xlabel('Participant','FontSize',15);
    %     ylabel('Number of Trials','FontSize',15);
    %     set(gca, 'XTickLabel',1:length(fileList), 'XTick',1:numel(1:length(fileList)))
    %     title(str,'FontSize',15,'FontWeight','bold');
end

% Looking for significance
[s(1),t(1),ci{1},ts{1}] = ttest(KScore(:,1),KScore(:,2));
[s(2),t(2),ci{2},ts{2}] = ttest(KScore(:,1),KScore(:,3));
[s(3),t(3),ci{3},ts{3}] = ttest(KScore(:,2),KScore(:,3));

[s(4),t(4),ci{4},ts{4}] = ttest(group(:,1),group(:,2));
[s(5),t(5),ci{5},ts{5}] = ttest(group(:,1),group(:,3));
[s(6),t(6),ci{6},ts{6}] = ttest(group(:,2),group(:,3));

% Determine which groups are significantly different then make arrays to
% feed to sigstar function for each comparison and what the p val is
counter = 0;
if s(1) == 1
    counter = counter+1;
    sigArrayGroupsK{counter} = [1,2];
    sigArrayPValK(counter) = t(1);
end
if s(2) == 1
    counter = counter+1;
    sigArrayGroupsK{counter} = [1,3];
    sigArrayPValK(counter) = t(2);
end
if s(3) == 1
    counter = counter+1;
    sigArrayGroupsK{counter} = [2,3];
    sigArrayPValK(counter) = t(3);
end

counter = 0;
if s(4) == 1
    counter = counter+1;
    sigArrayGroupsAcc{counter} = [1,2];
    sigArrayPValAcc(counter) = t(4);
end
if s(5) == 1
    counter = counter+1;
    sigArrayGroupsAcc{counter} = [1,3];
    sigArrayPValAcc(counter) = t(5);
end
if s(6) == 1
    counter = counter+1;
    sigArrayGroupsAcc{counter} = [2,3];
    sigArrayPValAcc(counter) = t(6);
end

%   * represents p<=0.05
%  ** represents p<=0.01
% *** represents p<=0.001
subplot(1,2,1)
sigstar(sigArrayGroupsAcc,sigArrayPValAcc)  % Function used to plot error significance bars and astricks (located in Matlab file)
subplot(1,2,2)
sigstar(sigArrayGroupsK,sigArrayPValK)  % Function used to plot error significance bars and astricks (located in Matlab file)


% Calculate and save an index for each person using there behavioral scores
% for grouped vs not grouped (grouped-not grouped)/(grouped+notgrouped)
for i=1:size(KScore,1)
    % KScore index
    KDiff(i) = KScore(i,1) - KScore(i,3);
    KSum(i) = KScore(i,1) + KScore(i,3);
    KIndex(i) = KDiff/KSum;
    
    % Acc index
    AccDiff(i) = group(i,1) - group(i,3);
    AccSum(i) = group(i,1) + group(i,3);
    AccIndex(i) = AccDiff(i)/AccSum(i);
    
end

save(sprintf('%s%s',inputFile,'behavioralIndex'),'AccIndex','KIndex','KScore','group');




