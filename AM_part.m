%% part 1 step 7a - getting AM modulated signal 
% upsampling
up_sampling_ratio = 10;
fs = fs *up_sampling_ratio;
%adjusting t with the new sampling rate
t = [0:1/fs:T-1/fs]; 

upsampled_filtered_rec1=interp(filtered_rec1,up_sampling_ratio);


% preparing constants
u = 0.8;
mp = max(abs(upsampled_filtered_rec1));
A = mp/u;

%getting AM signal
AM_rec1 = (A+upsampled_filtered_rec1).*cos(2*pi*48000.*t');
%% part 1 step 7b- plotting AM modulated signal and its spectrum
% plotting in t domain 
figure(1);
subplot(5,1,3);
plot(t,AM_rec1);
title('AM modulated Signal in time domain');
xlabel('time (s)');
ylabel('Amplitude');

% get spectrum
AM_rec1_fft = fft(AM_rec1);
L=length(AM_rec1_fft);
f= [-L/2:L/2-1]*fs/L; 
AM_rec1_fft = fftshift(AM_rec1_fft);

% plotting in f domain 
figure(2);
subplot(5,1,3);
plot(f, abs(AM_rec1_fft), 'r');
title('AM modualted  Audio Signal in frequency domain');
xlabel('frequency (Hz)');
ylabel('Amplitude');

%% part 1 step 8 - envelope detector to demodulate the AM signal 
% square the signal 
newsig= AM_rec1.*AM_rec1;

% filter the demodualted signal 
N2 = 3;
[b2,a2] = butter(N2,2*fc/fs);
AM_demod_rec1=filter(b2,a2,newsig);
%AM_demod_rec1 = (2*AM_demod_rec1(1:length(t)));
AM_demod_rec1 = (AM_demod_rec1(1:length(t)));
%AM_demod_rec1 = abs(sqrt(AM_demod_rec1));  %-A??

% to counter the effect of upsampling
AM_demod_rec1 =downsample(AM_demod_rec1 , up_sampling_ratio);
fs = fs / up_sampling_ratio;
t = [0:1/fs:T-1/fs]; 

%to make it centered at 0
AM_demod_rec1 = AM_demod_rec1-mean(AM_demod_rec1 ); %%TRY IT

%playing the demodualted singal
pause(8);
disp("now playing demodulated signal- before factor");
sound(AM_demod_rec1,fs);

figure(1);
subplot(5,1,4);
plot(t,AM_demod_rec1);
title('demodulated AM Signal - before factor in time domain');
xlabel('time (s)');
ylabel('Amplitude');
%% part 1 step 9 - Computing energies and getting factor
% getting factor
AM_rms = rms(AM_rec1);
demod_AM_rms = rms(AM_demod_rec1);
energy_factor = AM_rms /demod_AM_rms;

%doing multiplication 
AM_demod_rec1 = (energy_factor*AM_demod_rec1);
%% part 1 step 10 - Plotting the demodulated AM signal in both domains
% plotting the demodualted signal in t domain 
figure(1);
subplot(5,1,5);
plot(t,AM_demod_rec1);
title('demodulated AM Signal in time domain - after factor ');
xlabel('time (s)');
ylabel('Amplitude');

%getting spectrum
AM_demod_rec1_fft = fft(AM_demod_rec1);
L=length(AM_demod_rec1_fft);
f= [-L/2:L/2-1]*fs/L; 
AM_demod_rec1_fft = fftshift(AM_demod_rec1_fft);

%plotting demodulated AM in f domain 
figure(2);
subplot(5,1,4);
plot(f, abs(AM_demod_rec1_fft), 'r');
title('demodulated AM Signal in frequency domain');
xlabel('frequency (Hz)');
ylabel('Amplitude');

%playing the signal
pause(8);
disp("now playing demodulated signal- after factor");
sound(AM_demod_rec1,fs);