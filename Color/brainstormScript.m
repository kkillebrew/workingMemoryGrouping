clear all

% Start brainstorm if it isn't started already
if ~brainstorm('status')
    brainstorm nogui
else
    brainstorm stop
    brainstorm nogui
end

% ===== CREATE/LOAD PROTOCOL =====

% All of this is usefull information about the brainstorm protocols,
% directies and default settings
global GlobalData;
% Get ProtocolsListInfo structure
sProtocolsListInfo     = GlobalData.DataBase.ProtocolInfo; % List of protocols names and dirs
sProtocolsListSubjects = GlobalData.DataBase.ProtocolSubjects;
sProtocolsListStudies  = GlobalData.DataBase.ProtocolStudies;
isProtocolLoaded       = GlobalData.DataBase.isProtocolLoaded; % Which protocol is currently loaded as compared to protocol list
isProtocolModified     = GlobalData.DataBase.isProtocolModified;
nbProtocols = length(sProtocolsListInfo);  % Number of protocols

% Display which protocols are available
sProtocolsListInfo.Comment

% The protocol name has to be a valid folder name (no spaces, no weird characters...)
protocolName = input('Enter Protocol Name:','s');

% Check to see if the protocol exists
if ~any(strcmpi(protocolName, {sProtocolsListInfo.Comment}))
    
    % ===== USEFUL BRAINSTORM COMMANDS =====
    % Will check to see if there are any protocols
    % bst_get('iProtocol');
    
    % Add the protocol to Brainstorm database
    % iProtocol = db_edit_protocol('create', sProtocol);
    
    % Get Brainstorm directory
    % DbDir = bst_get('BrainstormDbDir');
    
    % Create new protocol
    % iProtocol = gui_brainstorm('CreateProtocol', ProtocolName, UseDefaultAnat, UseDefaultChannel)
    gui_brainstorm('CreateProtocol',protocolName,0,1);
    
    % If the protocol already exists find its index number and load it in
else
    gui_brainstorm('SetCurrentProtocol',find(strcmpi(protocolName, {sProtocolsListInfo.Comment})));
    
    % Make sure the protocol list is up to date
    gui_brainstorm('UpdateProtocolsList');
    
    % Set the value of the new protocal
    protocolNumber = GlobalData.DataBase.iProtocol;
end

% ===== LOAD/CREATE SUBJECT =====

% Get protocol description
ProtocolInfo     = bst_get('ProtocolInfo');
ProtocolSubjects = bst_get('ProtocolSubjects');
nbSubjects = length(ProtocolSubjects.Subject);

% Create new subjects
{ProtocolSubjects.Subject.Name}
while 1
    addNew = input('Add new subject?:','s');
    if strcmp(addNew,'y')
        subjectName = input('Enter Subject Name:','s');
        db_add_subject(subjectName, [],0,1)
    elseif strcmp(addNew,'n')
        break
    end
end


% Update protocol description
ProtocolInfo     = bst_get('ProtocolInfo');
ProtocolSubjects = bst_get('ProtocolSubjects');
nbSubjects = length(ProtocolSubjects.Subject);

% Which Subject do you want to edit
% Allow to load in all subjects ***
{ProtocolSubjects.Subject.Name}
disp('a for all \n');
whcihSubj = {};
whichSubj = input('Which Subject do you want to load in?:','s');
while 1
    if find(strcmpi(whichSubj, {ProtocolSubjects.Subject.Name}))
        whichSubj = {ProtocolSubjects.Subject(strcmp({ProtocolSubjects.Subject.Name},whichSubj)).Name};
        subjectNumber(1) = find(strcmpi(whichSubj, {ProtocolSubjects.Subject.Name}));
        numSubjs = 1;
        break;
    end
    if strcmpi(whichSubj, 'a')
        whichSubj = {ProtocolSubjects.Subject.Name};
        numSubjs = length(whichSubj);
        for l=1:numSubjs
            subjectNumber(l) = find(strcmpi(whichSubj(l), {ProtocolSubjects.Subject.Name}));
        end
        break;
    end
end

% ===== IMPORT DATA =====
% Set the dir of the data set

% List the conditions
% conditionList = {'grpPrbdOld','notGrpPrbdOld','grpNotPrbdOld','notGrpNotPrbdOld','grpPrbdNew',...
%     'notGrpPrbdNew','grpNotPrbdNew','notGrpNotPrbdNew'};
% conditionListSeg = {'grpPrbdOld_SEG','notGrpPrbdOld_SEG','grpNotPrbdOld_SEG','notGrpNotPrbdOld_SEG','grpPrbdNew_SEG',...
%     'notGrpPrbdNew_SEG','grpNotPrbdNew_SEG','notGrpNotPrbdNew_SEG'};
conditionList = {'grpPrb3','grpPrb5','grpPrb12','grpPrb20',...
    'grpNoPrb3','grpNoPrb5','grpNoPrb12','grpNoPrb20',...
    'noGrp3','noGrp5','noGrp12','noGrp20',};
conditionListSeg = {'grpPrb3_SEG','grpPrb5_SEG','grpPrb12_SEG','grpPrb20_SEG',...
    'grpNoPrb3_SEG','grpNoPrb5_SEG','grpNoPrb12_SEG','grpNoPrb20_SEG',...
    'noGrp3_SEG','noGrp5_SEG','noGrp12_SEG','noGrp20_SEG',};

