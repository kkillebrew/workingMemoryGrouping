
% rawdata(n,1) = 1=grouped probed, 2=grouped not probed, 3=not grouped
% rawdata(n,2) = 1=old, 2=new
% rawdata(n,3) = frequency probed F1-F4
% rawdata(n,4) = responded it was 1=old, 2=new
% rawdata(n,5) = did they get it 1=correct or 0=incorrect
% rawdata(n,6) = probe; % which image was probed 1,2,3,4
% rawdata(n,7) = 0=no response, 1=response

close all;
clear all;

fileList = {'CC_wmGrouping_091114_001','RC_wmGrouping_091214_001','LL_wmGrouping_091514_001',...
    'CR_wmGrouping_091514_002','TL_wmGrouping_091614_001','LK_wmGrouping_091614_001',...
    'VG_wmGrouping_091814_001'};
% fileList = {'CC_wmGrouping_091114_001','RC_wmGrouping_091214_001','LL_wmGrouping_091514_001',...
%     'CR_wmGrouping_091514_002','TL_wmGrouping_091614_001'};

inputFile = '/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Freq_tag_code/data/';

xAxisLabels = {'Grouped Probed','Grouped Non-Probed','Not Grouped'};

for a=1:length(fileList)
    
    load(sprintf('%s%s',inputFile,fileList{a}));
    
    % Calculate accuracy for the three grouping conditions (ignore
    % old/new)
    group(a,1) = 100*mean(rawdata(and(rawdata(:,1)==1,rawdata(:,7)==1),5)==1);
    group(a,2) = 100*mean(rawdata(and(rawdata(:,1)==2,rawdata(:,7)==1),5)==1);
    group(a,3) = 100*mean(rawdata(and(rawdata(:,1)==3,rawdata(:,7)==1),5)==1);
    
    % HR it was new and they said it was new
    % FAR it was old and they said it was new
    HR(a,1) = mean(rawdata(and(rawdata(:,1)==1,(and(rawdata(:,2)==1,rawdata(:,7)==1))),4)==1);
    FAR(a,1) = mean(rawdata(and(rawdata(:,1)==1,(and(rawdata(:,2)==2,rawdata(:,7)==1))),4)==1);
    
    HR(a,2) = mean(rawdata(and(rawdata(:,1)==2,(and(rawdata(:,2)==1,rawdata(:,7)==1))),4)==1);
    FAR(a,2) = mean(rawdata(and(rawdata(:,1)==2,(and(rawdata(:,2)==2,rawdata(:,7)==1))),4)==1);
    
    HR(a,3) = mean(rawdata(and(rawdata(:,1)==3,(and(rawdata(:,2)==1,rawdata(:,7)==1))),4)==1);
    FAR(a,3) = mean(rawdata(and(rawdata(:,1)==3,(and(rawdata(:,2)==2,rawdata(:,7)==1))),4)==1);
    
    % Calculate KScores for each conditiong
    KScore(a,:) = 4*(HR(a,:)-FAR(a,:));
    
    % Precentage of times participant isn't responding
    responsePrecent(a) = 100*(sum(rawdata(:,7))/length(rawdata));
    responseNumber(a) = length(rawdata)-sum(rawdata(:,7));
    disp(responsePrecent(a))
    disp(responseNumber(a))
    
    figure()
    % Plots for individuals
    subplot(1,2,1)
    c = group(a,:);
    bar(c);
    str = {'','Accuracy Average',''}; % cell-array method
    xlabel('Grouping Condition','FontSize',15);
    ylabel('Accuracy','FontSize',15);
    set(gca, 'XTickLabel',xAxisLabels, 'XTick',1:numel(xAxisLabels),'ylim',[0,100])
    title(str,'FontSize',15,'FontWeight','bold');
    %     legend(xLabelsAcc);
    
    subplot(1,2,2)
    c = KScore(a,:);
    bar(c);
    str = {'','Cowan''s K Average',''}; % cell-array method
    xlabel('Grouping Condition','FontSize',15);
    ylabel('Cowan''s K','FontSize',15);
    set(gca, 'XTickLabel',xAxisLabels, 'XTick',1:numel(xAxisLabels),'ylim',[0,4])
    title(str,'FontSize',15,'FontWeight','bold');
    %     legend(xLabelsAcc);
    
end

figure()

for i=1:3
    meanK(i) = mean(KScore(:,i));
    meanAcc(i) = mean(group(:,i));
    steK(i) = ste(KScore(:,i));
    steAcc(i) = ste(group(:,i));
    
    
    % Plot K Vals and accuracy
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
    ylabel('Accuracy','FontSize',15);
    set(gca, 'XTickLabel',xAxisLabels, 'XTick',1:numel(xAxisLabels),'ylim',[0,100])
    title(str,'FontSize',15,'FontWeight','bold');
    % legend(xLabelsAcc);
    
    % Plot K Vals and accuracy
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
    ylabel('Cowan''s K','FontSize',15);
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













