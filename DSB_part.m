%% part II step 1a - doing DSB-SC modulation

%upsampling
up_sampling_ratio = 10;
fs = fs *up_sampling_ratio;
%adjusting t with the new sampling rate
t = [0:1/fs:T-1/fs]; 
upsampled_filtered_rec1=interp(filtered_rec1,up_sampling_ratio);

% modulating
c = cos(2*pi*48000*t);
DSB_rec1= upsampled_filtered_rec1.*c';
%% part II step 1b- plotting DSB-SC signal in t and f domains
%getting spectrum
DSB_rec1_fft = fft(DSB_rec1);
L=length(DSB_rec1_fft);
f= [-L/2:L/2-1]*fs/L; 
DSB_rec1_fft = fftshift(DSB_rec1_fft);


%plotting t domain
figure(1);
subplot(5,1,3);
plot(t,DSB_rec1);
title('DSB-SC  Signal in time domain');
xlabel('time (s)');
ylabel('Amplitude');

%plotting f domain
figure(2);
subplot(5,1,3);
plot(f, abs(DSB_rec1_fft), 'r');
title('DSB-SC Signal in frequency domain');
xlabel('frequency (Hz)');
ylabel('Amplitude');

%% part II step 2 - demodulate DSB-SC + play it
% multiplying by a synchoronous carrier
f_off = 0;
c_demod = cos((2*pi*48000+f_off)*t);
demod_DSB_rec1 = 2*DSB_rec1.*c_demod';

% passing the signal through an LPF
N = 6;
fc = 3400;
[b,a] = butter(N,2*fc/fs);
demod_DSB_rec1=filter(b,a,demod_DSB_rec1);


% to counter the effect of upsampling
demod_DSB_rec1 =downsample(demod_DSB_rec1 , up_sampling_ratio);
fs = fs / up_sampling_ratio;
t = [0:1/fs:T-1/fs]; 

%playing the signal 
pause(8);
disp("now playing demodulated DSB-SC signal");
sound(demod_DSB_rec1,fs);
%% part II step 3 - plot demodulated DSB-SC in t and f domains
%getting spectrum
demod_DSB_rec1_fft = fft(demod_DSB_rec1);
L=length(demod_DSB_rec1_fft);
f= [-L/2:L/2-1]*fs/L; 
demod_DSB_rec1_fft = fftshift(demod_DSB_rec1_fft);

%plotting t domain
figure(1);
subplot(5,1,4);
plot(t,demod_DSB_rec1);
title('demodulated DSB-SC  Signal in time domain');
xlabel('time (s)');
ylabel('Amplitude');

%plotting f domain
figure(2);
subplot(5,1,4);
plot(f, abs(demod_DSB_rec1_fft), 'r');
title('demodulated DSB-SC Signal in frequency domain');
xlabel('frequency (Hz)');
ylabel('Amplitude');

%% part II step 4 - add value of frequency offset to the Rx LO and playback the recovered
% we just play the DSB-SC modulation part again after replacing f_off = 0;
% by f_off = k ; where k is the frequency offset for the Rx LO 

% RESULTS
% Adding a frequency offset causes a disturbance to the demodulated signal
% The more the offset the more the disturbance