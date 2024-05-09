% function [tex] = Frequency_Tag_Unilateral_SS4_GC_shapes()
%%%%  RUN EXP 2 AT 120 Hz at 1024 X 768 %%%%%%%%%%%%% See f you can set
%%%%  this in the code

% rawdata(n,1) = 1=grouped 2=no group
% rawdata(n,2) = 1=probed 2=non probed
% rawdata(n,3) = 1=old, 2=new
% rawdata(n,4) = frequency probed F1-F4
% rawdata(n,5) = responded it was 1=old, 2=new
% rawdata(n,6) = did they get it 1=correct or 0=incorrect
% rawdata(n,7) = probe; % which image was probed 1,2,3,4
% rawdata(n,8) = 0=no response, 1=response
% rawdata(n,9) = trial presentation order

clear all
close all

%Flicker Frequency Rates (3 Hz, 5 Hz, 12 Hz, 20 Hz)
stim_rates(1) = 3; %F1
stim_rates(2) = 5; %F2
stim_rates(3) = 12; %F3
stim_rates(4) = 20; %F4

% if statement triggers that allow for netstation comm, timing testing, and
% stim computer compatability
netStation = 0;
timingTester = 0;
labComputer = 1;

%Trial sequence params
trialLength = .995;
delay_period = 1;
intial_square_screen_base_duration = .6;
% Setup the trials
% 2/3 trials are setsize 4; 1/3 set size 2, euql number of old/new for
% each; for setsuze 2: half have 3hz(F1) probe, half have 5hz(F2) probe,
% for setsize 4 1/4 of each F1,F2,F3,F4
% num_trials_set4 = 304;
% num_trials_set2 = num_trials_set4/2;
% numTrials = num_trials_set4+num_trials_set2;
% set_size_list = [2*ones(1,num_trials_set2),...
%                  4*num_trials_set4]; % 2 = set size 2, 4 = setsize 4
% old_new_list = [ones(1,num_trials_set2/2),2*ones(1,num_trials_set2/2),...
%                 ones(1,num_trials_set4/2),2*ones(1,num_trials_set4/2)]; % 1= old, 2 = new
% probe_freq_location_list =[ones(1,num_trials_set2/4),2*ones(1,num_trials_set2/4),ones(1,num_trials_set2/4),2*ones(1,num_trials_set2/4),... % 1 = 3HZ(F1), 2 = 5HZ(F2)
%                            ones(1,num_trials_set4/8),2*ones(1,num_trials_set4/8),3*ones(1,num_trials_set4/8),4*ones(1,num_trials_set4/8),ones(1,num_trials_set4/8),2*ones(1,num_trials_set4/8),3*ones(1,num_trials_set4/8),4*ones(1,num_trials_set4/8)]; % 1 = 3HZ(F1) 2 = 5HZ(F2),3 = 12HZ(F3), 4 = 20HZ(F4)
% trialOrder = randperm(numTrials);


% groupedList = [1 2 3];
groupedList = [1 2];
nGrouped = length(groupedList);
probedList = [1 2];
nProbed = length(probedList);
oldNewList = [1 2];
nOldNew = length(oldNewList);
probeFreqLocList = [1 2 3 4];
nProbeFreqLoc = length(probeFreqLocList);
repetitions = 20;
varList = repmat(fullyfact([nGrouped nProbed nOldNew nProbeFreqLoc]),[repetitions,1]);
numTrials = length(varList);
trialOrder = randperm(numTrials);

%Give subject breaks
break_trials = .1:.1:.9;    % list of proportion of total trials at which to offer subject a self-timed break

