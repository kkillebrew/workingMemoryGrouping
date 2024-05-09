close all
clear all

inputFile = '/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Color/Data/';

load(sprintf('%s%s',inputFile,'usableParticipants.mat'))
load(sprintf('%s%s',inputFile,'finalIndex.mat'))

% % Right and left occipital elec
% elecGroup{1} = [118 109 98  86 85 97 108 117 125 116 107 96 84 95 106 115 124 136 123 114 105 104 113 122 135];
% elecGroup{2} = [127 140 152 162 171 161 151 139 138 150 160 170 179 178 169 159 149 148 158 168 177 189 176 167 157];
% % Right and left parietal elec
% elecGroup{3} = [9 45 80 89 100 110 44 53 79 88 99 52 60 78 87 51 59 66 77 58 65 72 57 64 71 76 63 70 75];
% elecGroup{4} = [186 132 185 144 131 184 155 143 130 129 142 154 164 183 196 195 182 173 163 153 141 128 172 181 194 204 203 193 180];
% % Right and left frontal elec
% elecGroup{5} = [17 16 24 43 23 30 42 22 29 36 41 50 49 40 35 28 27 34 39 48 56];
% elecGroup{6} = [198 197 207 7 206 215 6 14 5 224 214 205 213 223 4 13 20 12 3 222 212];
% % Create arrays for medial-lateral groups and for anterior-posterior groups
% % 1=left 2=mid 3=right
% medLatGroup{1} = [34 39 48 56 49 40 35 36 41 50 42 52 60 78 66 59 51 58 65 72 77 87 76 71 64 57 63 70 75 98 86 108 97 85 84 96 107 95 106 115 123 114 105 104 113 122];
% medLatGroup{2} = [27 20 28 21 13 5 14 22 29 30 23 15 6 215 197 207 7 16 24 43 17 18 198 9 186 132 81 45 9 44 53 80 90 131 144 185 143 130 89 79 88 100 101 129 142 141 128 115 110 99 109 118 127 140 117 126 139 150 138 125 116 124 137 149 148 136 135 147 157];
% medLatGroup{3} = [12 3 222 212 4 223 213 224 214 205 206 203 193 180 204 194 181 172 153 163 173 182 195 196 183 164 154 155 184 152 162 151 161 171 179 170 160 159 169 178 177 168 158 167 176 189];
% % 1=occ 2=par 3=front
% antPostGroup{1} = [elecGroup{1}  elecGroup{2} 126 137 147];
% antPostGroup{2} = [elecGroup{3}  elecGroup{4} 81 90 101 119];
% antPostGroup{3} = [elecGroup{5}  elecGroup{6} 8 15 21];

% Right, mid and left occipital elec
elecGroup{1} = [98  86 85 97 108 107 96 84 95 106 115 123 114 105 104 113 122];
elecGroup{2} = [118 109 117 125 116 124 136 135 126 137 147 127 140 139 138 150 149 148 157];
elecGroup{3} = [152 162 171 161 151 160 170 179 178 169 159 158 168 177 189 176 167];

% Right, mid and left parietal elec
elecGroup{4} = [52 60 78 87 51 59 66 77 58 65 72 57 64 71 76 63 70 75];
elecGroup{5} = [9 44 45 53 80 79 89 88 100 99 110 81 90 101 115 186 185 132 144 131 143 130 129 128 141];
elecGroup{6} = [184 155 142 154 164 183 196 195 182 173 163 153 172 181 194 204 203 193 180];

% Right, mid and left frontal elec
elecGroup{7} = [42 36 41 50 49 40 35 34 39 48 56];
elecGroup{8} = [20 13 14 5 6 7 214 207 198 197 21 15 8 27 28 22 29 23 30 16 24 43 17];
elecGroup{9} = [206 215 224 205 213 223 4 12 3 222 212];

% Title for bar graph
elecGroupName = {'Occ Left', 'Occ Medial', 'Occ Right', 'Par Left', 'Par Medial', 'Par Right', 'Front Left', 'Front Medial', 'Front Right'};
freqGroupName = {'1f1+1f2', '1f1+2f2', '2f1+1f2', '2f1+2f2'};

