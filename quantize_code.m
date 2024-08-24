%% Assignment 1 - Q1
% Student Name: Kate Bowater
% Student Number: U1019160


% Recording voice using audiorecorder() function
% Sample rate 8kHz
% 16 bits per sample
clear all
close all
clc

fs = 8000; % frequency sample rate
tmax = 4;  % maximum time
num_bits = 16;  % number of bits. 2^16 levels
num_channels = 1; % number of channels
% activate the recorder
Recorder = audiorecorder(fs, num_bits, num_channels);
record(Recorder);
disp('Recording...');
pause(tmax);  % pause for the time tmax, then stop recording
stop(Recorder);
disp('Recording stopped.');

%% Convert to floating-point vector from -1 to 1 and play back audio
yi = getaudiodata(Recorder, 'int16');  % return 16 bit integer of recording
y = double(yi);  % double precision floating-point
y = y/max(abs(y));  % scaling by max
plot(y);
title('Original waveform')
ylabel('Amplitude')
xlabel('time')
grid on;
sound(y, fs);

%% Quantizing the audio samples
% Determine the number of quantization levels
qlevels = 2^(num_bits);  % 16 bits is the original
% the signal y must be multiplied to scale up to the required number of
% levels, rounded to quantize, then divided by the same to scale back to
% the range -1 to 1.
yq = round(y*qlevels)/qlevels; % using round quantizes it to the binary number
plot(yq);
title('Quantized Waveform 16 bits')
ylabel('Amplitude')
xlabel('time')
grid on;
sound(yq,fs);

%% Change the number of bits to check results and display SNR
clc
close all
num_bits = 1;
qlevels = 2^num_bits;
yq = round(y*qlevels)/qlevels; % quantizing as before with the new number of bits
plot(yq);
ylabel('Amplitude')
xlabel('time')
grid on;
sound(yq,fs);  % play the quantized sound at fs sample rate defined above
signal_error = y-yq;  % calculate the error: e = original - quantized signal
% the signal-to-noise ratio is the sum of the original signal squared
% divided by the error squared and converted to decibels for representation
SNR = 10*log10((sum(y.^2))/(sum(signal_error.^2)));
if (num_bits > 1) % condition for displaying plural bits or singular bit
   title(['Quantized Waveform ', num2str(num_bits), ' bits']);
   fprintf('SNR for %d bits is equal to %.2f\n', num_bits, SNR);
else
   title(['Quantized Waveform ', num2str(num_bits), ' bit']);
   fprintf('SNR for %d bit is equal to %.2f\n', num_bits, SNR); 
end
