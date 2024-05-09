% function [tex] = Frequency_Tag_Unilateral_SS4_GC_shapes()
%%%%  RUN EXP 2 AT 120 Hz at 1024 X 768 %%%%%%%%%%%%% See f you can set
%%%%  this in the code

clear
%Flicker Frequency Rates (3 Hz, 5 Hz, 12 Hz, 20 Hz)
stim_rate(1) = 3; %F1
stim_rate(2) = 5; %F2
stim_rate(3) = 12; %F3
stim_rate(4) = 20; %F4

%Trial sequence params
delay_period = 1;
intial_square_screen_base_duration = 0.6;
% Setup the trials
% 2/3 trials are setsize 4; 1/3 set size 2, euql number of old/new for
% each; for setsuze 2: half have 3hz(F1) probe, half have 5hz(F2) probe,
% for setsize 4 1/4 of each F1,F2,F3,F4
num_trials_set4 = 304; 
num_trials_set2 = num_trials_set4/2;
num_trials = num_trials_set4+num_trials_set2;
set_size_list = [2*ones(1,num_trials_set2),...
                 4*ones(1,num_trials_set4)]; % 2 = set size 2, 4 = setsize 4
old_new_list = [ones(1,num_trials_set2/2),2*ones(1,num_trials_set2/2),...
                ones(1,num_trials_set4/2),2*ones(1,num_trials_set4/2)]; % 1= old, 2 = new
probe_freq_list =[ones(1,num_trials_set2/4),2*ones(1,num_trials_set2/4),ones(1,num_trials_set2/4),2*ones(1,num_trials_set2/4),... % 1 = 3HZ(F1), 2 = 5HZ(F2)
                           ones(1,num_trials_set4/8),2*ones(1,num_trials_set4/8),3*ones(1,num_trials_set4/8),4*ones(1,num_trials_set4/8),ones(1,num_trials_set4/8),2*ones(1,num_trials_set4/8),3*ones(1,num_trials_set4/8),4*ones(1,num_trials_set4/8)]; % 1 = 3HZ(F1) 2 = 5HZ(F2),3 = 12HZ(F3), 4 = 20HZ(F4)

trial_order = randperm(num_trials);
%Give subject breaks
break_trials = .1:.1:.9;    % list of proportion of total trials at which to offer subject a self-timed break

%%%%%%% 
%Netstation communication params
NS_host = '192.168.1.1'; % ip address of NetStation host computer % *** NEEDS TO BE UPDATED!!!
NS_port = 55513; % the ethernet port to be used (Default is 55513 for NetStation.m)
%NS_synclimit = 0.9; % the maximum allowed difference in milliseconds between PTB and NetStation computer clocks (NetStation.m default is 2.5)

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

% Initiate user input set ames and paths See if you can auto 'path probe'
filename = input('Enter the name of the datafile:','s');
%Outputs
output_path = '/Users/clab/Desktop/Frequency_tagging/Exp_2b';
output_name = sprintf('%s/raw_data/%s_raw', output_path, filename);
data_name = sprintf('%s/Data Folder/%s_data', output_path, filename);

% Some initial array initialization
 tex = zeros(4,2);
 rate = zeros(1,4);
 num2_cor = 0;
 num2_incor = 0;
 num4_cor = 0;
 num4_incor = 0;
%BASIC WINDOW/SCREEN SETUP
HideCursor;
Screen('Preference','SyncTestSettings',0.0005, 70, 0.05, 10);
[w, rect] = Screen('Openwindow',0, [128 128 128]);
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


% Where you can change the stimulus image files, etc. We are loading in 20 where the 1st 10 are black and the second 10 are same-shape white 
nimages = 20;
image_tex = zeros(nimages+2);
for i = 1:nimages
    a = num2str(i);
    b = sprintf('%s','/Users/clab/Desktop/Frequency_tagging/Exp_2b/shape_stimuli/',a,'.tif');
    img = imread(b);
    image = double(img);
    image_tex(i) = Screen('MakeTexture',w,image);
end
% Load in the 2 squares: 1 is black and 2 is white
for z = 1:2;
    a = num2str(z);
    b = sprintf('%s','/Users/clab/Desktop/Frequency_tagging/Exp_2b/shape_stimuli2/',a,'.tif');
    img = imread(b);
    image = double(img);
    image_tex(nimages+z) = Screen('MakeTexture',w,image); 
end

%Stimulus settings and durations
stim_size = 100; % Work on converting this to ixels per degree
stim_array = [-stim_size;...
              -stim_size;...
              stim_size;...
              stim_size];
