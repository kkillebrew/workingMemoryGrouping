% function [tex] = Frequency_Tag_Unilateral_SS4_GC_shapes()
clear all
close all

%%%%  RUN EXP 2 AT 120 Hz at 1024 X 768 %%%%%%%%%%%%%
filename = input('Enter the name of the datafile:','s');
%Outputs
output_path = '/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Freq_tag_code/';
output_name = sprintf('%s/raw_data/%s_raw', output_path, filename);
data_name = sprintf('%s/Data Folder/%s_data', output_path, filename);

%BASIC WINDOW/SCREEN SETUP
HideCursor;
ListenChar(2);

Screen('Preference','SyncTestSettings',0.0005, 70, 0.05, 10);
[w, rect] = Screen('Openwindow',0, [128 128 128]);
hz = 120;
Screen('TextSize',w,24);

% Where you can change the stimulus image files, etc. 
nimages = 20;

% Makes an array of images from all the images
for i = 1:nimages
    a = num2str(i);
    b = sprintf('%s','/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Freq_tag_code/shape_stimuli/',a,'.tif');
    
    img = imread(b);
    
    image = double(img);
    image_tex(i) = Screen('MakeTexture',w,image);
    
end

% Loads in black and white squares
for z = 1:2
    a = num2str(z);
    b = sprintf('%s','/Users/C-Lab/Google Drive/Lab Projects/Marians Stuff/R15 wmGrouping/Freq_tag_code/shape_stimuli/',a,'.tif');
    
    img = imread(b);
    
    image = double(img);
    image_tex2(z) = Screen('MakeTexture',w,image);
    
end

% These are coordinates for the different images
% coordinates of screen center
x0 = rect(3)/2;
y0 = rect(4)/2;
%centers ul_c 
corner_centers(1,:)= [x0-x0/2;...
    y0-y0/2;...
    x0-x0/2;...
    y0-y0/2];
%ur_c 
corner_centers(2,:)= [x0+x0/2;...
    y0-y0/2;...
    x0+x0/2;...
    y0-y0/2];
%ll_c 
corner_centers(3,:)= [x0-x0/2;...
    y0+y0/2;...
    x0-x0/2;...
    y0+y0/2];
%lr_c 
corner_centers(4,:)= [x0+x0/2;...
    y0+y0/2;...
    x0+x0/2;...
    y0+y0/2];

%Stimulus settings and durations
stim_size = 100;
stim_array = [-stim_size;...
    -stim_size;...
    stim_size;...
    stim_size];
fix_size = 5;
delay_period = 1;
destrect = zeros(4,4);

%Square stimuli dimensions
% y_res= round(rect(4)/(2*stim_size));
% x_res= round(0.5*rect(3)/(2*stim_size));




%%%%%%% 

% Figuring out trial order etc. (For some reason in cells)
repetitions=1; %19

% 2 stim amounts and 12 what?
trial_list=[];
for i=1:repetitions;
    trial_list=[trial_list;fullyfact([2 12])];
end
%Trial amount
num_trials = 24*repetitions;

stim2_repetitions = 2*repetitions;

stim2_trial_list=[];
for i=1:stim2_repetitions;
    stim2_trial_list=[stim2_trial_list;fullyfact([2 4])];
end

data = cell(num_trials,9);
old_new = cell(num_trials,1);
trial_order = randperm(num_trials)';
stim2_trial_order = randperm(num_trials/3)';
stim2_probe_rate = randperm(num_trials/3)';
Stimulus_accuracies = cell(3,4);
K_vals = cell(3,4);
a = 0;
freq_record = cell(num_trials,4);



% duration of TTL pulse to account for ahardware lag
TTL_pulse_dur = 0.0015; 

% Don't need netsation info
% NS_host = '192.168.1.1'; % ip address of NetStation host computer % *** NEEDS TO BE UPDATED!!!
% NS_port = 55513; % the ethernet port to be used (Default is 55513 for NetStation.m)
% NS_synclimit = 0.9; % the maximum allowed difference in milliseconds between PTB and NetStation computer clocks (NetStation.m default is 2.5)
 

%establish this early in your code
break_trials = .1:.1:.9;    % list of proportion of total trials at which to offer subject a self-timed break
tcolor = [0 0 0];

%Inputs
old = KbName('o');
new = KbName('n');
one = KbName('1!');
two = KbName('2@');
three = KbName('3#');
four = KbName('4$');
five = KbName('5%');
six = KbName('6^');
seven = KbName('7&');



% Freq tagging variables
%Flicker Frequency Rates (3 Hz, 5 Hz, 12 Hz, 20 Hz)
stim_rate(1) = 3;
stim_rate(2) = 5;
stim_rate(3) = 12;
stim_rate(4) = 20;



% I THINK YOU JUST INCLUDE THIS IN TRIAL ORDER
% max trials per freq
max_3hz_2stim = num_trials/6;
max_3hz_2stim_oldnew = max_3hz_2stim/2;
max_5hz_2stim = num_trials/6;
max_5hz_2stim_oldnew = max_5hz_2stim/2;
max_3hz_4stim = num_trials/6;
max_3hz_4stim_oldnew = max_3hz_4stim/2;
max_5hz_4stim = num_trials/6;
max_5hz_4stim_oldnew = max_5hz_4stim/2;
max_12hz_4stim = num_trials/6;
max_12hz_4stim_oldnew = max_12hz_4stim/2;
max_20hz_4stim = num_trials/6;
max_20hz_4stim_oldnew = max_20hz_4stim/2;

% INCLUDE IN RAWDATA
% counter variables for max
stim2_3hz_count = 0;
stim2_3hz_count_old = 0;
stim2_3hz_count_new = 0;
stim2_5hz_count = 0;
stim2_5hz_count_old = 0;
stim2_5hz_count_new = 0;
stim4_3hz_count = 0;
stim4_3hz_count_old = 0;
stim4_3hz_count_new = 0;
stim4_5hz_count = 0;
stim4_5hz_count_old = 0;
stim4_5hz_count_new = 0;
stim4_12hz_count = 0;
stim4_12hz_count_old = 0;
stim4_12hz_count_new = 0;
stim4_20hz_count = 0;
stim4_20hz_count_old = 0;
stim4_20hz_count_new = 0;