if labComputer == 0
    if netStation == 1
        %%%%%%%
        %Netstation communication params
        NS_host = '169.254.180.49'; % ip address of NetStation host computer % *** NEEDS TO BE UPDATED!!!
        NS_port = 55513; % the ethernet port to be used (Default is 55513 for NetStation.m)
        %NS_synclimit = 0.9; % the maximum allowed difference in milliseconds between PTB and NetStation computer clocks (.m default is 2.5)
    end
    
    % Detect and initialize the DAQ for ttl pulses
    d=PsychHID('Devices');
    numDevices=length(d);
    trigDevice=[];
    dev=1;
    while isempty(trigDevice)
        if d(dev).vendorID==2523 && d(dev).productID==130 %if this is the first trigger device
            trigDevice=dev;
            %if you DO have the USB to the TTL pulse trigger attached
            disp('Found the trigger.');
        elseif dev==numDevices
            %if you do NOT have the USB to the TTL pulse trigger attached
            disp('Warning: trigger not found.');
            disp('Check out the USB devices by typing d=PsychHID(''Devices'').');
            break;
        end
        dev=dev+1;
    end
    %   trigDevice=4; %if this doesn't work, try 4
    %Set port B to output, then make sure it's off
    DaqDConfigPort(trigDevice,0,0);
    DaqDOut(trigDevice,0,0);
    TTL_pulse_dur = 0.005; % duration of TTL pulse to account for ahardware lag
end

c = clock;
time_stamp = sprintf('%02d/%02d/%04d %02d:%02d:%02.0f',c(2),c(3),c(1),c(4),c(5),c(6)); % month/day/year hour:min:sec
datecode = datestr(now,'mmddyy');
experiment = 'wmGrouping';

% get input
subjid = input('Enter Subject Code:','s');
runid  = input('Enter Run:');
datadir = '/Users/clab/Documents/CLAB/Kyle/Color/data/';

datafile=sprintf('%s_%s_%s_%03d',subjid,experiment,datecode,runid);
datafile_full=sprintf('%s_full',datafile);

% check to see if this file exists
if exist(fullfile(datadir,[datafile '.mat']),'file')
    tmpfile = input('File exists.  Overwrite? y/n:','s');
    while ~ismember(tmpfile,{'n' 'y'})
        tmpfile = input('Invalid choice. File exists.  Overwrite? y/n:','s');
    end
    if strcmp(tmpfile,'n')
        display('Bye-bye...');
        return; % will need to start over for new input
    end
end

%BASIC WINDOW/SCREEN SETUP
% PPD stuff
mon_width_cm = 40;
mon_dist_cm = 73;
mon_width_deg = 2 * (180/pi) * atan((mon_width_cm/2)/mon_dist_cm);
PPD = (1024/mon_width_deg);

HideCursor;
ListenChar(2);

if netStation == 1
    %Get information about the current screen properties, and what to return
    %the screen to after the experiment.
    oldScreen=Screen('Resolution',0);
    
    %Set the Screen resolution and refresh rate to the values appropriate for
    %your experiment;
    screenWide=1024;
    screenHigh=768;
    screenRefresh=85;
    Screen('Resolution',0,screenWide,screenHigh);
    screenRez = [0 0 screenWide ScreenHigh];
elseif labComputer == 1
    oldScreen=Screen('Resolution',0);
    screenRez = [0 0 oldScreen.width oldScreen.height];
end

Screen('Preference','SyncTestSettings',0.0005, 70, 0.05, 10);
[w, rect] = Screen('Openwindow',0, [128 128 128],screenRez);
hz = 120;
Screen('TextSize',w,24);
% coordinates of screen center
xc = rect(3)/2;
yc = rect(4)/2;
%centers ul_c
corner_centers(1,:)= [xc-xc/2;...
    yc-yc/2;...
    xc-xc/2;...
    yc-yc/2];
%ur_c
corner_centers(2,:)= [xc+xc/2;...
    yc-yc/2;...
    xc+xc/2;...
    yc-yc/2];
%ll_c
corner_centers(3,:)= [xc-xc/2;...
    yc+yc/2;...
    xc-xc/2;...
    yc+yc/2];
%lr_c
corner_centers(4,:)= [xc+xc/2;...
    yc+yc/2;...
    xc+xc/2;...
    yc+yc/2];