fix_size = 50;
destrect = zeros(4,4); 

%For photdiode timing testing
photo_tex(4) = Screen('MakeTexture',w,255*ones(1,1));

% fixation spot
fix_tex = Screen('MakeTexture',w,0*ones(fix_size,fix_size));
blank_tex = Screen('MakeTexture',w,128*ones(1,1));

% WE need to find blank_rect and fix_rect and put them here
%photo_rect=[rect(3)-100,rect(4)-100,rect(3)-50,rect(4)-50];
photo_rect=[xc-50,yc-50,xc+50,yc+50]; 
%trial data stuff

data = cell(num_trials,7);

tcolor = [0 0 0];
%Inputs
old = KbName('o');
new = KbName('n');

pixel2 = 128;

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
KbReleaseWait;
% 
% NetStation('Connect', NS_host, NS_port)
% % NetStation('Synchronize', NS_synclimit)
% NetStation('StartRecording');

% THIS IS THE ACTUAL EXPERIMENT
for i = 1:num_trials
    trial = trial_order(i); % convert 'i' to the randpermed trial order set above
    %put this at the beginning of the trial loop
    this_b = 0;
    for b = break_trials
        if i == round(b*num_trials)
            this_b = b;
            break
        end
    end
    if this_b
        % display break message
        text=sprintf('You have completed %d%% of the trials.',round(b*100));
        width=RectWidth(Screen('TextBounds',w,text));
        Screen('DrawText',w,text,xc-width/2,yc,tcolor);
        text='Press any key when you are ready to continue.';
        width=RectWidth(Screen('TextBounds',w,text));
        Screen('DrawText',w,text,xc-width/2,yc+50,tcolor);
        Screen('Flip',w);
        WaitSecs(1);
        %KbReleaseWait;
    end
    
    set_size = set_size_list(trial); % either 2 or 4
    old_new = old_new_list(trial); % either 1  = old, 2 = new
    switch old_new
        case 1,
            data{i,2} = 'old';
        case 2,
            data{i,2} = 'new';
    end
    probe_freq = probe_freq_list(trial); % either 1,2,3,4
    data{i,3} = sprintf('%dHz', stim_rate(probe_freq_list(trial)));
    %Assign each shape and frequency to each quadrant
    switch set_size
        case 4,
            %This sets the locations of the target and
            %non-target items in the arry
            data{i,1} = 'four';
            target_pos=randi(4);
            switch target_pos
                case 1,
                    data{i,7} = 'ul';
                case 2,
                    data{i,7} = 'ur';
                case 3,
                    data{i,7} = 'll';
                case 4,
                    data{i,7} = 'lr';
            end
            distractor_pos = setdiff(1:4,target_pos);
            distractor_freq = setdiff(1:4,probe_freq_list(trial));

            %This sets the frequencies of the target and
            %non-target items in the arry
            rate(target_pos) = 1/(2*stim_rate(probe_freq_list(trial)));
            rate(distractor_pos)=1./(2*stim_rate(distractor_freq));
            
            % The target image will be at location target_pos flickering
            % at counterbalanced frequency: stim_rate(probe_freq_list(trial))
            
            % assure that no image is shown twice at one time
            im(1) = randi(10);
            im2_temp = randi(10);
            while im2_temp == im(1)
                im2_temp = randi(10);
            end
            im(2) = im2_temp;
            im3_temp = randi(10);
            while im3_temp == im(1) || im3_temp == im(2)
                im3_temp = randi(10);
            end
            im(3) = im3_temp;
            im4_temp = randi(10);
            while im4_temp == im(1) || im4_temp == im(2) || im4_temp == im(3)
                im4_temp = randi(10);
            end
            im(4) = im4_temp;
            tex(1,1) = im(1);
            tex(1,2) = im(1)+10;
            tex(2,1) = im(2);
            tex(2,2) = im(2)+10;
            tex(3,1) = im(3);
            tex(3,2) = im(3)+10;
            tex(4,1) = im(4);
            tex(4,2) = im(4)+10;
            
        case 2,
            data{i,1} = 'two';
            target_pos=randi(2);
            distractor_pos = setdiff([1,2],target_pos);
            temp_index = randperm(4);
            switch temp_index(target_pos)
                case 1,
                    data{i,7} = 'ul';
                case 2,
                    data{i,7} = 'ur';
                case 3,
                    data{i,7} = 'll';
                case 4,
                    data{i,7} = 'lr';
            end
            im(1) = randi(10);
            im2_temp = randi(10);
            while im2_temp == im(1)
                im2_temp = randi(10);
            end
            im(2) = im2_temp;
            
            tex(temp_index(target_pos),1) = im(1);
            tex(temp_index(target_pos),2) = im(1)+10;
            tex(temp_index(distractor_pos),1) = im(2);
            tex(temp_index(distractor_pos),2) = im(2)+10;
            tex(temp_index(3),1) = nimages+1;
            tex(temp_index(3),2) = nimages+2;
            tex(temp_index(4),1) = nimages+1;
            tex(temp_index(4),2) = nimages+2;
            
            rate(temp_index(target_pos)) = 1/(2*stim_rate(probe_freq_list(trial)));
            rate(temp_index(distractor_pos))=1/(2*setdiff(stim_rate,[stim_rate(probe_freq_list(trial)),stim_rate(3),stim_rate(4)]));
            rate(temp_index(3))=1/(2*stim_rate(3));
            rate(temp_index(4))=1/(2*stim_rate(4));
    end
    
    flip1 = 1;
    flip2 = 1;
    flip3 = 1;
    flip4 = 1;
    
    % fixation cross
    fix_rect =[xc-fix_size, yc-fix_size, xc+fix_size, yc+fix_size];
    
    %%%%%%%%%DESTINATION RECTACULAR%%%%%%%%%
    %randomize (jitter) locations of squares within this quadrant
    for j = 1:4
        x_rand = 50-10*randi(10);
        y_rand = 50-10*randi(10);
        rand_array = [x_rand;...
            y_rand;...
            x_rand;...
            y_rand];
        % put one colored square in each of the quadrants
        destrect(j,:) = (corner_centers(j,:)' + stim_array + rand_array);
    end
    
    Screen('DrawTexture',w,fix_tex,[],fix_rect);
    %Screen('Flip',w);
    Screen('DrawTexture',w,image_tex(21), [], destrect(1,:));
    Screen('DrawTexture',w,image_tex(21), [], destrect(2,:));
    Screen('DrawTexture',w,image_tex(21), [], destrect(3,:));
    Screen('DrawTexture',w,image_tex(21), [], destrect(4,:));
    Screen('Flip',w);
    WaitSecs(intial_square_screen_base_duration+ (.2 * rand() -.1));   %variable +/- 100m
    check = 0;
    
    priorityLevel=MaxPriority(w);
    Priority(priorityLevel);
    
    %%%%%%%% draw stimuli to the screen
%     Screen('DrawTexture',w,fix_tex,[],fix_rect);
%     %Screen('Flip',w);
%     Screen('DrawTexture',w,image_tex(21), [], destrect(1,:));
%     Screen('DrawTexture',w,image_tex(21), [], destrect(2,:));
%     Screen('DrawTexture',w,image_tex(21), [], destrect(3,:));
%     Screen('DrawTexture',w,image_tex(21), [], destrect(4,:));
    sync_time= Screen('Flip',w,[]);
    DaqDOut(trigDevice,0,2);
    WaitSecs(TTL_pulse_dur);
    DaqDOut(trigDevice,0,0);
    Screen('DrawTextures',w,[photo_tex(4),image_tex(tex(1,flip1)),...
        image_tex(tex(2,flip2)),...
        image_tex(tex(3,flip3)),...
        image_tex(tex(4,flip4)),fix_tex],...
        [],[photo_rect;destrect(1,:);...
        destrect(2,:);...
        destrect(3,:);...
        destrect(4,:);fix_rect]');
    Screen('DrawingFinished',w);
    run_start=Screen('Flip',w,sync_time,2);
    t1 = run_start;
    t2 = t1;
    t3= t1;
    t4=t1;
  
    while 1
        time_now = GetSecs;
        %Keep track of flicker rates for ech stimulus
        trial_check = (time_now - run_start) > .990;
        
        switch trial_check
            case 0,
                rate1_check = (time_now - t1) > rate(1)-1/hz;
                rate2_check = (time_now - t2) > rate(2)-1/hz;
                rate3_check = (time_now - t3) > rate(3)-1/hz;
                rate4_check = (time_now - t4) > rate(4)-1/hz;
                switch rate1_check
                    case 1,
                        flip1 =  3-flip1;
                        t1=t1+rate(1);
                        check =1;
                    otherwise,
                end
                switch rate2_check
                    case 1,
                        flip2 =  3-flip2;
                        t2=t2+rate(2);
                        check =1;
                    otherwise,
                end
                switch rate3_check
                    case 1,
                        flip3 =  3-flip3;
                        t3=t3+rate(3);
                        check =1;
                    otherwise,
                end
                switch rate4_check
                    case 1,
                        flip4 =  3-flip4;
                        t4=t4+rate(4);
                        check =1;
                    otherwise,
                end
                
                %Update changes on the screen
                switch check
                    case 1,
                        Screen('DrawTextures',w,[fix_tex,photo_tex(4),image_tex(tex(1,flip1)),...
                            image_tex(tex(2,flip2)),...
                            image_tex(tex(3,flip3)),...
                            image_tex(tex(4,flip4))],...
                            [],[fix_rect;photo_rect;destrect(1,:);...
                            destrect(2,:);...
                            destrect(3,:);...
                            destrect(4,:)]');
                        Screen('DrawingFinished',w,2);
                        Screen('Flip',w,time_now,2);
                        check=0;
                    case 0,
                        WaitSecs(.0005);
                end
            case 1,
                break;
        end
    end
    Priority(0);
    Screen('DrawTexture',w,blank_tex,[],rect);
    Screen('DrawTexture',w,fix_tex,[],fix_rect);
    Screen('Flip',w);
    
    WaitSecs(delay_period);
    Screen('DrawTexture',w,blank_tex,[],rect);
    Screen('DrawTexture',w,fix_tex,[],fix_rect);
    %t = Screen('Flip',w);
    
    % NOW WE DISPLAY THE PROBE IMAGE at the target location
    % First we need to select the probe image; if old trial then probe  =
    % target
    % if new trial, must select a new image
    
    switch set_size
        case 4,
            switch old_new
                case 1, %OLD  probe  = target
                    probe = tex(target_pos,1);
                case 2, % New probe is 1 of the 3 the distractor images
                    probe = tex(distractor_pos(randi(3)),1);
            end
            Screen('DrawTexture',w,image_tex(probe),[],destrect(target_pos,:));
        case 2,
            switch old_new
                case 1, % OLD probe  = target
                    probe = tex(temp_index(target_pos),1);
                case 2,  % New probe is the distractor image
                    probe = tex(temp_index(distractor_pos),1);
            end
            Screen('DrawTexture',w,image_tex(probe),[],destrect(temp_index(target_pos),:));
    end
    Screen('Flip',w);
    
    t0 = GetSecs;
    time = GetSecs - t0;
    keyisdown = 0;
    
    while ~keyisdown && (time < .5) %3
        [keyisdown, secs, keycode] = KbCheck;
        WaitSecs(0.001); % CPU Saver
        if keycode(old)
            data{i,6} = 'old';
        elseif keycode(new)
            data{i,6} = 'new';
        else
            keyisdown = 0;
        end
        time = secs - t0;
        
        if strcmp(data{i,2},data{i,6}) == 1;
            data{i,4}='correct';
            switch data{i,1}
                case 'four'
                    num4_cor = num4_cor+1;
                case 'two'
                    num2_cor = num2_cor+1;
            end
            switch data{i,2}
                case 'old',
                    data{i,5}='hit';
                case 'new',
                    data{i,5}='correct_reject';
            end
        else
            data{i,4}='incorrect';
             switch data{i,1}
                case 'four'
                    num4_incor = num4_incor+1;
                case 'two'
                    num2_incor = num2_incor+1;
            end
            switch data{i,2}
                case 'old',
                    data{i,5}='miss';
                case 'new',
                    data{i,5}='false_alarm';
            end
        end
    end
    if time > .5
        data{i,1} = 'NoRe';
        Screen('TextSize',w,24);
        text='You did not make your response in time.';
        width=RectWidth(Screen('TextBounds',w,text));
        Screen('DrawText',w,text,xc-width/2,yc-50,[0 0 0]);
        text='Press any key to continue...';
        width=RectWidth(Screen('TextBounds',w,text));
        Screen('DrawText',w,text,xc-width/2,yc,[0 0 0]);
        Screen('Flip',w);
%         KbWait;
%         KbReleaseWait;
    end
    Screen('DrawTexture',w,fix_tex,[],fix_rect);
    Screen('Flip',w);
    WaitSecs(1+.5-rand());
    
    save(output_name);
    save(data_name,'data');
    
end
%  figure(1)
%  subplot(2,1,1)
%  bar(1:2,[num2_cor,num4_cor]);
%   subplot(2,1,2)
%  bar(1:2,[100*num2_cor/(num2_cor+num2_incor),num4_cor/(num4_cor+num4_incor)]);
%   subplot(2,1,3)
%  bar(1:2,[100*num2_cor/num_trials_set2,num4_cor/num_trials_set4]);
% ShowCursor;
Screen('CloseAll');

