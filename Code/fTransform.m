function [ axis, mag ] = fTransform( y, Fs )
% fTransform takes fft of input y with sampling frequency Fs
% and returns normalized magnitude plot and frequency (Hz) axis as a cell
% array

L=length(y);                                     
axis = Fs/2*linspace(0,1,L/2+1);  
X = fft(y)/L;                    
mag = 2*abs(X(1:L/2+1));

end