% Create the color array
colors = [255 0 0; 0 255 0; 0 0 255; 255 255 0; 255 0 255; 0 255 255];

% Where you can change the stimulus image files, etc. We are loading in 20 where the 1st 10 are black and the second 10 are same-shape white
nimages = 20;
image_tex=[];
for j=1:length(colors)
    for i=1:10
        if netStation == 1
            images=imread(sprintf('%s%d%s','/Users/clab/Documents/CLAB/Kyle/Color/shape_stimuli2/',1,'.tif'));
        elseif labComputer == 1
            images=imread(sprintf('%s%d%s','/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Color/shape_stimuli2/',1,'.tif'));
        end
        images2=images;
        
        for a=1:size(images,1)
            for b=1:size(images,2)
                if images(a,b,1)>60
                    images(a,b,1)=128;
                    images(a,b,2)=128;
                    images(a,b,3)=128;
                    images2(a,b,1)=128;
                    images2(a,b,2)=128;
                    images2(a,b,3)=128;
                else
                    images(a,b,1)=0;
                    images(a,b,2)=0;
                    images(a,b,3)=0;
                    images2(a,b,:)=colors(j,:);
                end
            end
        end
        image_tex(i,j)=Screen('MakeTexture',w,images);
        image_tex(i+10,j)=Screen('MakeTexture',w,images2);
    end
end

if netStation == 1
    images=imread(sprintf('%s%d%s','/Users/clab/Documents/CLAB/Kyle/Color/shape_stimuli2/',1,'.tif'));
elseif labComputer == 1
    images=imread(sprintf('%s%d%s','/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Color/shape_stimuli2/',1,'.tif'));
end
images=images(:,:,1);
images2=images;

for a=1:size(images,1)
    for b=1:size(images,2)
        if images(a,b)>60
            images(a,b)=128;
            images2(a,b)=128;
        else
            images2(a,b)=255;
            images(a,b)=0;
        end
    end
end
image_tex(:,21)=Screen('MakeTexture',w,images);
image_tex(:,22)=Screen('MakeTexture',w,images2);

%Stimulus settings and durations
stim_size = 4*PPD; % Work on converting this to ixels per degree
stim_array = [-stim_size;...
    -stim_size;...
    stim_size;...
    stim_size];
fix_size = 5;
destrect = zeros(4,4);

%For photdiode timing testing
photo_tex = Screen('MakeTexture',w,255*ones(1,1));
if timingTester == 1
    photo_rect=[xc-50,yc-50,xc+50,yc+50];
else
    photo_rect = [0 0 0 0];
end

% fixation spot
% WE need to find blank_rect and fix_rect and put them here
fix_tex = Screen('MakeTexture',w,0*ones(fix_size,fix_size));
if timingTester == 1
    fix_rect=photo_rect;
else
    fix_rect =[xc-fix_size, yc-fix_size, xc+fix_size, yc+fix_size];
end

blank_tex = Screen('MakeTexture',w,128*ones(1,1));



%trial data stuff

% have to preallocate rawdata in order to use the for loop counting by
% trialOrder instead of numTrials
rawdata = zeros(numTrials,9);

%Inputs
buttonO = KbName('o');
buttonN = KbName('n');

%Instructions and Waiting for prticipant to initiate experiment
Screen('TextSize',w,24);
text='Attend to the fixation point that will appear in the center of the screen.';
width=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,xc-width/2,yc-300,[0 0 0]);
text='Four images flashing at different frequencies will appear in four locations on the screen.';
width=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,xc-width/2,yc-250,[0 0 0]);
text='The images will then disappear.';
width=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,xc-width/2,yc-200,[0 0 0]);
text='An image will then appear in one of the four locations on the screen.';
width=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,xc-width/2,yc-150,[0 0 0]);
text='Your task is to determine whether or not the image that appears in the';
width=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,xc-width/2,yc-100,[0 0 0]);
text='location is the same image that was previously shown in that location.';
width=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,xc-width/2,yc-50,[0 0 0]);
text='If the image that appears in the location is old press the "o" key';
width=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,xc-width/2,yc+50,[0 0 0]);
text='If the image that appears in the location is new press the "n" key';
width=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,xc-width/2,yc+100,[0 0 0]);
text='When you are ready to begin tell the experimenter:';
width=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,xc-width/2,yc+200,[0 0 0]);
text='"I am ready to begin"';
width=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,xc-width/2,yc+250,[0 0 0]);
Screen('Flip',w);
KbWait;

