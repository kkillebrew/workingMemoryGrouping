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
[w,rect]=Screen('OpenWindow',0,[128 128 128]);
% Sets the inputs to come in from the other computer
[nums, names] = GetKeyboardIndices;
dev_ID=nums(1);
con_ID=nums(1);

% Basic variables
% These are coordinates for the different images
% coordinates of screen center
x0 = rect(3)/2;
y0 = rect(4)/2;
%centers ul_c
corner_centers(1,:)= [x0-x0/5;...
    y0-y0/2;...
    x0-x0/5;...
    y0-y0/2];
%ur_c
corner_centers(2,:)= [x0+x0/5;...
    y0-y0/2;...
    x0+x0/5;...
    y0-y0/2];
%ll_c
corner_centers(3,:)= [x0-x0/5;...
    y0+y0/2;...
    x0-x0/5;...
    y0+y0/2];
%lr_c
corner_centers(4,:)= [x0+x0/5;...
    y0+y0/2;...
    x0+x0/5;...
    y0+y0/2];
%Inputs
buttonO = KbName('o');
buttonN = KbName('n');
buttonOne = KbName('1!');
buttonTwo = KbName('2@');
buttonThree = KbName('3#');
buttonFour = KbName('4$');
buttonFive = KbName('5%');
buttonSix = KbName('6^');
buttonSeven = KbName('7&');
buttonEscape = KbName('Escape');
% list of proportion of total trials at which to offer subject a self-timed break
break_trials = .1:.1:.9;
% various colors
gray = [128 128 128];
black = [0 0 0];
white = [255 255 255];
% Screen refresh rate and trial length
hz=120;
trial_length=1;
% Demo variables
groupSwitch = 1;
presSwitch = 1;

%array size
stim_size = 100;
stim_array = [-stim_size;...
    -stim_size;...
    stim_size;...
    stim_size];

