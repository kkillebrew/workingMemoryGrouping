clear all
close all

% identify all the devices on the computer
d=PsychHID('Devices');
numDevices=length(d);
trigDevice=[];
dev=1;

% find the DAQ and tells you if the correct device is found
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
% trigDevice=4; %if this doesn't work, try 4
% Set port B to output, then make sure it's off
DaqDConfigPort(trigDevice,0,0);
DaqDOut(trigDevice,0,0);

% set up the screen for the photodiode and waits for a key pres once the
% user starts recording in netstation
white = 255;
black = 0;
Screen('Preference', 'SkipSyncTests', 0);
[w, rect] = Screen('OpenWindow',0);
white_tex = Screen('MakeTexture',w,white);
black_tex = Screen('MakeTexture',w,black);
Screen('DrawTexture',w,black_tex,[],rect);
Screen('Flip',w);
KbWait;
KbReleaseWait;

% change the loop amount depending on how many trials you want (each trial
% lasts around half a second)
for i = 1:7200
    time = Screen('Flip',w);
    DaqDOut(trigDevice,0,2)
    WaitSecs(.005);
    DaqDOut(trigDevice,0,0)
    Screen('DrawTexture',w,white_tex,[],rect);
    time=Screen('Flip',w,time);
    Screen('DrawTexture',w,black_tex,[],rect);
    Screen('Flip',w,time );
    % change this waitsecs to change length of trial
    WaitSecs(.5);
end