if netStation == 1
    NetStation('Connect', NS_host, NS_port)
    % NetStation('Synchronize', NS_synclimit)
    NetStation('StartRecording');
end

misses=0;
missed=1;
counterOrder = 0;

% THIS IS THE ACTUAL EXPERIMENT
while missed
    for n = trialOrder
        
        counterOrder = counterOrder +1;
        rawdata(n,9) = counterOrder;
        
        trial = n; % convert 'i' to the randpermed trial order set above
        
            %put this at the beginning of the trial loop
            this_b = 0;
            for b = break_trials
                if counterOrder == round(b*numTrials)
                    this_b = b;
                    break
                end
            end
            if this_b
                % display break message
                text=sprintf('You have completed %d%% of the trials.',round(b*100));
                width=RectWidth(Screen('TextBounds',w,text));
                Screen('DrawText',w,text,xc-width/2,yc,[255 255 255]);
                text='Press any key when you are ready to continue.';
                width=RectWidth(Screen('TextBounds',w,text));
                Screen('DrawText',w,text,xc-width/2,yc+50,[255 255 255]);
                Screen('Flip',w);
                WaitSecs(1);
                KbWait;
                KbReleaseWait;
            end
        
        % set up indices and rawdata
        groupedIdx = varList(trial,1); % 1= strong 2= weak 3= non grouped
        rawdata(n,1) = groupedIdx;
        probedIdx = varList(trial,2);  % 1=probed  2=not probed 
        rawdata(n,2) = probedIdx;
        oldNewIdx = varList(trial,3); % 1=old 2=new
        rawdata(n,3) = oldNewIdx;
        probeLocIdx = varList(trial,4); % which is probed: 1-4 = F1-F4
        rawdata(n,4) = probeLocIdx;
        
        %Assign each shape to each quadrant
        
        % Randomly determines which location will have what rate
        trial_rates=randperm(4);
        rate(1)=1/(2*stim_rates(trial_rates(1)));
        rate(2)=1/(2*stim_rates(trial_rates(2)));
        rate(3)=1/(2*stim_rates(trial_rates(3)));
        rate(4)=1/(2*stim_rates(trial_rates(4)));
        
        % assure that no image is shown twice at one time
        % because you randomly assign images to im you don't need to
        % randomize image positions
        im(1) = randi(10);
        im(2) = randi(10);
        while im(2) == im(1)
            im(2) = randi(10);
        end
        im(3) = randi(10);
        while im(3) == im(1) || im(3) == im(2)
            im(3) = randi(10);
        end
        im(4) = randi(10);
        while im(4) == im(1) || im(4) == im(2) || im(4) == im(3)
            im(4) = randi(10);
        end
        
        % Randomly choose colors and make sure all are differnt
        co(1) = randi(length(colors));
        co(2) = randi(length(colors));
        while co(2) == co(1)
            co(2) = randi(length(colors));
        end
        co(3) = randi(length(colors));
        while co(3) == co(1) || co(3) == co(2)
            co(3) = randi(length(colors));
        end
        co(4) = randi(length(colors));
        while co(4) == co(1) || co(4) == co(2) || co(4) == co(3)
            co(4) = randi(length(colors));
        end
        
        % checks to see which location(1-4) contains the desired
        % frequency rate, and assings this as the target
        for a=1:4
            if (1/(2*stim_rates(probeLocIdx))) == rate(a)
                target_pos =  a;
            end
        end
        
        texArray(1,1) = image_tex(im(1),co(1));
        texArray(1,2) = image_tex(im(1)+10,co(1));
        texArray(2,1) = image_tex(im(2),co(2));
        texArray(2,2) = image_tex(im(2)+10,co(2));
        texArray(3,1) = image_tex(im(3),co(3));
        texArray(3,2) = image_tex(im(3)+10,co(3));
        texArray(4,1) = image_tex(im(4),co(4));
        texArray(4,2) = image_tex(im(4)+10,co(4));
        
        switch groupedIdx
            case 1
                switch probedIdx
                    case 1
                        % Depending on which location the target is in, choose which
                        % image set will be grouped
                        if target_pos == 1 || target_pos == 3
                            % randomly choose which image (1-3) will be
                            % dublicated
                            if randi(2) == 1;
                                texArray(3,:) = texArray(1,:);
                            else
                                texArray(1,:) = texArray(3,:);
                            end
                            
                        elseif target_pos == 2 || target_pos == 4
                            % randomly choose which image (2-4) will be
                            % dublicated
                            if randi(2) == 1;
                                texArray(4,:) = texArray(2,:);
                            else
                                texArray(2,:) = texArray(4,:);
                            end
                        end
                    case 2
                        % Depending on which location the target is in, choose which
                        % image set will be grouped
                        if target_pos == 1 || target_pos == 3
                            % randomly choose which image (1-2) will be
                            % dublicated
                            if randi(2) == 1;
                                texArray(4,:) = texArray(2,:);
                            else
                                texArray(2,:) = texArray(4,:);
                            end
                        elseif target_pos == 2 || target_pos == 4
                            % randomly choose which image (3-4) will be
                            % dublicated
                            if randi(2) == 1;
                                texArray(3,:) = texArray(1,:);
                            else
                                texArray(1,:) = texArray(3,:);
                            end
                        end
                end
