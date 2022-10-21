%% part III step 1a - apply FM modulation 
% upsampling
up_sampling_ratio = 10;
fs = fs *up_sampling_ratio;

%adjusting t with the new sampling rate
t = [0:1/fs:T-1/fs]; 
upsampled_filtered_rec1=interp(filtered_rec1,up_sampling_ratio);

Beta1 = 3;
Beta2 = 5;

% finding mp
mp = max(abs(upsampled_filtered_rec1));
% FM signal in case 1
delta_f1 = Beta1*fc;  % fc is cutoff frequency of the filter and band of the signal
kf1= (2*pi*delta_f1)/mp;
Ac = max(abs(upsampled_filtered_rec1));

FM3 = Ac.* cos((2*48000*pi.*t) + (kf1*cumsum((upsampled_filtered_rec1.'))*(1/fs)));  

% FM signal in case 2
delta_f2 = Beta2*fc;  % fc is cutoff frequency of the filter and band of the signal
kf2= (2*pi*delta_f2)/mp;
Ac = max(abs(upsampled_filtered_rec1));

FM5 = Ac.* cos((2*48000*pi.*t) + (kf2*cumsum((upsampled_filtered_rec1.'))*(1/fs)));  


%% part III step 1b - Plot FM signal in t and f domains (for case 1)
%getting spectrum
FM3_fft= fft(FM3);
L=length(FM3_fft);
f= [-L/2:L/2-1]*fs/L; 
FM3_fft = fftshift(FM3_fft);


%plotting t domain
figure(1);
subplot(5,1,3);
plot(t,FM3);
title('FM case 1  Signal in time domain');
xlabel('time (s)');
ylabel('Amplitude');

%plotting f domain
figure(2);
subplot(5,1,3);
plot(f, abs(FM3), 'r');
title('FM case 1 Signal in frequency domain');
xlabel('frequency (Hz)');
ylabel('Amplitude');

%% part III step 1b - Plot FM signal in t and f domains (for case 2)
%getting spectrum
FM5_fft= fft(FM5);
L=length(FM5_fft);
f= [-L/2:L/2-1]*fs/L; 
FM5_fft = fftshift(FM5_fft);


%plotting t domain
figure(1);
subplot(5,1,4);
plot(t,FM5);
title('FM case 2  Signal in time domain');
xlabel('time (s)');
ylabel('Amplitude');


%plotting f domain
figure(2);
subplot(5,1,4);
plot(f, abs(FM5), 'r');
title('FM case 2 Signal in frequency domain');
xlabel('frequency (Hz)');
ylabel('Amplitude');
%% part III - step 2 - recover the message with direct method + Playback the recovered signal (case 1)
FM_demod1 = diff(FM3);
envelope = hilbert(FM_demod1);
FM_demod1 = abs(envelope);
FM_demod1 = FM_demod1 - mean(FM_demod1);

% to counter the upsampling
FM_demod1  =downsample(FM_demod1 , up_sampling_ratio);
fs = fs / up_sampling_ratio;
t = [0:1/fs:T-1/fs]; 

disp("now playing demodulated FM signal for case 1");
pause(10);
sound(FM_demod1 ,fs);

%% part III - step 2 - recover the message with direct method + Playback the recovered signal (case 2)
FM_demod2 = diff(FM5);
envelope = hilbert(FM_demod2);
FM_demod2 = abs(envelope);

FM_demod2 = FM_demod2 - mean(FM_demod2);

% to counter the upsampling
FM_demod2  =downsample(FM_demod2 , up_sampling_ratio);

disp("now playing demodulated FM signal for case 2");
pause(10);
sound(FM_demod2 ,fs);

%% part III - step 2 - plot the recovered signal (case 1)
% plotting the demodualted signal in t domain 
figure(1);
subplot(5,1,5);
plot(t,FM_demod1);
title('demodulated FM Signal in time domain case 1 ');
xlabel('time (s)');
ylabel('Amplitude');

%getting spectrum
FM_demod1_fft = fft(FM_demod1);
L=length(FM_demod1_fft);
f= [-L/2:L/2-1]*fs/L; 
FM_demod1_fft = fftshift(FM_demod1_fft);

%plotting demodulated AM in f domain 
figure(2);
subplot(5,1,5);
plot(f, abs(FM_demod1_fft), 'r');
title('demodulated FM Signal in frequency domain - case 1');
xlabel('frequency (Hz)');
ylabel('Amplitude');

%% part III - step 2 - plot the recovered signal (case 2)
% plotting the demodualted signal in t domain 
figure(1);
subplot(5,1,5);
%plot(t,FM_demod2);
title('demodulated FM Signal in time domain - case 2');
xlabel('time (s)');
ylabel('Amplitude');

%getting spectrum
FM_demod2_fft = fft(FM_demod2);
L=length(FM_demod2_fft);
f= [-L/2:L/2-1]*fs/L; 
FM_demod2_fft = fftshift(FM_demod2_fft);

%plotting demodulated AM in f domain 
figure(2);
subplot(5,1,5);
%plot(f, abs(FM_demod2_fft), 'r');
title('demodulated FM Signal in frequency domain - case 2');
xlabel('frequency (Hz)');
ylabel('Amplitude');
