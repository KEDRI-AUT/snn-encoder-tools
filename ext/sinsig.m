function [ signal,clean ] = sinsig( answer )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

Fs=str2num(answer{1});
stop=str2num(answer{2});

white=str2num(answer{4});
Fs=1000; %Hz
time=0:1/Fs:stop;

f_sin=eval(answer{3});
pwr_sin=rand(size(f_sin));
pwr_sin=pwr_sin*10;

clean=zeros(length(time),1);

for i = 1:length(f_sin)
   
    clean=clean+pwr_sin(i)*sin(2*pi*f_sin(i)*time+rand*2*pi)';
    
end

if white ~=0
    white_noise = wgn(length(time),1,0);
    signal = clean  + white*white_noise*(mean(pwr_sin));

else
    signal=clean;
end

end