% Create new array for the ANOVA function
for k=1:size(combGroupIndex,2)
    counter = 0;
    for i=1:size(combGroupIndex,1)
        for j=1:size(combGroupIndex,3)
            counter = counter+1;
            anovaArray(counter,1,k) = combGroupIndex(i,k,j);
            anovaArray(counter,2,k) = combNogroupIndex(i,k,j);
        end
    end
    % P-vector of p-vals for testing column, row and interaction effects
    % T-table containing contents of the ANOVA table
    % S-usefull stats
    [anovaP{k}, anovaT{k}, anovaS{k}] = anova2(anovaArray(:,:,k),20);
    
    [compare{k}, meanMult{k}, hMult{k}, gnamesMult{k}] = multcompare(anovaS{k});
end

% Preform an ANOVA using electrode groups
for k=1:size(combGroupIndex,2)
    counter = 0;
    for p=1:2
        for j=1:size(combGroupIndex,3)
            %         counter = 0;
            for i=1:length(elecGroup)
                for m=1:length(elecGroup{i})
                    %                 counter = counter+1;
                    
                    % Create an array for the MANOVA function. Lists all the
                    % electrodes for each electrode group for all subjects for
                    % each condition for each frequency combination.
                    % anovaArrayElec(counter,j,1,k) = combGroupIndex(elecGroup{i}(m),k,j);
                    % anovaArrayElec(counter,j,2,k) = combNogroupIndex(elecGroup{i}(m),k,j);
                    
                    % Create a corresponding array with each row representing
                    % the group that the corresponding row in anovaArrayElec
                    % belongs to.
                    % groupingArray(counter,j,1,k) = i;
                    
                    % Create arrays that average across electrodes in each
                    % individual group
                    if p==1
                        anovaArrayElecHolder(m) = combGroupIndex(elecGroup{i}(m),k,j);
                    elseif p==2
                        anovaArrayElecHolder(m) = combNogroupIndex(elecGroup{i}(m),k,j);
                    end
                end
                counter = counter+1;
                anovaArrayElec(counter,k) = mean(anovaArrayElecHolder);
                
                % Create cells that correspond to the values in the array
                groupingFactor(counter,k) = p;
                elecGroupFactor(counter,k) = i;
                subjFactor(counter,k) = j;
            end
        end
    end
    
    %     [anovaGroupP{k}, anovaGroupT{k}, anovaGroupS{k}] = anova2(anovaArrayElec(:,:,k),20);
    
    % Preform the anova using the 6 different electrode clusters
    
    %     P=anovan(Y,GROUP) performs multi-way (n-way) anova on the vector Y
    %     grouped by entries in the cell array GROUP.  Each cell of GROUP must
    %     contain a grouping variable that can be a categorical variable, numeric
    %     vector, character matrix, or single-column cell array of strings.
    %     Each grouping variable must have the same number of items as Y.  The
    %     fitted anova model includes the main effects of each grouping variable.
    %     All grouping variables are treated as fixed effects by default.  The
    %     result P is a vector of p-values, one per term.
    [anovaGroupP{k}, anovaGroupT{k}, anovaGroupS{k}] = anovan(anovaArrayElec(:,k),[groupingFactor(:,k),elecGroupFactor(:,k)],'model',3,'varnames',{'Grouping','Elec Cluster'});
    stats{k} = rm_anova2(anovaArrayElec(:,k),subjFactor(:,k),groupingFactor(:,k),elecGroupFactor(:,k),{'Grouping','Elec Cluster'});

%     % Plot the graphs for the two conditions for each area in the anova and
%     % for each frequency combo
    counter = 0;
    for m=1:2
        for i=1:size(combGroupIndex,3)
            for j=1:length(elecGroup)
                counter = counter+1;
                if groupingFactor(counter,k) == 1   % Group
                    holderElecGroup(j,i,m,k) = anovaArrayElec(counter,k);
                elseif groupingFactor(counter,k) == 2
                    holderElecGroup(j,i,m,k) = anovaArrayElec(counter,k);
                end
            end
        end
    end
    meanElecGroup = mean(holderElecGroup,2);
    steElecGroup = ste(holderElecGroup,2);