%             case 2
%                 switch probedIdx
%                     case 1
%                         % Depending on which location the target is in, choose which
%                         % image set will be grouped
%                         if target_pos == 1 || target_pos == 4
%                             % randomly choose which image (1-3) will be
%                             % dublicated
%                             if randi(2) == 1;
%                                 texArray(4,:) = texArray(1,:);
%                             else
%                                 texArray(1,:) = texArray(4,:);
%                             end
%                             
%                         elseif target_pos == 2 || target_pos == 3
%                             % randomly choose which image (2-4) will be
%                             % dublicated
%                             if randi(2) == 1;
%                                 texArray(3,:) = texArray(2,:);
%                             else
%                                 texArray(2,:) = texArray(3,:);
%                             end
%                         end
%                     case 2
%                         % Depending on which location the target is in, choose which
%                         % image set will be grouped
%                         if target_pos == 1 || target_pos == 4
%                             % randomly choose which image (1-2) will be
%                             % dublicated
%                             if randi(2) == 1;
%                                 texArray(3,:) = texArray(2,:);
%                             else
%                                 texArray(2,:) = texArray(3,:);
%                             end
%                         elseif target_pos == 2 || target_pos == 3
%                             % randomly choose which image (3-4) will be
%                             % dublicated
%                             if randi(2) == 1;
%                                 texArray(4,:) = texArray(1,:);
%                             else
%                                 texArray(1,:) = texArray(4,:);
%                             end
%                         end
%                 end
        end
        
        flip1 = 1;
        flip2 = 1;
        flip3 = 1;
        flip4 = 1;
        
        %%%%%%%%%DESTINATION RECTACULAR%%%%%%%%%
        
        %randomize (jitter) locations of squares within this quadrant
        for j = 1:4
            % randomly chooses jitter from -50 to 50 in inciments of 10 
