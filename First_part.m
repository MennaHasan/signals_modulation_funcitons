%% please play this file before using any of the other files
% this includes recording the voice signal, filtering it, plotting both
% it also includes the check performed to know the effect of fc on the
% sounds of some letters
%% part 1 step 1 - recording the voice signal with fs = 48Ksps
clc;
clear;

%preparing variables
T = 8; %duration of the record
fs = 48000; %sampling frequency 
ch = 1;
datatype = 'uint8';
nbits = 24;
t = [0:1/fs:T-1/fs]; % time axis

%recording
my_rec1 = audiorecorder(fs,nbits,ch);
disp('Start speaking.')
recordblocking(my_rec1, T);
disp('End of Recording.');

%playing what has been recorded
play(my_rec1);

%converting the recording object to a double vector
my_rec1 = getaudiodata(my_rec1);

%% part 1 step 2 - getting the signal spectrum

%getting spectrum
my_rec1_fft = fft(my_rec1);
L=length(my_rec1_fft);
f= [-L/2:L/2-1]*fs/L; 
my_rec1_fft = fftshift(my_rec1_fft);

%% part 1 step 3 - plotting the recorded signal in time and frequecny domains

figure(1);
subplot(5,1,1);
plot(t,my_rec1);
title('Audio Signal in time domain');
xlabel('time (s)');
ylabel('Amplitude');

figure(2);
subplot(5,1,1);
plot(f,abs(my_rec1_fft), 'r');
title('Audio Signal in frequency domain');
xlabel('frequency (Hz)');
ylabel('Amplitude');

%% part 1 step 4a - filter the recorded signal, LPF , fc = 3.4KHz

N = 6;
fc = 3400;
[b,a] = butter(N,2*fc/fs);
filtered_rec1=filter(b,a,my_rec1);

%% part 1 step 4b - plot the filtered in time and frequency domains + play it
% plot in t domain
figure(1);
subplot(5,1,2);
plot(t,filtered_rec1);
title('filtered Audio Signal in time domain');
xlabel('time (s)');
ylabel('Amplitude');

% get spectrum
filtered_rec1_fft = fft(filtered_rec1);
L=length(filtered_rec1_fft);
f= [-L/2:L/2-1]*fs/L; 
filtered_rec1_fft = fftshift(filtered_rec1_fft);

% plot in f domain 
figure(2);
subplot(5,1,2);
plot(f, abs(filtered_rec1_fft), 'r');
title('filtered Audio Signal in frequency domain');
xlabel('frequency (Hz)');
ylabel('Amplitude');

    %playing the filtered signal 
pause(8);
disp("now playing signal after filtering");
sound(filtered_rec1,fs);
%% part 1 step 5 and 6
% the same but change fc and see the difference 
N = 6;

fc = 1100;
[b,a] = butter(N,2*fc/fs);
filtered_rec1=filter(b,a,my_rec1);
sound(filtered_rec1,fs);

% RESULTS
% When the cutoff frequency of the filter is decreased the 
% signal gets less and less clear for the ears
% For b, d, they can be no longer identified when fc < 1700 Hz
% For f, s, they can be no longer identified when fc < 1800 Hz
% For n, m, they can be no longer identified when fc < 1100 Hz