% CALCULATE POST HOC
% accuracy calculation variables
corr_trial = 0;
corr_2stim = 0;
corr_2stim_3hz = 0;
corr_2stim_5hz = 0;
corr_4stim = 0;
corr_4stim_3hz = 0;
corr_4stim_5hz = 0;
corr_4stim_12hz = 0;
corr_4stim_20hz = 0;
stim2_3hz_hit = 0;
stim2_3hz_far = 0;
stim2_5hz_hit = 0;
stim2_5hz_far = 0;
stim4_3hz_hit = 0;
stim4_3hz_far = 0;
stim4_5hz_hit = 0;
stim4_5hz_far = 0;
stim4_12hz_hit = 0;
stim4_12hz_far = 0;
stim4_20hz_hit = 0;
stim4_20hz_far = 0;

% stim(1,:,:,:) = zeros(2*stim_size,2*stim_size,3);
% stim(2,:,:,:) = zeros(2*stim_size,2*stim_size,3);
% stim(3,:,:,:) = zeros(2*stim_size,2*stim_size,3);
% stim(4,:,:,:) = zeros(2*stim_size,2*stim_size,3);

% pixel2 = 128;%zeros(2*stim_size,2*stim_size);
% old_new array (0 = old,1 = new)

%Instructions and Waiting for Experimenter to Start Audacity and Experiment
Screen('TextSize',w,24);
text='Attend to the fixation point that will appear in the center of the screen.';
width=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-width/2,y0-300,[0 0 0]);
text='Four images flashing at different frequencies will appear in four locations on the screen.';
width=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-width/2,y0-250,[0 0 0]);
text='The images will then disappear.';
width=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-width/2,y0-200,[0 0 0]);
text='An image will then appear in one of the four locations on the screen.';
width=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-width/2,y0-150,[0 0 0]);
text='Your task is to determine whether or not the image that appears in the';
width=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-width/2,y0-100,[0 0 0]);
text='location is the same image that was previously shown in that location.';
width=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-width/2,y0-50,[0 0 0]);
text='If the image that appears in the location is old press the "o" key';
width=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-width/2,y0+50,[0 0 0]);
text='If the image that appears in the location is new press the "n" key';
width=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-width/2,y0+100,[0 0 0]);
text='When you are ready to begin tell the experimenter:'; 
width=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-width/2,y0+200,[0 0 0]);
text='"I am ready to begin"';
width=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-width/2,y0+250,[0 0 0]);
Screen('Flip',w);
KbWait;

% Don't need the netstation commands
% NetStation('Connect', NS_host, NS_port)
% NetStation('Synchronize', NS_synclimit)
% NetStation('StartRecording');

% %%%% half of the trials are old and half are new
% for i =1:num_trials
%     if i<= (num_trials/2)
%         old_new{i} = 'old';
%     else
%         old_new{i} = 'new';
%     end
% end

% AGAIN THIS IS TRIAL ORDER/VAR LIST STUFF      
% is this trial old or new
if trial_list(trial_order(i),:) == 1
    old_new{1} = 'old';
else
    old_new{1} = 'new';
end


% cue type array
%cue_type = [ones(1,num_trials/4),2*ones(1,num_trials/4),...
%ones(1,num_trials/4),2*ones(1,num_trials/4)];

% randomize trial type order
%trial_order = randperm(num_trials);


% NO IDEA? FIXATION?
fix_tex = Screen('MakeTexture',w,0*ones(fix_size,fix_size));
% photo_rect=[rect(3)-100,rect(4)-100,rect(3)-50,rect(4)-50];
% photo_tex(4) = Screen('MakeTexture',w,255*ones(50,50));
% photo_tex(2) = Screen('MakeTexture',w,zeros(50,50));

% ???????
photo_tex(1) = Screen('MakeTexture',w,255);
photo_tex(2) = Screen('MakeTexture',w,128);
photo_tex(3) = Screen('MakeTexture',w,128);
photo_tex(4) = Screen('MakeTexture',w,128);
% photo_tex(4) = Screen('MakeTexture',w,0);

% ??????????
blank_tex = Screen('MakeTexture',w,128*ones(rect(4),rect(3)));
photo_rect=[rect(3)-100,rect(4)-100,rect(3)-50,rect(4)-50];
 
 
 

for i = 1:num_trials
    
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
        Screen('DrawText',w,text,x0-width/2,y0,tcolor);
        text='Press any key when you are ready to continue.';
        width=RectWidth(Screen('TextBounds',w,text));
        Screen('DrawText',w,text,x0-width/2,y0+50,tcolor);
        Screen('Flip',w);
        WaitSecs(1);
        KbWait;
    end
    
    
    stim_location = trial_list(trial_order(i),2);
    data{i,4} = stim_location;
    
    

% if stim location is 1-4 or 9-12 means 4 stimulus else 2 stimulus         
 if stim_location < 5 || stim_location > 8
     
     
     % Pressumably need some sync test? Figure out..
%   NetStation('Synchronize', NS_synclimit);   
    
   data{i,9} = 4;
   if data{i,9} == 4;
       stim = 'four';
   end
   
    % Randomly chooses the images to be used
    % Just check to make sure all images are different
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
    

    % Sets up the images and there opposites in the tex array
    tex(1,1) = im(1);
    tex(1,2) = im(1)+10;
    tex(2,1) = im(2);
    tex(2,2) = im(2)+10;
    tex(3,1) = im(3);
    tex(3,2) = im(3)+10;
    tex(4,1) = im(4);
    tex(4,2) = im(4)+10;
    
    % randomly assigns the four images a flickering rate
    % stim_rate is the rate of flickering
    trial_rates=randperm(4);
    rate11=1/(2*stim_rate(trial_rates(1)));
    rate22=1/(2*stim_rate(trial_rates(2)));
    rate33=1/(2*stim_rate(trial_rates(3)));
    rate44=1/(2*stim_rate(trial_rates(4)));
    flip1 = 1;
    flip2 = 1;
    flip3 = 1;
    flip4 = 1;
    
    % randomly chooses the target
    target = im(randi(4));
    if target == im(1)
        target_pos = 1;
    elseif target == im(2)
        target_pos = 2;
    elseif target == im(3)
        target_pos = 3;
    elseif target == im(4);
        target_pos = 4;
    end
    
    % no idea what this is doing?   
    % WHATS THE DIFFERENCE BETWEEN stimloc 1-4 and 9-12
    if stim_location == 1