%     
%     
    figure()
    for i=1:length(elecGroup)
        
        % Preform ttest on each set
        [s{i,k}, t{i,k}, ci{i,k}, ts{i,k}] = ttest(holderElecGroup(i,:,1,k),holderElecGroup(i,:,2,k));
        
        % Make arrays to determine which groups are sig different
        sigArrayCheck = 0;
        if s{i,k} == 1
            sigArrayCheck = 1;
            sigArray{i} = [1 2];
            sigArrayT(i) = t{i,k};
        end
        
        
        subplot(3,3,i)
        set(gcf,'numbertitle','off','name',freqGroupName{k}) % See the help for GCF
        bar([meanElecGroup(i,:,1,k),meanElecGroup(i,:,2,k)])
        hold on
        errorbar([meanElecGroup(i,:,1,k),meanElecGroup(i,:,2,k)],[steElecGroup(i,:,1,k),steElecGroup(i,:,2,k)],'.k')
        title(elecGroupName{i});
        set(gca, 'ylim',[.4,.6])
        
        %   * represents p<=0.05
        %  ** represents p<=0.01
        % *** represents p<=0.001
        if sigArrayCheck == 1
            sigstar(sigArray{i},sigArrayT(i))  % Function used to plot error significance bars and astricks (located in Matlab file)
        end
        
    end  
    
%     % Create arrays to test for laterality and ant-post interactions
%     for l=1:2
%         counter=0;
%         for p=1:2
%             for j=1:size(combGroupIndex,3)
%                 if l==1
%                     groupLengthHolder1 = length(medLatGroup);
%                 elseif l==2
%                     groupLengthHolder1 = length(antPostGroup);
%                 end
%                 for i=1:groupLengthHolder1
%                     if l==1
%                         groupLengthHolder2 = length(medLatGroup{i});
%                     elseif l==2
%                         groupLengthHolder2 = length(antPostGroup{i});
%                     end
%                     for m=1:groupLengthHolder2
%                         if l==1
%                             medLatArrayHolder(m) = combGroupIndex(medLatGroup{i}(m),k,j);
%                         elseif l==2
%                             antPostArrayHolder(m) = combGroupIndex(antPostGroup{i}(m),k,j);
%                         end
%                     end
%                     if l==1
%                         counter = counter+1;
%                         medLatArray(counter,k) = mean(medLatArrayHolder);
%                         groupingFactorMedLat(counter,k) = p;
%                         medLatFactor(counter,k) = i;
%                     elseif l==2
%                         counter = counter+1;
%                         antPostArray(counter,k) = mean(antPostArrayHolder);
%                         groupingFactorAntPost(counter,k) = p;
%                         antPostFactor(counter,k) = i;
%                     end
%                 end
%             end
%         end
%     end
%     
%     % Do the anova for laterality and ant-post
%     [medLatP{k}, medLatT{k}, medLatS{k}] = anovan(medLatArray(:,k),[groupingFactorMedLat(:,k),medLatFactor(:,k)],'model',3,'varnames',{'Grouping','Med-Lat'});
%     [antPostP{k}, antPostT{k}, antPostS{k}] = anovan(antPostArray(:,k),[groupingFactorAntPost(:,k),antPostFactor(:,k)],'model',3,'varnames',{'Grouping','Ant-Post'});
%     
%     
%     % Plot the graphs for ant-post and med-lat for the 2 groups
%     
%     counter = 0;
%     for m=1:2
%         for i=1:size(combGroupIndex,3)
%             if l==1
%                 groupLengthHolder = length(medLatGroup);
%             elseif l==2
%                 groupLengthHolder = length(antPostGroup);
%             end
%             for j=1:groupLengthHolder
%                 if l==1
%                     counter = counter+1;
%                     if groupingFactorMedLat(counter,k) == 1   % Group
%                         medLatHolder(j,i,m,k) = medLatArray(counter,k);
%                     elseif groupingFactorMedLat(counter,k) == 2
%                         medLatHolder(j,i,m,k) = medLatArray(counter,k);
%                     end
%                 elseif l==2
%                     counter = counter+1;
%                     if groupingFactorAntPost(counter,k) == 1   % Group
%                         antPostHolder(j,i,m,k) = antPostArray(counter,k);
%                     elseif groupingFactorAntPost(counter,k) == 2
%                         antPostHolder(j,i,m,k) = antPostArray(counter,k);
%                     end
%                 end
%             end
%         end
%     end
%     meanMedLat = mean(medLatHolder,2);
%     steMedLat = ste(medLatHolder,2);
%     meanMedLat = mean(medLatHolder,2);
%     steMedLat = ste(medLatHolder,2);
    
end








