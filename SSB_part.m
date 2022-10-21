%% part II step 5a - apply SSB-SC modulation 


%upsampling
up_sampling_ratio = 10;
fs = fs *up_sampling_ratio;
%adjusting t with the new sampling rate
t = [0:1/fs:T-1/fs]; 
upsampled_filtered_rec1=interp(filtered_rec1,up_sampling_ratio);

% modulating
sin_c = sin(2*pi*48000*t');
cos_c = cos(2*pi*48000*t');

hilbert_upsampled_filtered_rec1 = imag(hilbert(upsampled_filtered_rec1)) ;
part1= upsampled_filtered_rec1.*cos_c;
part2= hilbert_upsampled_filtered_rec1.*sin_c;

SSB_rec1 = part1 - part2;

%% part II step 5b - plot the SSB-SC 
%getting spectrum
SSB_rec1_fft = fft(SSB_rec1);
L=length(SSB_rec1_fft);
f= [-L/2:L/2-1]*fs/L; 
SSB_rec1_fft = fftshift(SSB_rec1_fft);


%plotting t domain
figure(1);
subplot(5,1,3);
plot(t,SSB_rec1);
title('SSB-SC  Signal in time domain');
xlabel('time (s)');
ylabel('Amplitude');

%plotting f domain
figure(2);
subplot(5,1,3);
plot(f, abs(SSB_rec1_fft), 'r');
title('SSB-SC Signal in frequency domain');
xlabel('frequency (Hz)');
ylabel('Amplitude');


%% part II step 6 - Demodulate SSB-SC coherently and Playback the recovered signal
% multiplying by a synchoronous carrier
f_off = 0;
c_demod = cos((2*pi*48000+f_off)*t);
demod_SSB_rec1 = 2*SSB_rec1.*c_demod';

% passing the signal through an LPF
N = 6;
fc = 3400;
[b,a] = butter(N,2*fc/fs);
demod_SSB_rec1=filter(b,a,demod_SSB_rec1);

% to counter the effect of upsampling
demod_SSB_rec1 =downsample(demod_SSB_rec1 , up_sampling_ratio);
fs = fs / up_sampling_ratio;
t = [0:1/fs:T-1/fs]; 

%playing the signal 
pause(8);
disp("now playing demodulated SSB-SC signal");
sound(demod_SSB_rec1,fs);


%% part II step 7 - Plot the demodulated signal in both domains
%getting spectrum
demod_SSB_rec1_fft = fft(demod_SSB_rec1);
L=length(demod_SSB_rec1_fft);
f= [-L/2:L/2-1]*fs/L; 
demod_SSB_rec1_fft = fftshift(demod_SSB_rec1_fft);

%plotting t domain
figure(1);
subplot(5,1,4);
plot(t,demod_SSB_rec1);
title('demodulated SSB-SC  Signal in time domain');
xlabel('time (s)');
ylabel('Amplitude');

%plotting f domain
figure(2);
subplot(5,1,4);
plot(f, abs(demod_SSB_rec1_fft), 'r');
title('demodulated SSB-SC Signal in frequency domain');
xlabel('frequency (Hz)');
ylabel('Amplitude');


%% part II step 8 - Add several values of frequency offset to the Rx LO. Playback the recovered signal 
% we just play the SSB-SC modulation part again after replacing f_off = 0;
% by f_off = k ; where k is the frequency offset for the Rx LO

% RESULTS
% Adding a frequency offset causes a disturbance to the demodulated signal
% The more the offset the more the disturbance