% Here you create the textures that contain your objects
% Create blank arrays with the size and background color you want you
% objects to be (if you're using images load them in instead)
array1=zeros(stim_size*2,stim_size*2);
array2=255*ones(stim_size*2,stim_size*2);
array3=128*ones(stim_size*2,stim_size*2);

% Create the texture
t1(1)=Screen('MakeTexture',w,array1);
t1(2)=Screen('MakeTexture',w,array2);

t2(1)=Screen('MakeTexture',w,array3);
t2(2)=Screen('MakeTexture',w,array3);

t3(1)=Screen('MakeTexture',w,array3);
t3(2)=Screen('MakeTexture',w,array3);

t4(1)=Screen('MakeTexture',w,array3);
t4(2)=Screen('MakeTexture',w,array3);

% You can then draw shapes to the textures
Screen('FillOval',t2(1),black,[0,0,stim_size*2,stim_size*2]);
Screen('FillOval',t2(2),white,[0,0,stim_size*2,stim_size*2]);

Screen('FillPoly',t3(1),black,[0,stim_size*2;stim_size,0;stim_size*2,stim_size*2]);
Screen('FillPoly',t3(2),white,[0,stim_size*2;stim_size,0;stim_size*2,stim_size*2]);

Screen('FillPoly',t4(1),black,[0,stim_size;...
    stim_size,stim_size*2;...
    stim_size*2,stim_size;...
    stim_size,0]);
Screen('FillPoly',t4(2),white,[0,stim_size;...
    stim_size,stim_size*2;...
    stim_size*2,stim_size;...
    stim_size,0]);


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



% Freq tagging variables
%Flicker Frequency Rates (3 Hz, 5 Hz, 12 Hz, 20 Hz)
stim_rate(1) = 3;
stim_rate(2) = 5;
stim_rate(3) = 12;
stim_rate(4) = 20;



[keyIsDown, secs, keycode] = KbCheck(dev_ID);
while ~keycode(buttonEscape)

    % Set the counter to determine when to flip each object
    firstp=1;
    secondp=1;
    thirdp=1;
    fourthp=1;
    
    % Give all priority to the program
    Priority(MaxPriority(w));
    
    Screen('DrawingFinished',w,2);
    the_start=Screen('Flip',w,[],2);
    start_time(1:4)=GetSecs;
    bob=0;
    
    % Set the initial flip time to start of trial
    flip1=the_start;
    flip2=the_start;
    flip3=the_start;
    flip4=the_start;
    
    % Determine the position of the objects with some jitter
    for j=1:4
        %         x_rand = 50-10*randi(10);
        %         y_rand = 50-10*randi(10);
        x_rand = 0;
        y_rand = 0;
        rand_array = [x_rand;...
            y_rand;...
            x_rand;...
            y_rand];
        destrect(j,:) = (corner_centers(j,:)' + stim_array + rand_array);
    end
    % randomly assigns the four images a flickering rate
    % stim_rate is the rate of flickering
    trial_rates=randperm(4);
    rate11=1/(2*stim_rate(trial_rates(1)));
    rate22=1/(2*stim_rate(trial_rates(2)));
    rate33=1/(2*stim_rate(trial_rates(3)));
    rate44=1/(2*stim_rate(trial_rates(4)));
    % All initial timing/synch goes here
    
    % duration of TTL pulse to account for ahardware lag
    TTL_pulse_dur = 0.0015;
    
    [keyIsDown, secs, keycode] = KbCheck(dev_ID);
    breakCase = 0;
    
    if keycode(buttonFour)
        presSwitch = 1;
        KbReleaseWait;
    elseif keycode(buttonFive)
        presSwitch = 2;
        KbReleaseWait;
    end
    % switch between 4-square and 5-line presentation
    if presSwitch == 1
        for j=1:4
            %         x_rand = 50-10*randi(10);
            %         y_rand = 50-10*randi(10);
            x_rand = 0;
            y_rand = 0;
            rand_array = [x_rand;...
                y_rand;...
                x_rand;...
                y_rand];
            destrect(j,:) = (corner_centers(j,:)' + stim_array + rand_array);
        end
    elseif presSwitch == 2
        spacing = 50;
        linePresArray(1,:) = [x0-stim_size*3-spacing*1.5,y0,x0-stim_size*3-spacing*1.5,y0];
        linePresArray(2,:) = [x0-stim_size-spacing/2,y0,x0-stim_size-spacing/2,y0];
        linePresArray(3,:) = [x0+stim_size+spacing/2,y0,x0+stim_size+spacing/2,y0];
        linePresArray(4,:) = [x0+stim_size*3+spacing*1.5,y0,x0+stim_size*3+spacing*1.5,y0];
        
        for j=1:4
            %         x_rand = 50-10*randi(10);
            %         y_rand = 50-10*randi(10);
            x_rand = 0;
            y_rand = 0;
            rand_array = [x_rand;...
                y_rand;...
                x_rand;...
                y_rand];
            destrect(j,:) = (linePresArray(j,:)' + stim_array + rand_array);
        end
        
        Screen('Flip',w);
    end
    
    
    if keycode(buttonOne)
       groupSwitch = 1;
       KbReleaseWait;
    elseif keycode(buttonTwo)
        groupSwitch =2;
        KbReleaseWait;
    elseif keycode(buttonThree)
        groupSwitch = 3;
        KbReleaseWait;
    end
    % switch between 1-different 2-same far 3-same close
    if groupSwitch == 1
        % You can then draw shapes to the textures
        Screen('FillOval',t2(1),black,[0,0,stim_size*2,stim_size*2]);
        Screen('FillOval',t2(2),white,[0,0,stim_size*2,stim_size*2]);
        
        Screen('FillPoly',t3(1),black,[0,stim_size*2;stim_size,0;stim_size*2,stim_size*2]);
        Screen('FillPoly',t3(2),white,[0,stim_size*2;stim_size,0;stim_size*2,stim_size*2]);
        
        Screen('FillRect',t4(1),gray,[0,0,stim_size*2,stim_size*2]);
        Screen('FillRect',t4(2),gray,[0,0,stim_size*2,stim_size*2]);
        Screen('FillPoly',t4(1),black,[0,stim_size;...
            stim_size,stim_size*2;...
            stim_size*2,stim_size;...
            stim_size,0]);
        Screen('FillPoly',t4(2),white,[0,stim_size;...
            stim_size,stim_size*2;...
            stim_size*2,stim_size;...
            stim_size,0]);
    elseif groupSwitch == 2
        % You can then draw shapes to the textures
        Screen('FillOval',t2(1),black,[0,0,stim_size*2,stim_size*2]);
        Screen('FillOval',t2(2),white,[0,0,stim_size*2,stim_size*2]);
        
        Screen('FillPoly',t3(1),black,[0,stim_size*2;stim_size,0;stim_size*2,stim_size*2]);
        Screen('FillPoly',t3(2),white,[0,stim_size*2;stim_size,0;stim_size*2,stim_size*2]);
        
        Screen('FillRect',t4(1),gray,[0,0,stim_size*2,stim_size*2]);
        Screen('FillRect',t4(2),gray,[0,0,stim_size*2,stim_size*2]);
        Screen('FillPoly',t4(1),black,[0,stim_size*2;stim_size,0;stim_size*2,stim_size*2]);
        Screen('FillPoly',t4(2),white,[0,stim_size*2;stim_size,0;stim_size*2,stim_size*2]);
    elseif groupSwitch == 3
        % You can then draw shapes to the textures
        Screen('FillOval',t2(1),black,[0,0,stim_size*2,stim_size*2]);
        Screen('FillOval',t2(2),white,[0,0,stim_size*2,stim_size*2]);
        
        Screen('FillPoly',t3(1),black,[0,stim_size*2;stim_size,0;stim_size*2,stim_size*2]);
        Screen('FillPoly',t3(2),white,[0,stim_size*2;stim_size,0;stim_size*2,stim_size*2]);
        
        Screen('FillRect',t4(1),gray,[0,0,stim_size*2,stim_size*2]);
        Screen('FillRect',t4(2),gray,[0,0,stim_size*2,stim_size*2]);
        Screen('FillPoly',t4(1),black,[0,stim_size*2;stim_size,0;stim_size*2,stim_size*2]);
        Screen('FillPoly',t4(2),white,[0,stim_size*2;stim_size,0;stim_size*2,stim_size*2]);
    end
    
    
    while breakCase == 0
        [keyIsDown, secs, keycode] = KbCheck(dev_ID);
        
        
        
        % record rawdata values for stimtypes (from trialorder and varlist)
        
        
        %     % randomly chooses the target
        %     target = im(randi(4));
        %     if target == im(1)
        %         target_pos = 1;
        %     elseif target == im(2)
        %         target_pos = 2;
        %     elseif target == im(3)
        %         target_pos = 3;
        %     elseif target == im(4);
        %         target_pos = 4;
        %     end
        
        % Try not to use if's or for's as they consume a lot of time
        % Time each trial to break at the end of alloted time
        time_now=GetSecs;
        trial_check=(time_now-the_start)>trial_length;
        
        switch trial_check
            case 0
                
                % Use the rate and time since last flip to determine when to
                % flip the object next
                check1= (time_now-flip1)>rate11-1/hz;
                check2= (time_now-flip2)>rate22-1/hz;
                check3= (time_now-flip3)>rate33-1/hz;
                check4= (time_now-flip4)>rate44-1/hz;
                
                % If enough time has passed since last flip then flip object
                % and set variable to refresh the screen
                switch check1
                    case 1
                        flip1=flip1+rate11;
                        firstp=3-firstp;
                        bob=1;
                    otherwise,
                end
                
                switch check2
                    case 1
                        flip2=flip2+rate22;
                        secondp=3-secondp;
                        bob=1;
                    otherwise,
                end
                
                switch check3
                    case 1
                        flip3=flip3+rate33;
                        thirdp=3-thirdp;
                        bob=1;
                    otherwise,
                end
                
                switch check4
                    case 1
                        flip4=flip4+rate44;
                        fourthp=3-fourthp;
                        bob=1;
                    otherwise,
                end
                
                % If any objects changed flip the screen
                switch bob
                    case 1
                        
                        switch groupSwitch
                            case 1
                                Screen('DrawTextures',w,[t1(firstp),t2(secondp),t3(thirdp),t4(fourthp)],[],[destrect(1,:);destrect(2,:);destrect(3,:);destrect(4,:)]');
                            case 2
                                Screen('DrawTextures',w,[t1(firstp),t2(secondp),t3(thirdp),t4(fourthp)],[],[destrect(1,:);destrect(2,:);destrect(3,:);destrect(4,:)]');
                            case 3
                                Screen('DrawTextures',w,[t3(firstp),t2(secondp),t1(thirdp),t4(fourthp)],[],[destrect(1,:);destrect(2,:);destrect(3,:);destrect(4,:)]');
                        end
                        
                        Screen('DrawingFinished',w,2);
                        Screen('Flip',w,time_now,2);
                        bob=0;
                        
                        % Case added to ensure program doesn't run so fast as
                        % to lose priority
                    case 0
                        WaitSecs(.0005);
                end
            case 1
                breakCase = 1;
                
        end
        
        
    end
end


ShowCursor;
ListenChar(0)
Screen('CloseAll')









