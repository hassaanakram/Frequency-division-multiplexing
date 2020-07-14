%% SIGNALS AND SYSTEMS TERM PROJECT: GROUP E (BEE-10A)
%  Group Members:
%               Muhammad Hassaan
%               Muhammad Adil
%               Muhammad Haseeb Akhlaq
%               Musharraf Qadir
%               Muhammad Bilal
%               Muhammad Asad Khalil Rao

%% SYSTEM PIPELINE
%                 INPUT -> LOWPASS FILTERATION -> MODULATION -> SUMMATION
%                 BANDPASS FILTRATION -> DEMODULATION -> OUTPUT
Fs = 1000;
t = 0 : 1/Fs : 2*pi;
file = 'E:\Academics\Semester - 4\Signals and Systems\Term Project\Code\Audio Files\test1.ogg';
y = audioread(file);

L=length(y);                                     
f = Fs/2*linspace(0,1,L/2+1);  
X = fft(y)/L;                    
PSD=2*abs(X(1:L/2+1));
plot(f, PSD);