% [template] = db_template(structureName);
% template = struct(...
%             'ImportMode',       'Epoch', ...           % Import mode:  {Epoch, Time, Event}
%             'UseEvents',        0, ...                 % {0,1}: If 1, perform epoching around the selected events
%             'TimeRange',        [], ...                % Specifying a time window for 'Time' import mode
%             'EventsTimeRange',  [-0.1000 0.3000], ...  % Time range for epoching, zero is the event onset (if epoching is enabled)
%             'GetAllEpochs',     0, ...                 % {0,1}: Import all arrays, no matter how many they are
%             'iEpochs',          1, ...                 % Array of indices of epochs to import (if GetAllEpochs is not enabled)
%             'SplitRaw',         0, ...                 % {0,1}: If 1, and if importing continuous recordings (no epoching, no events): split recordings in small time blocks
%             'SplitLength',      2, ...                 % Duration of each split time block, in seconds
%             'Resample',         0, ...                 % Enable resampling (requires Signal Processing Toolbox)
%             'ResampleFreq',     0, ...                 % Resampling frequency (if resampling is enabled)
%             'UseCtfComp',       1, ...                 % Get and apply CTF 3rd gradient correction if available
%             'UseSsp',           1, ...                 % Get and apply SSP (Signal Space Projection) vectors if available
%             'RemoveBaseline',   'no', ...              % Method used to remove baseline of each channel: {no, all, time, sample}
%             'BaselineRange',    [], ...                % [tStart,tStop] If RemoveBaseline is 'time'; Else ignored
%             'events',           [], ...                % Events structure: (label, epochs, samples, times, reactTimes, select)
%             'CreateConditions', 1, ...                 % {0,1} If 1, create new conditions in Brainstorm database if it is more convenient
%             'ChannelReplace',   1, ...        % If 1, prompts for automatic replacement of an existing channel file. If 2, replace it automatically. If 0, do not do it.
%             'ChannelAlign',     1, ...        % If 1, prompts for automatic registration. If 2, perform it automatically. If 0, do not do it.
%             'IgnoreShortEpochs',1, ...        % If 1, prompts for ignoring the epochs that are shorter that the others. If 2, ignore them automatically. If 0, do not do it.
%             'EventsMode',       'ask', ...    % Where to get the events from: {'ask', 'ignore', Filename, ChannelName, ChannelNames}
%             'EventsTrackMode',  'ask', ...    % {'value','bit','ask'}   - 4D/BTi only
%             'DisplayMessages',  0);

% Run for all subjects and update subjectNum, whichSubject to allow for
% arrays ***
% Add the conditions
for a=1:numSubjs
    for i=1:length(conditionList)
        %     db_add_condition(whichSubj, conditionList{i},1);
        % Set the dir of the data set
        %     importOptionsTemp = db_template('importoptions');
        %     importOptionsTemp.DisplayMessages = 0;
        dataName{i} = {sprintf('%s%s%s%s%s','/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Color/Data/',whichSubj{a},'/',conditionList{i},'.mat')};
        import_data(dataName{i},[],'EEG-MAT',[],subjectNumber(a),[]);
        
        sFiles = sprintf('%s%s%s%s%s%s',whichSubj{a},'/',conditionList{i},'/data_',conditionList{i},'.mat');
        
        %     % Start a new report
        %     bst_report('Start', sFiles);
        
        % Segment the data into individual trials
        % Process: Import MEG/EEG: Time
        sFiles = bst_process('CallProcess', 'process_import_data_time', ...
            sFiles, [], ...
            'subjectname', whichSubj{a}, ...
            'condition', conditionListSeg{i}, ...
            'timewindow', [], ...
            'split', 1.1, ...
            'usectfcomp', 1, ...
            'usessp', 1, ...
            'freq', [], ...
            'baseline', []);
        
        % Average trials within each condition within each subject
        % Record the filenames for each of the file paths
        filePathsSegments{i} = sFiles;
        % Make new variable to hold the list of files to be averaged for each
        % condition ---- Add for each subject as well
        aFiles = {};
        for j=1:length(filePathsSegments{i})
            aFiles{j} = filePathsSegments{i}(j).FileName;
        end
        aFiles = aFiles';
        
        % Process: Average: By condition (subject average)
        aFiles = bst_process('CallProcess', 'process_average', ...
            aFiles, [], ...
            'avgtype', 3, ...
            'avg_func', 1, ...  % Arithmetic average: mean(x)
            'keepevents', 0);
        
        % Preform the FFT
        % Save the outputs of the averageing function
        filePathsAverage{i} = aFiles;
        % Make new variable to hold the list of files to be averaged for each
        % condition ---- Add for each subject as well
        bFiles = {};
        bFiles = filePathsAverage{i}.FileName;
        
        % Baseline correction
        % Process: Remove DC offset: [0ms,100ms]
        bFiles = bst_process('CallProcess', 'process_baseline', ...
            bFiles, [], ...
            'baseline', [0, 0.1], ...
            'sensortypes', 'EEG', ...
            'overwrite', 0);
        
        filePathsBaseline{i} = bFiles;
        
        % FFT
        fFiles = {};
        fFiles = filePathsBaseline{i}.FileName;
        %     fFiles = fFiles';
        
        % Process: Fourier transform (FFT)
        fFiles = bst_process('CallProcess', 'process_fft', ...
            fFiles, [], ...
            'timewindow', [], ...
            'clusters', {}, ...
            'isvolume', 0, ...
            'sensortypes', 'MEG, EEG', ...
            'avgoutput', 1);
        
        %     % Save and display report
        %     ReportFile = bst_report('Save', sFiles);
        %     bst_report('Open', ReportFile);
        
        
    end
end




brainstorm stop





