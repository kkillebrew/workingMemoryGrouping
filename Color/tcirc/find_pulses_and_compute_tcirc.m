%function [p] = find_pulses_and_compute_tcirc(name,eeg_path,threshold,samp_rate,num_chan,freq_tag)
%       Find impulse, checktiming and update EEGlab events file
%
%find_impulses_update_EEGlab_data(name,eeg_path,threshold)
%
%   name: base name of downsampled eegfile abd corresponding behave file
%   eeg_path: path to downsampled EEG file: just give the base name:
%       ie. 'keb_1' will assume '_ds' for downsampled data
%   threshold: the amplitude threshold for finding impulses: ie. 1000000
%   samp_rate = downsampled sampling rate: ie. 1000

% %For debugging in non-function mode
% clear
name = 'sub1';
 eeg_path = '/Users/C-Lab/Documents/Gena/Research/Frq_tags/all_data_maint/';
% trigger_chan_name =sprintf('%sakx_punct_cb_20-01_ds', eeg_path);
% eeg_name =  sprintf('%sakx_punct_cb_20-02_ds', eeg_path);
num_chan=3;
freq_tag = 3;
threshold= 500;
samp_rate=1000;

channel_list ={'O1','O2','Oz','P1','P2','C1','C2'};
trigger_chan_name =  sprintf('%s%s_%d-01_ds',eeg_path,name,freq_tag);

data_downsample = 'sub1_3-01_ds.mat';

pts_2_uV = 36611;
load(trigger_chan_name);
trigger_data = data_downsample;
trigger_data = trigger_data/pts_2_uV;
% Find event TIMES FROM PHOTODIODE PULSES
%NOTE: IN order for this to work: A) you must get rid of Screen on and
%Screen off photodiode pulses at the begninng and end of audacity file

%find all samples greater than threshold: Note this will often grab more
%than one sample per impulse so we need to get rid of all extra samples
above_thresh=find(trigger_data>threshold);
%Here we look for contiguous samples above threshold, these are the 'extras
% ' that we want to get rid of
above_thresh_starts = diff(above_thresh)>500;
above_thresh_starts= insertrows(above_thresh_starts',1,1)';
impulses = above_thresh_starts==1;
%trial start is an array of event times in "samples" we can use this array
%to cross reference with the raw data file to verify that these times
%infact correspond to photdiode events
text_out=sprintf('found %d above thresh',length(above_thresh));
disp(text_out);
text_out=sprintf('found %d impulses',length(impulses));
disp(text_out);
trial_start = above_thresh(impulses);
text_out=sprintf('found %d events in EEG data',length(trial_start));
disp(text_out);
load('fig_temp');
for j = 4:num_chan
    eeg_name =  sprintf('%s%s_%d-0%d_ds',eeg_path,name,freq_tag,j);
    load(eeg_name);
    eeg_data = data_downsample;
    for i = 1:length(trial_start)
        cur_eeg_data = eeg_data(trial_start(i):trial_start(i)+samp_rate -1);
        cur_trig_data= trigger_data(trial_start(i):trial_start(i)+samp_rate-1);
        %         figure(j)
        %         subplot(2,1,1)
        %         plot(cur_trig_data);
        %         subplot(2,1,2)
        %         plot(cur_eeg_data);
        fourier_coefs(i,:) = fft(cur_eeg_data);
    end
    [mean_freq criterion p] = t2circ_1tag_sqrt(fourier_coefs,.05,freq_tag);
    figure(fig_num)
    subplot(2,num_chan-1,j-1);
    stem(0:62,abs(mean_freq(1:63)),'b.','LineWidth',2);
    if p(freq_tag+1) < 0.05
        hold on
        stem(freq_tag,abs(mean_freq(freq_tag+1)),'r.','LineWidth',2);
    end
    if p(2*freq_tag+1) < 0.05
        hold on
        stem(2*freq_tag,abs(mean_freq(2*freq_tag+1)),'r.','LineWidth',2);
     end
      if p(3*freq_tag+1) < 0.05
        hold on
        stem(3*freq_tag,abs(mean_freq(3*freq_tag+1)),'r.','LineWidth',2);
      end
     xlabel('Hz','FontSize',16,'FontWeight','bold')
     ylabel('Fourier Magnitude','FontSize',14,'FontWeight','bold')
     set(gca,'FontSize',16,'FontWeight','bold')
     set(gca,'FontSize',16,'FontWeight','bold')
     set(gca,'xlim',[0,63]);
     title_string = sprintf('name: %s cond: %s\n Tag %dHz, Chan %s',name(1:3),name(5:8),freq_tag,channel_list{j-1});
     title(title_string);
        subplot(2,num_chan-1,num_chan+j-2);
     polar(0,abs(mean_freq(freq_tag+1))+.25*abs(mean_freq(freq_tag+1)));

    hold on
    polar([0,angle(mean_freq(freq_tag+1))],[0,abs(mean_freq(freq_tag+1))],'r-');
    polar(angle(mean_freq(freq_tag+1)+criterion(freq_tag+1,:))',abs(mean_freq(freq_tag+1)+criterion(freq_tag+1,:))','b');
    th = findall(gca,'Type','text');
    for ii = 1:length(th),
        set(th(ii),'FontSize',16,'FontWeight','bold')
    end
    hlines = findall(gca,'Type','line');
    for ii = 1:length(hlines)
        set(hlines(ii),'LineWidth',2);
    end
end
    fig_num=fig_num+1;
    save('fig_temp','fig_num');