%         rate_val = perms(2:4);
        if trial_rates(target_pos) ~= 1
            for p = 1:4
                temp = trial_rates(p);
                if temp == 1
                    trial_rates(p) = trial_rates(target_pos);
                end
            end
        end
        trial_rates(target_pos) = 1;
        data{i,2} = 3;
    elseif stim_location == 2
        
        if trial_rates(target_pos) ~= 1
            for p = 1:4
                temp = trial_rates(p);
                if temp == 1
                    trial_rates(p) = trial_rates(target_pos);
                end
            end
        end
        
        trial_rates(target_pos) = 1;
        data{i,2} = 3;
    elseif stim_location == 3
        
        if trial_rates(target_pos) ~= 2
            for p = 1:4
                temp = trial_rates(p);
                if temp == 2
                    trial_rates(p) = trial_rates(target_pos);
                end
            end
        end
        
        trial_rates(target_pos) = 2;
        data{i,2} = 5;
    elseif stim_location == 4
        
        if trial_rates(target_pos) ~= 2
            for p = 1:4
                temp = trial_rates(p);
                if temp == 2
                    trial_rates(p) = trial_rates(target_pos);
                end
            end
        end
        
        trial_rates(target_pos) = 2;
        data{i,2} = 5;
    elseif stim_location == 9
        
        if trial_rates(target_pos) ~= 3
            for p = 1:4
                temp = trial_rates(p);
                if temp == 3
                    trial_rates(p) = trial_rates(target_pos);
                end
            end
        end
        
        trial_rates(target_pos) = 3;
        data{i,2} = 12;
    elseif stim_location == 10
        
        if trial_rates(target_pos) ~= 3
            for p = 1:4
                temp = trial_rates(p);
                if temp == 3
                    trial_rates(p) = trial_rates(target_pos);
                end
            end
        end
        
        trial_rates(target_pos) = 3;
        data{i,2} = 12;
    elseif stim_location == 11
        
        if trial_rates(target_pos) ~= 4
            for p = 1:4
                temp = trial_rates(p);
                if temp == 4
                    trial_rates(p) = trial_rates(target_pos);
                end
            end
        end
        
        trial_rates(target_pos) = 4;
        data{i,2} = 20;
    elseif stim_location == 12
        
        if trial_rates(target_pos) ~= 4
            for p = 1:4
                temp = trial_rates(p);
                if temp == 4
                    trial_rates(p) = trial_rates(target_pos);
                end
            end
        end
        
        trial_rates(target_pos) = 4;
        data{i,2} = 20;
    end
        
   
%     trial_type = old_new(1);

    if trial_list(trial_order(i),1) == 1
        trial_type = 'old';
    end
    
    if trial_list(trial_order(i),1) == 2
        trial_type = 'new';
    end
    
        
    
%     trial_val = trial_order(i);
%     trial_num = trial_list([trial_order(i) 1])
    old_new=trial_list(trial_order(i),1);
    probe = target;
    switch trial_type
        case 'old', %this is an 'old trial'
            probe = target;%squeeze(stim(target,:,:,:));
        case 'new',
            while probe == target
                probe = im(randi(4));
            end

%             target_stim = texture(probe);
            %target_shape = im(probe);
%             target_stim(:,:,1) = color_lookup(colors(probe),1);
%             target_stim(:,:,2) = color_lookup(colors(probe),2);
%             target_stim(:,:,3) = color_lookup(colors(probe),3);
    end
 
    % fixation cross
    fix_rect =[x0-fix_size, y0-fix_size, x0+fix_size, y0+fix_size];
    
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
            Screen('DrawTexture',w,image_tex2(1), [], destrect(1,:));
            Screen('DrawTexture',w,image_tex2(1), [], destrect(2,:));
            Screen('DrawTexture',w,image_tex2(1), [], destrect(3,:));
            Screen('DrawTexture',w,image_tex2(1), [], destrect(4,:));
            Screen('Flip',w);
            WaitSecs(.5);   %.5
            check = 0;