%             x_rand = 50-10*randi(10);
%             y_rand = 50-10*randi(10);
            % randomly choose jitter from -10 to 10
            x_rand = 10-randi(20);
            y_rand = 10-randi(20);
            rand_array = [x_rand;...
                y_rand;...
                x_rand;...
                y_rand];
            % put one colored square in each of the quadrants
            destrect(j,:) = (corner_centers(j,:)' + stim_array + rand_array);
        end
        
        destrect_square = destrect + [20 20 -20 -20;20 20 -20 -20;20 20 -20 -20;20 20 -20 -20];
        
        Screen('DrawTexture',w,fix_tex,[],fix_rect);
        %Screen('Flip',w);
        Screen('DrawTexture',w,image_tex(1,nimages+1), [], destrect_square(1,:));
        Screen('DrawTexture',w,image_tex(1,nimages+1), [], destrect_square(2,:));
        Screen('DrawTexture',w,image_tex(1,nimages+1), [], destrect_square(3,:));
        Screen('DrawTexture',w,image_tex(1,nimages+1), [], destrect_square(4,:));
        Screen('Flip',w);
        WaitSecs(intial_square_screen_base_duration+ (.2 * rand() -.1));   %variable +/- 100m
        check = 0;
        
        priorityLevel=MaxPriority(w);
        Priority(priorityLevel);
        
        
        %%%%%%%% draw stimuli to the screen
        
        sync_time = Screen('Flip',w,[],2);
        if labComputer == 0
            DaqDOut(trigDevice,0,2)
            WaitSecs(TTL_pulse_dur);
            DaqDOut(trigDevice,0,0)
        end
        
        Screen('DrawTextures',w,[texArray(1,flip1),...
            texArray(2,flip2),...
            texArray(3,flip3),...
            texArray(4,flip4),fix_tex,photo_tex],...
            [],[destrect(1,:);...
            destrect(2,:);...
            destrect(3,:);...
            destrect(4,:);fix_rect;photo_rect]');
        Screen('DrawingFinished',w);
        run_start=Screen('Flip',w,sync_time,2);
        %             NetStation('Event', stim,GetSecs+.010  ,.010,  'tri#', i, 'type', trial_type, 'hrtz', data{i,2}, 'tpos',target_pos)
        t1 = run_start;
        t2 = t1;
        t3= t1;
        t4=t1;
        %             jjj=2;
        
        
        % You want to probe the location of target_pos
        
        while 1
            time_now = GetSecs;
            %Keep track of flicker rates for ech stimulus
            trial_check = (time_now - run_start) > trialLength;
            
            switch trial_check
                case 0
                    rate1_check = (time_now - t1) > rate(1)-1/hz;
                    rate2_check = (time_now - t2) > rate(2)-1/hz;
                    rate3_check = (time_now - t3) > rate(3)-1/hz;
                    rate4_check = (time_now - t4) > rate(4)-1/hz;
                    switch rate1_check
                        case 1
                            flip1 =  3-flip1;
                            t1=t1+rate(1);
                            check =1;
                        otherwise
                    end
                    switch rate2_check
                        case 1
                            flip2 =  3-flip2;
                            t2=t2+rate(2);
                            check =1;
                        otherwise
                    end
                    switch rate3_check
                        case 1
                            flip3 =  3-flip3;
                            t3=t3+rate(3);
                            check =1;
                        otherwise
                    end
                    switch rate4_check
                        case 1
                            flip4 =  3-flip4;
                            t4=t4+rate(4);
                            check =1;
                        otherwise
                    end
                    
                    %Update changes on the screen
                    
                    switch check
                        
                        case 1
                            %                         switch stim_location
                            %                             case 1
                            Screen('DrawTextures',w,[texArray(1,flip1),...
                                texArray(2,flip2),...
                                texArray(3,flip3),...
                                texArray(4,flip4),fix_tex],...
                                [],[destrect(1,:);...
                                destrect(2,:);...
                                destrect(3,:);...
                                destrect(4,:);fix_rect]');
                            Screen('DrawingFinished',w,2);
                            Screen('Flip',w,2);
                            check=0;
                        case 0
                            WaitSecs(.0005);
                    end
                case 1
                    break
            end
        end
        
        Priority(0);
        
        Screen('DrawTexture',w,blank_tex,[],rect);
        Screen('DrawTexture',w,fix_tex,[],fix_rect);
        Screen('Flip',w);
        
        WaitSecs(delay_period);
        
        % Determine which item will be probed after the trial
        switch oldNewIdx
            case 1
                probe = target_pos;
            case 2
                probe = randi(4);
                while probe == target_pos
                    probe = randi(4);
                end
        end
        
        % Allow participant to answer as soon as the probe is drawn
        t0 = GetSecs;
        time = GetSecs - t0;
        keyisdown = 0;
        if timingTester == 0
            while ~keyisdown && time < 4
                
                if time < 1
                    Screen('DrawTexture',w,texArray(probe,1),[],destrect(target_pos,:));
                else
                    Screen('DrawTexture',w,blank_tex,[],rect);
                end
                Screen('DrawTexture',w,fix_tex,[],fix_rect);
                Screen('Flip',w);
                
                [keyisdown, secs, keycode] = KbCheck;
                WaitSecs(0.001); % CPU Saver
                
                if keycode(buttonO)
                    rawdata(n,5) = 1; % responded it was old
                elseif keycode(buttonN)
                    rawdata(n,5) = 2; % responded it was new
                else
                    keyisdown = 0;
                end
                
                time = secs - t0;
                
            end
            
            % Figure out the accuracy for each trial
            rawdata(n,6) = rawdata(n,3) == rawdata(n,5);
            
            rawdata(n,7) = probe; % which image was probed 1,2,3,4
            rawdata(n,8) = 1;    % 0 for no response 1 for responded
            
            if time >= 4
                
                %NetStation('Event', 'nore',GetSecs+.010  ,.010,  'tri#', i)
                rawdata(n,8) = 0;    % If they didn't respond record 0 here
                %                  NetStation('Event', 'nore',GetSecs+.010  ,.010,  'tri#', i, 'resp', data{i,1},'hrz#', data{i,2}, 'stim', stim)
                %                 recog_data{i,3}='No Response';
                
                Screen('TextSize',w,24);
                text='You did not make your response in time.';
                width=RectWidth(Screen('TextBounds',w,text));
                Screen('DrawText',w,text,xc-width/2,yc-50,[0 0 0]);
                text='Press any key to continue...';
                width=RectWidth(Screen('TextBounds',w,text));
                Screen('DrawText',w,text,xc-width/2,yc,[0 0 0]);
                Screen('Flip',w);
                
                KbWait;
                KbReleaseWait;
            end
        end
        
        WaitSecs(0.5);
        %pause;
        
        Screen('DrawTexture',w,fix_tex,[],fix_rect);
        Screen('Flip',w);
        
        % Create an array that is built from the trials in which no response was
        % given
        if rawdata(n,8) == 0
            misses = misses+1;
            noResponseArray(misses) = n;
        end
        
        imraw (n,:) = im;
        coraw(n,:) = co;
        save(sprintf('%s%s',datadir,datafile),'rawdata','imraw');
        
    end
    if misses==0
        missed=0;
    else
        misses=0;
        trialOrder=noResponseArray;
    end
end

rawdata = sortrows(rawdata,9);


save(sprintf('%s%s',datadir,datafile),'rawdata','imraw');
save(datafile_full);

ListenChar(0);
ShowCursor;
Screen('CloseAll')

if netStation == 1
    NetStation('StopRecording');
    % NetStation('Synchronize', NS_synclimit
    NetStation('Disconnect');
end



% rawdata(n,1) = 1=grouped 2=no group
% rawdata(n,2) = 1=probed 2=non probed
% rawdata(n,3) = 1=old, 2=new
% rawdata(n,4) = frequency probed F1-F4
% rawdata(n,5) = responded it was 1=old, 2=new
% rawdata(n,6) = did they get it 1=correct or 0=incorrect
% rawdata(n,7) = probe; % which image was probed 1,2,3,4
% rawdata(n,8) = 0=no response, 1=response
% rawdata(n,9) = trial presentation order