%             jjj =3;
            
            priorityLevel=MaxPriority(w);
            Priority(priorityLevel);
            
            
            %%%%%%%% draw stimuli to the screen
                         
                          
            
             Screen('DrawTextures',w,[photo_tex(4),image_tex(tex(1,flip1)),...
            image_tex(tex(2,flip2)),...
            image_tex(tex(3,flip3)),...
            image_tex(tex(4,flip4)),fix_tex],...
            [],[photo_rect;destrect(1,:);...
            destrect(2,:);...
            destrect(3,:);...
            destrect(4,:);fix_rect]');
            
           
        
        
             
            Screen('DrawingFinished',w);
            
            run_start=Screen('Flip',w,[],2);
%             NetStation('Event', stim,GetSecs+.010  ,.010,  'tri#', i, 'type', trial_type, 'hrtz', data{i,2}, 'tpos',target_pos)
            t1 = run_start;
            t2 = t1;
            t3= t1;
            t4=t1;
%             jjj=2;
            Screen('DrawTexture',w,photo_tex(1),[],photo_rect);
            Screen('Flip',w,run_start,2);
               
    while 1
        time_now = GetSecs;
        %Keep track of flicker rates for ech stimulus
        trial_check = (time_now - run_start) > .995;
        
        switch trial_check
            case 0,
                rate1_check = (time_now - t1) > rate11-1/hz;
                rate2_check = (time_now - t2) > rate22-1/hz;
                rate3_check = (time_now - t3) > rate33-1/hz;
                rate4_check = (time_now - t4) > rate44-1/hz;
                switch rate1_check
                    case 1,
                        flip1 =  3-flip1;
                        t1=t1+rate11;
                        check =1;
                    otherwise,
                end
                switch rate2_check
                    case 1,
                        flip2 =  3-flip2;
                        t2=t2+rate22;
                        check =1;
                    otherwise,
                end
                switch rate3_check
                    case 1,
                        flip3 =  3-flip3;
                        t3=t3+rate33;
                        check =1;
                    otherwise,
                end
                switch rate4_check
                    case 1,
                        flip4 =  3-flip4;
                        t4=t4+rate44;
                        check =1;
                    otherwise,
                end
                
                %Update changes on the screen
  
                switch check
                    
                    case 1,
%                         switch stim_location
%                             case 1
                                
                                Screen('DrawTextures',w,[photo_tex(4),image_tex(tex(1,flip1)),...
                                image_tex(tex(2,flip2)),...
                                image_tex(tex(3,flip3)),...
                                image_tex(tex(4,flip4)),fix_tex],...
                                [],[photo_rect;destrect(1,:);...
                                destrect(2,:);...
                                destrect(3,:);...
                                destrect(4,:);fix_rect]');
                                Screen('DrawingFinished',w,2)
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
    Screen('DrawTexture',w,fix_tex,[],fix_rect);
    %t = Screen('Flip',w);
    
    Screen('DrawTexture',w,image_tex(probe),[],destrect(target_pos,:));
    Screen('Flip',w);
    
%     NetStation('Event', event_code,timer3+.010  ,.010,  'tri#', i, 'cat_', this.category_idx(i,1), 'xmlp', this.exemplar_idx(i,1), 'catx', this.category_examplar, 'crep', this.category_repeat(i,1), 'ori_',trials.orientation(i,1));
    %Screen('DrawText',w,fix_text,xc-normBoundsRect(3)/2,yc-normBoundsRect(4)/2,[0 0 0]);
    
    t0 = GetSecs;
    time = GetSecs - t0;
    keyisdown = 0;
   
    while ~keyisdown && time < 3
        [keyisdown, secs, keycode] = KbCheck;
        WaitSecs(0.001); % CPU Saver
        
        if keycode(old)
            data{i,1} = 'old';
        elseif keycode(new)
            data{i,1} = 'new';
        else
            keyisdown = 0;
        end
        
        time = secs - t0;
        
        
        if strcmp(data{i,1},trial_type) == 1;
            data{i,5}='correct';
            
            switch trial_type
                case 'old',
                    data{i,6}='hit';
                case 'new',
                    data{i,6}='correct_reject';
            end
        else
            data{i,5}='incorrect';
            
            switch trial_type
                case 'old',
                    data{i,6}='miss';
                case 'new',
                    data{i,6}='false_alarm';
            end
        end
         accu = data{i,5};
         if keycode(old) || keycode(new)
            NetStation('Event', accu,GetSecs+.010  ,.010,  'tri#', i,'resp',data{i,1},'hrz#', data{i,2},'stim', stim)  
        end
    end
    
    
    % WAIT 3 SECONDS UNTIL RESPONSE
      if time >= 3
          
                %NetStation('Event', 'nore',GetSecs+.010  ,.010,  'tri#', i)
                data{i,1} = 'NoRe';
                 NetStation('Event', 'nore',GetSecs+.010  ,.010,  'tri#', i, 'resp', data{i,1},'hrz#', data{i,2}, 'stim', stim)
%                 recog_data{i,3}='No Response';
                Screen('TextSize',w,24);
                text='You did not make your response in time.';
                width=RectWidth(Screen('TextBounds',w,text));
                Screen('DrawText',w,text,x0-width/2,y0-50,[0 0 0]); 
                text='Press any key to continue...';
                width=RectWidth(Screen('TextBounds',w,text));
                Screen('DrawText',w,text,x0-width/2,y0,[0 0 0]);
                Screen('Flip',w);
                
      end
        
    
   
    data{i,10} = time;
    data{i,3} = trial_type;
     
    if strcmp(data{i,1},'NoRe')~=1;
            %break time
        Screen('TextSize',w,24);
        text='Press any key to continue...';
        width=RectWidth(Screen('TextBounds',w,text));
        Screen('DrawText',w,text,x0-width/2,y0,[0 0 0]);        
        Screen('Flip',w);
        
    end
    pause;   
       

    Screen('DrawTexture',w,fix_tex,[],fix_rect);
    Screen('Flip',w);
        
    % Signal Detection Data Setup
    
%     if strcmp(data{i,1},trial_type) == 1;
%         data{i,5}='correct';
%         
%         switch trial_type
%             case 'old',
%                 data{i,6}='hit';
%             case 'new',
%                 data{i,6}='correct_reject';
%         end
%     else
%         data{i,5}='incorrect';
%        
%         switch trial_type
%             case 'old',
%                 data{i,6}='miss';
%             case 'new',
%                 data{i,6}='false_alarm';
%         end
%     end
%     
%     accu = data{i,5};
%     NetStation('Event', accu,GetSecs+.010  ,.010,  'tri#', i, 'resp', data{i,1})
       %Original color of the object in the array that will get probed
    data{i,7} = probe;
    switch i
        case 1,
            starter = run_start;
                data{i,8} = 0;
        otherwise
                data{i,8} = run_start - starter;
    end
    data{i,12} = target_pos;
    
    WaitSecs(1+.5-rand());
 
    save(output_name);
    save(data_name,'data');
    
    
        %%%%%%%% record frequencies
        freq_record{i,1} = trial_rates(1);
        freq_record{i,2} = trial_rates(2);
        freq_record{i,3} = trial_rates(3);
        freq_record{i,4} = trial_rates(4);
    
    
    
    
 end
 
 
 %%%%%%%%%%% 2 stimuli %%%%%%%%%%%%%%%%%%
 %%%%%%%%%%% 2 stimuli %%%%%%%%%%%%%%%%%%
 %%%%%%%%%%% 2 stimuli %%%%%%%%%%%%%%%%%%
 
 if stim_location > 4 && stim_location < 9
%   NetStation('Synchronize', NS_synclimit);   
     a = a+1;
     
     data{i,9} = 2;
   if data{i,9} == 2;
       stim = 'two';
   end
    % assure that no image is shown twice at one time
    im(1) = randi(10);
    im2_temp = randi(10);
    while im2_temp == im(1)
        im2_temp = randi(10);
    end
    im(2) = im2_temp;
%     im3_temp = randi(10);

    
    tex(1,1) = im(1);
    tex(1,2) = im(1)+10;
    tex(2,1) = im(2);
   tex(2,2) = im(2)+10;
    tex(3,1) = 1;
    tex(3,2) = 2;
%     tex(4,1) = im(4);
%     tex(4,2) = im(4)+10;
    
    trial_rates=randperm(2);
    rate11=1/(2*stim_rate(trial_rates(1)));
    rate22=1/(2*stim_rate(trial_rates(2)));
%     rate33=1/(2*stim_rate(trial_rates(3)));
%     rate44=1/(2*stim_rate(trial_rates(4)));
    flip1 = 1;
    flip2 = 1;
    flip3 = 1;
    flip4 = 1;

% make the squares flicker at 12 or 20 hz
square_rates = randperm(2);
if square_rates(1) == 1
    rate33=1/(2*stim_rate(3));
    rate44=1/(2*stim_rate(4));
elseif square_rates(1) == 2
    rate33=1/(2*stim_rate(4));
    rate44=1/(2*stim_rate(3));
end
    
    
    
    switch stim_location

        case 5
           target = im(randi(2));
           if target == im(1)
              target_pos = 1;
           elseif target == im(2)
              target_pos = 2;
           end 
        case 6
           target = im(randi(2));
           if target == im(1)
              target_pos = 1;
           elseif target == im(2);
              target_pos = 4;
           end 
        case 7
           target = im(randi(2));
           if target == im(1)
              target_pos = 2;
           elseif target == im(2)
              target_pos = 3;
           end 
        case 8
           target = im(randi(2));
           if target == im(1)
              target_pos = 3;
           elseif target == im(2);
              target_pos = 4;
           end 
    end

    
%     trial_type = old_new(1);

    if stim2_trial_list(stim2_trial_order(a),1) == 1
        trial_type = 'old';
    end
    
    if stim2_trial_list(stim2_trial_order(a),1) == 2
        trial_type = 'new';
    end
    
        
    
%     trial_val = trial_order(i);
%     trial_num = trial_list([trial_order(i) 1])
    old_new=stim2_trial_list(stim2_trial_order(a),1);
    probe = target;
    switch trial_type
        case 'old', %this is an 'old trial'
            probe = target;%squeeze(stim(target,:,:,:));
        case 'new',
            while probe == target
                probe = im(randi(2));
            end

%             target_stim = texture(probe);
            %target_shape = im(probe);
%             target_stim(:,:,1) = color_lookup(colors(probe),1);
%             target_stim(:,:,2) = color_lookup(colors(probe),2);
%             target_stim(:,:,3) = color_lookup(colors(probe),3);
    end
 
    % fixation cross
    fix_rect =[x0-fix_size, y0-fix_size, x0+fix_size, y0+fix_size];
    
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
   
    % Start of trial

    
%     while ok == 0
        if target_pos == 1 || target_pos == 2
            temp = target_pos;
        elseif target_pos == 3
            temp = randi(2);
        elseif target_pos == 4
            temp = randi(2);
        end
        
        
        temp2 = stim2_trial_list(stim2_trial_order(a),2);
        
        if temp2 == 1
            
            if trial_rates(temp) ~= 1
                for p = 1:2
                    temprate = trial_rates(p);
                    if temprate == 1
                        trial_rates(p) = trial_rates(temp);
                    end
                end
            end
            
            trial_rates(target_pos) = 1;
            data{i,2} = 3;
            
        elseif temp2 == 2
            
            if trial_rates(temp) ~= 1
                for p = 1:2
                    temprate = trial_rates(p);
                    if temprate == 1
                        trial_rates(p) = trial_rates(temp);
                    end
                end
            end
            
            trial_rates(target_pos) = 1;
            data{i,2} = 3;
            
        elseif temp2 == 3
            
            if trial_rates(temp) ~= 2
                for p = 1:2
                    temprate = trial_rates(p);
                    if temprate == 2
                        trial_rates(p) = trial_rates(temp);
                    end
                end
            end
            
            trial_rates(target_pos) = 2;
            data{i,2} = 5;
            
        elseif temp2 == 4
            
            if trial_rates(temp) ~= 2
                for p = 1:2
                    temprate = trial_rates(p);
                    if temprate == 2
                        trial_rates(p) = trial_rates(temp);
                    end
                end
            end
            
            trial_rates(target_pos) = 2;
            data{i,2} = 5;
        end
        



        %%%%% %%%% %%%%%%% %%%%%
        
    switch stim_location
%         
        
        case 5,
            Screen('DrawTexture',w,fix_tex,[],fix_rect);
            Screen('DrawTexture',w,image_tex2(1), [], destrect(1,:));
            Screen('DrawTexture',w,image_tex2(1), [], destrect(2,:));
            Screen('DrawTexture',w,image_tex2(1), [], destrect(3,:));
            Screen('DrawTexture',w,image_tex2(1), [], destrect(4,:));
            
            Screen('Flip',w);
            WaitSecs(.5);
            check = 0;
%             jjj =3;
            
            priorityLevel=MaxPriority(w);
            Priority(priorityLevel);
           
            % PHOTO_RECT IS FOR PHOTO DIODE
            Screen('DrawTextures',w,[photo_tex(4),image_tex(tex(1,flip1)),...
            image_tex(tex(2,flip2)),fix_tex],...
            [],[photo_rect;destrect(1,:);...
            destrect(2,:);fix_rect]');
        
            Screen('DrawingFinished',w);
            %%%%%%%%%%%%%%%%%%%%
            run_start=Screen('Flip',w,[],2);
%             NetStation('Event', stim,GetSecs+.010  ,.010,  'tri#', i, 'type', trial_type, 'hrtz', data{i,2},'tpos',target_pos)
            t1 = run_start;
            t2 = t1;
            t3= t1;
            t4=t1;
            jjj=2;    
            Screen('DrawTexture',w,photo_tex(4),[],photo_rect);
            Screen('Flip',w,run_start,2);
        
        
        case 6,
            Screen('DrawTexture',w,fix_tex,[],fix_rect);
            Screen('DrawTexture',w,image_tex2(1), [], destrect(1,:));
            Screen('DrawTexture',w,image_tex2(1), [], destrect(2,:));
            Screen('DrawTexture',w,image_tex2(1), [], destrect(3,:));
            Screen('DrawTexture',w,image_tex2(1), [], destrect(4,:));
            
            Screen('Flip',w);
          
            WaitSecs(.5);
            check = 0;
%             jjj =3;
%             
            priorityLevel=MaxPriority(w);
            Priority(priorityLevel);
            
            Screen('DrawTextures',w,[photo_tex(4),image_tex(tex(1,flip1)),...
            image_tex(tex(2,flip2)),fix_tex],...
            [],[photo_rect;destrect(1,:);...
            destrect(4,:);fix_rect]');
        
            Screen('DrawingFinished',w);
            run_start=Screen('Flip',w,[],2);
            NetStation('Event', stim,GetSecs+.010  ,.010,  'tri#', i, 'type', trial_type, 'hrtz', data{i,2},'tpos',target_pos)
            t1 = run_start;
            t2 = t1;
            t3= t1;
            t4=t1;
            jjj=2;
            Screen('DrawTexture',w,photo_tex(4),[],photo_rect);
            Screen('Flip',w,run_start,2);
        
        
        case 7,
            Screen('DrawTexture',w,fix_tex,[],fix_rect);
            Screen('DrawTexture',w,image_tex2(1), [], destrect(1,:));
            Screen('DrawTexture',w,image_tex2(1), [], destrect(2,:));
            Screen('DrawTexture',w,image_tex2(1), [], destrect(3,:));
            Screen('DrawTexture',w,image_tex2(1), [], destrect(4,:));
            
            Screen('Flip',w);
            WaitSecs(.5);
            check = 0;
%             jjj =3;
            
            priorityLevel=MaxPriority(w);
            Priority(priorityLevel);
            
            Screen('DrawTextures',w,[photo_tex(4),image_tex(tex(2,flip2)),...
            image_tex(tex(1,flip1)),fix_tex],...
            [],[photo_rect;...
            destrect(2,:);...
            destrect(3,:);fix_rect]');
        
            Screen('DrawingFinished',w);
            run_start=Screen('Flip',w,[],2);
            NetStation('Event', stim,GetSecs+.010  ,.010,  'tri#', i, 'type', trial_type, 'hrtz', data{i,2},'tpos',target_pos)
            t1 = run_start;
            t2 = t1;
            t3= t1;
            t4=t1;
%             jjj=2;
            Screen('DrawTexture',w,photo_tex(4),[],photo_rect);
            Screen('Flip',w,run_start,2);
        
        
        case 8,
            Screen('DrawTexture',w,fix_tex,[],fix_rect);
            Screen('DrawTexture',w,image_tex2(1), [], destrect(1,:));
            Screen('DrawTexture',w,image_tex2(1), [], destrect(2,:));
            Screen('DrawTexture',w,image_tex2(1), [], destrect(3,:));
            Screen('DrawTexture',w,image_tex2(1), [], destrect(4,:));
            
            Screen('Flip',w);
            WaitSecs(.5);
            check = 0;
%             jjj =3;
            
            priorityLevel=MaxPriority(w);
            Priority(priorityLevel);
            
            Screen('DrawTextures',w,[photo_tex(4),image_tex(tex(1,flip1)),...
            image_tex(tex(2,flip2)),fix_tex],...
            [],[photo_rect;destrect(3,:);...
            destrect(4,:);fix_rect]');
        
            Screen('DrawingFinished',w);
            run_start=Screen('Flip',w,[],2);
            NetStation('Event', stim,GetSecs+.010  ,.010,  'tri#', i, 'type', trial_type, 'hrtz', data{i,2},'tpos',target_pos)
            t1 = run_start;
            t2 = t1;
            t3= t1;
            t4=t1;
%             jjj=2;
            Screen('DrawTexture',w,photo_tex(4),[],photo_rect);
            Screen('Flip',w,run_start,2);
        
       
    end
    


    while 1
        time_now = GetSecs;
        %Keep track of flicker rates for ech stimulus
        trial_check = (time_now - run_start) > .985;
        switch trial_check
            case 0,
                rate1_check = (time_now - t1) > rate11-1/hz;
                rate2_check = (time_now - t2) > rate22-1/hz;
                rate3_check = (time_now - t3) > rate33-1/hz;
                rate4_check = (time_now - t4) > rate44-1/hz;
                switch rate1_check
                    case 1,
                        flip1 =  3-flip1;
                        t1=t1+rate11;
                        check =1;
                    otherwise,
                end
                switch rate2_check
                    case 1,
                        flip2 =  3-flip2;
                        t2=t2+rate22;
                        check =1;
                    otherwise,
                end
                switch rate3_check
                    case 1,
                        flip3 =  3-flip3;
                        t3=t3+rate33;
                        check =1;
                    otherwise,
                end
                switch rate4_check
                    case 1,
                        flip4 =  3-flip4;
                        t4=t4+rate44;
                        check =1;
                    otherwise,
                end
                
                %Update changes on the screen
                switch check
                    case 1,
                        switch stim_location
%                          

                                
                            case 5
                                
                                Screen('DrawTexture',w,image_tex2(tex(3,flip3)), [], destrect(3,:));
                                Screen('DrawTexture',w,image_tex2(tex(3,flip4)), [], destrect(4,:));

                                Screen('DrawTextures',w,[photo_tex(4),image_tex(tex(1,flip1)),...
                                image_tex(tex(2,flip2)),fix_tex],...
                                [],[photo_rect;destrect(1,:);...
                                destrect(2,:);fix_rect]');
                                Screen('DrawingFinished',w,2);
                                Screen('Flip',w,time_now,2);
                                check=0;
                                
                            case 6
                                
                                Screen('DrawTexture',w,image_tex2(tex(3,flip3)), [], destrect(2,:));
                                Screen('DrawTexture',w,image_tex2(tex(3,flip4)), [], destrect(3,:));
                                
                                Screen('DrawTextures',w,[photo_tex(4),image_tex(tex(1,flip1)),...
                                image_tex(tex(2,flip2)),fix_tex],...
                                [],[photo_rect;destrect(1,:);...
                                destrect(4,:);fix_rect]');
                                Screen('DrawingFinished',w,2);
                                Screen('Flip',w,time_now,2);
                                check=0;
                                
                            case 7
                                
                                Screen('DrawTexture',w,image_tex2(tex(3,flip3)), [], destrect(1,:));
                                Screen('DrawTexture',w,image_tex2(tex(3,flip4)), [], destrect(4,:));
                                
                                Screen('DrawTextures',w,[photo_tex(4),image_tex(tex(1,flip1)),...
                                image_tex(tex(2,flip2)),fix_tex],...
                                [],[photo_rect;...
                                destrect(2,:);...
                                destrect(3,:);fix_rect]');
                                Screen('DrawingFinished',w,2);
                                Screen('Flip',w,time_now,2);
                                check=0;
                                
                            case 8
                                
                                Screen('DrawTexture',w,image_tex2(tex(3,flip3)), [], destrect(1,:));
                                Screen('DrawTexture',w,image_tex2(tex(3,flip4)), [], destrect(2,:));
                                
                                Screen('DrawTextures',w,[photo_tex(4),image_tex(tex(1,flip1)),...
                                    image_tex(tex(2,flip2)),fix_tex],...
                                    [],[photo_rect;destrect(3,:);...
                                    destrect(4,:);fix_rect]');
                                Screen('DrawingFinished',w,2);
                                Screen('Flip',w,time_now,2);
                                check=0;
                        end
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
    Screen('DrawTexture',w,fix_tex,[],fix_rect);
    %t = Screen('Flip',w);
    Screen('DrawTexture',w,image_tex(probe),[],destrect(target_pos,:));
    Screen('Flip',w);
    %Screen('DrawText',w,fix_text,xc-normBoundsRect(3)/2,yc-normBoundsRect(4)/2,[0 0 0]);
    
    t0 = GetSecs;
    time = GetSecs - t0;
    keyisdown = 0;
   
    while ~keyisdown && time < 3
        [keyisdown, secs, keycode] = KbCheck;
        WaitSecs(0.001); % CPU Saver
        
        if keycode(old)
            data{i,1} = 'old';
            
        elseif keycode(new)
            data{i,1} = 'new';
            
        else
            keyisdown = 0;
        end
        
        time = secs - t0;
        
        if strcmp(data{i,1},trial_type) == 1;
            data{i,5}='correct';
            switch trial_type
                case 'old',
                    data{i,6}='hit';
                case 'new',
                    data{i,6}='correct_reject';
            end
        else
            data{i,5}='incorrect';
            switch trial_type
                case 'old',
                    data{i,6}='miss';
                case 'new',
                    data{i,6}='false_alarm';
            end
        end
        accu = data{i,5};
        if keycode(old) || keycode(new)
            NetStation('Event', accu,GetSecs+.010  ,.010,  'tri#', i,'resp',data{i,1}, 'hrz#', data{i,2}, 'stim', stim)
            
        end
    end
  
    
    
    %NetStation('Event', accu,GetSecs+.010  ,.010,  'tri#', i, 'resp', data{i,1})
      if time >= 3
                res = 'none';
                data{i,1} = 'NoRe';
                NetStation('Event', 'nore',GetSecs+.010  ,.010,  'tri#', i, 'resp', data{i,1}, 'hrz#', data{i,2}, 'stim', stim)
                
%                 recog_data{i,3}='No Response';
                Screen('TextSize',w,24);
                text='You did not make your response in time.';
                width=RectWidth(Screen('TextBounds',w,text));
                Screen('DrawText',w,text,x0-width/2,y0-50,[0 0 0]); 
                text='Press any key to continue...';
                width=RectWidth(Screen('TextBounds',w,text));
                Screen('DrawText',w,text,x0-width/2,y0,[0 0 0]);
                Screen('Flip',w);
                
      end
    
        
    data{i,11} = time;
    data{i,3} = trial_type;
     
    if strcmp(data{i,1},'NoRe')~=1;
            %break time
        Screen('TextSize',w,24);
        text='Press any key to continue...';
        width=RectWidth(Screen('TextBounds',w,text));
        Screen('DrawText',w,text,x0-width/2,y0,[0 0 0]);        
        Screen('Flip',w);
        
    end
    pause;

    Screen('DrawTexture',w,fix_tex,[],fix_rect);
    Screen('Flip',w);
        
    % Signal Detection Data Setup
    
%     if strcmp(data{i,1},trial_type) == 1;
%         data{i,5}='correct';
%         switch trial_type
%             case 'old',
%                 data{i,6}='hit';
%             case 'new',
%                 data{i,6}='correct_reject';
%         end
%     else
%         data{i,5}='incorrect';
%         switch trial_type
%             case 'old',
%                 data{i,6}='miss';
%             case 'new',
%                 data{i,6}='false_alarm';
%         end
%     end
%     
%     accu = data{i,5};
%     NetStation('Event', accu,GetSecs+.010  ,.010,  'tri#', i, 'resp', data{i,1})
% % % % % % % % % %     if data{i,5} ='correct';
% % % % % % % % % %         accu = 'corr';
% % % % % % % % % %     elseif data{i,5} = 'incorrect';
% % % % % % % % % %         accu = 'inco';
% % % % % % % % % %     else
% % % % % % % % % %         accu = 'nore';
% % % % % % % % % %     end
       
       %Original color of the object in the array that will get probed
    data{i,7} = probe;
    switch i
        case 1,
            starter = run_start;
                data{i,8} = 0;
        otherwise
                data{i,8} = run_start - starter;
    end
    
    WaitSecs(1+.5-rand());
    
    data{i,12} = target_pos;
%     
%         %%%%%%%% record frequencies
%         freq_record{i,1} = trial_rates(1);
%         freq_record{i,2} = trial_rates(2);
 
    save(output_name);
    save(data_name,'data');
    
 end
 
%         if i==num_trials/4;                         %give progress feedback
%             WaitSecs(1);    
%             Screen('TextSize',w,24);
%             text='You are 25% of the way there! Feel free to take a break.';
%             width=RectWidth(Screen('TextBounds',w,text));
%             Screen('DrawText',w,text,xc-width/2,yc,[0 0 0]);
%             text='Press Space Bar To Continue';
%             width=RectWidth(Screen('TextBounds',w,text));
%             Screen('DrawText',w,text,xc-width/2,yc+50,[0 0 0]);
%             Screen('Flip',w);
%             
%             KbWait;
%         end
%         
%         if i==num_trials/2;
%             WaitSecs(1);
%             Screen('TextSize',w,24);
%             text='You are 50% of the way there! Feel free to take a break.';
%             width=RectWidth(Screen('TextBounds',w,text));
%             Screen('DrawText',w,text,xc-width/2,yc,[0 0 0]);
%             text='Press Space Bar To Continue';
%             width=RectWidth(Screen('TextBounds',w,text));
%             Screen('DrawText',w,text,xc-width/2,yc+50,[0 0 0]);
%             Screen('Flip',w);
%             
%             KbWait;
%         end
%         
%         if i==num_trials/(4/3);
%             WaitSecs(1);
%             Screen('TextSize',w,24);
%             text='You are 75% of the way there! Feel free to take a break.';
%             width=RectWidth(Screen('TextBounds',w,text));
%             Screen('DrawText',w,text,xc-width/2,yc,[0 0 0]);
%             text='Press Space Bar To Continue';
%             width=RectWidth(Screen('TextBounds',w,text));
%             Screen('DrawText',w,text,xc-width/2,yc+50,[0 0 0]);
%             Screen('Flip',w);
%             
%             KbWait;
%         end
%         
        
        
        
        
 
end

%%% accuracy data
 
 
for a = 1:num_trials
    if strcmp(data{a,5},'correct')==1
        corr_trial = corr_trial + 1;
        
        if data{a,9}==2
        corr_2stim = corr_2stim + 1;
        
            if data{a,2}==3
            corr_2stim_3hz = corr_2stim_3hz +1;
            
            elseif data{a,2}==5
            corr_2stim_5hz = corr_2stim_5hz +1;
            
            end
        
        elseif data{a,9}==4
        corr_4stim = corr_4stim + 1;
        
            if data{a,2}==3
            corr_4stim_3hz = corr_4stim_3hz +1;
            
            elseif data{a,2}==5
            corr_4stim_5hz = corr_4stim_5hz +1;
            
            elseif data{a,2}==12
            corr_4stim_12hz = corr_4stim_12hz +1;
            
            elseif data{a,2}==20
            corr_4stim_20hz = corr_4stim_20hz +1;
            
            end
        
        end
    end
end
 
freq_trial_val = num_trials/6; 

Stimulus_accuracies{1,1} = 3;
Stimulus_accuracies{1,2} = 5;
Stimulus_accuracies{1,3} = 12;
Stimulus_accuracies{1,4} = 20;
Stimulus_accuracies{2,1} = (corr_2stim_3hz/freq_trial_val);
Stimulus_accuracies{2,2} = (corr_2stim_5hz/freq_trial_val);
Stimulus_accuracies{3,1} = (corr_4stim_3hz/freq_trial_val);
Stimulus_accuracies{3,2} = (corr_4stim_5hz/freq_trial_val);
Stimulus_accuracies{3,3} = (corr_4stim_12hz/freq_trial_val);
Stimulus_accuracies{3,4} = (corr_4stim_20hz/freq_trial_val);

freq_trial_sdt = num_trials/6;

for a = 1:num_trials
    if data{a,9}==2
        
        if data{a,2}==3
            if strcmp(data{a,6},'hit')==1
                stim2_3hz_hit = stim2_3hz_hit + 1;
                
            elseif strcmp(data{a,6},'false_alarm')==1
                stim2_3hz_far = stim2_3hz_far + 1;
                
            end
            
        elseif data{a,2}==5
            if strcmp(data{a,6},'hit')==1
                stim2_5hz_hit = stim2_5hz_hit + 1;
                
            elseif strcmp(data{a,6},'false_alarm')==1
                stim2_5hz_far = stim2_5hz_far + 1;
                
            end
        
        end
        
    elseif data{a,9}==4
        
        if data{a,2}==3
            if strcmp(data{a,6},'hit')==1
                stim4_3hz_hit = stim4_3hz_hit + 1;
                
            elseif strcmp(data{a,6},'false_alarm')==1
                stim4_3hz_far = stim4_3hz_far + 1;
                
            end
            
        elseif data{a,2}==5
            if strcmp(data{a,6},'hit')==1
                stim4_5hz_hit = stim4_5hz_hit + 1;
                
                
            elseif strcmp(data{a,6},'false_alarm')==1
                stim4_5hz_far = stim4_5hz_far + 1;
                
            end
        elseif data{a,2}==12
            if strcmp(data{a,6},'hit')==1
                stim4_12hz_hit = stim4_12hz_hit + 1;
                
                
            elseif strcmp(data{a,6},'false_alarm')==1
                stim4_12hz_far = stim4_12hz_far + 1;
                
            end
        elseif data{a,2}==20
            if strcmp(data{a,6},'hit')==1
                stim4_20hz_hit = stim4_20hz_hit + 1;
                
                
            elseif strcmp(data{a,6},'false_alarm')==1
                stim4_20hz_far = stim4_20hz_far + 1;
            end
        
        end
    end
end


stim_2_3hz_HR = (stim2_3hz_hit/freq_trial_sdt);
stim_2_5hz_HR = (stim2_5hz_hit/freq_trial_sdt);
stim_4_3hz_HR = (stim4_3hz_hit/freq_trial_sdt);
stim_4_5hz_HR = (stim4_5hz_hit/freq_trial_sdt);
stim_4_12hz_HR = (stim4_12hz_hit/freq_trial_sdt);
stim_4_20hz_HR = (stim4_20hz_hit/freq_trial_sdt);

stim_2_3hz_FAR = (stim2_3hz_far/freq_trial_sdt);
stim_2_5hz_FAR = (stim2_5hz_far/freq_trial_sdt);
stim_4_3hz_FAR = (stim4_3hz_far/freq_trial_sdt);
stim_4_5hz_FAR = (stim4_5hz_far/freq_trial_sdt);
stim_4_12hz_FAR = (stim4_12hz_far/freq_trial_sdt);
stim_4_20hz_FAR = (stim4_20hz_far/freq_trial_sdt);

K_vals{1,1} = 3;
K_vals{1,2} = 5;
K_vals{1,3} = 12;
K_vals{1,4} = 20;
K_vals{2,1} = 2*((stim_2_3hz_HR - stim_2_3hz_FAR)); 
K_vals{2,2} = 2*((stim_2_5hz_HR - stim_2_5hz_FAR));
K_vals{3,1} = 4*((stim_4_3hz_HR - stim_4_3hz_FAR));
K_vals{3,2} = 4*((stim_4_5hz_HR - stim_4_5hz_FAR));
K_vals{3,3} = 4*((stim_4_12hz_HR - stim_4_12hz_FAR));
K_vals{3,4} = 4*((stim_4_20hz_HR - stim_4_20hz_FAR));
 
 
corrects=zeros(1,num_trials);
sdts=zeros(4,num_trials);
confidences=zeros(2,num_trials);
for j =1:num_trials
corrects(j) = strcmp(data{j,5},'correct');
sdts(1,j)=strcmp(data{j,6},'hit');
sdts(2,j)=strcmp(data{j,6},'correct_reject');
sdts(3,j)=strcmp(data{j,6},'miss');
sdts(4,j)=strcmp(data{j,6},'false_alarm');
% confidences(1,j)=data{j,7}>=4;
% confidences(2,j)=data{j,7}<4;
 
end
Screen('TextSize',w,24);
text='Thank you for participating in this experiment! Please do not touch keyboard';
width=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-width/2,y0-100,[0 0 0]);
text='Let the experimenter know that you are finished!';
width=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-width/2,y0-50,[0 0 0]);
text='Have a fantastic day!!!!';
width=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-width/2,y0,[0 0 0]);
Screen('Flip',w);
NetStation('Disconnect');
KbWait;
% confidence = 100*sum(confidences')/num_trials;
percent_correct = 100*sum(corrects)/num_trials;
sdt = 100*sum(sdts')/num_trials;
figure(1)
subplot(3,1,1)
bar(percent_correct);
subplot(3,1,2);
bar(sdt');
% subplot(3,1,3);
% bar(confidence');
 
 
 
ListenChar(0);
ShowCursor;
Screen('CloseAll');

