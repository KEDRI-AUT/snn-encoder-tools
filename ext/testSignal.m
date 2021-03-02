function [signal, Fs] = testSignal( testSignalType )
%testsignal Test signal generator
%   Stepwise, sinusoid, trended and event-like signals. As input, specify
%   which type to be generated.
switch testSignalType
    case  'Step-wise'
        base=[0 1.15 3.5 6.85 12.35 12.35 6.85 3.5 1.15 0];
        signal=0;
        i=1;
        while i<length(base)+1
            signal=vertcat(signal,base(i)*ones(100,1));  
            i=i+1;
        end
        Fs=1000;
    case 'Sinusoid'
        Fs=1000; %Hz
        time=0:1/Fs:1;
        f_sin=2:0.1:30;
        pwr_sin=rand(size(f_sin));
        pwr_sin=pwr_sin*10;
        clean=zeros(length(time),1);
        for i = 1:length(f_sin)
            clean=clean+pwr_sin(i)*sin(2*pi*f_sin(i)*time+1*rand*2*pi)';
            signal=clean;
        end
        white = randn(length(time),1);
        signal=signal+mean(pwr_sin)*white;
    case 'Trended'
        Fs=1000; %Hz
        time=0:1/Fs:1;
        f_sin=2:0.1:30;
        pwr_sin=rand(size(f_sin));
        pwr_sin=pwr_sin*10;
        clean=zeros(length(time),1);
        for i = 1:length(f_sin)
            clean=clean+pwr_sin(i)*sin(2*pi*f_sin(i)*time+1*rand*2*pi)';
        end
        signal=clean;
        white = randn(length(time),1);
        signal=signal+mean(pwr_sin)*white;
        trend=range(signal)*4*(1-exp(-time/1*4))';
        signal=signal+trend;
        signal=signal-min(signal);
    case 'Event-like'
        Fs=1000; %Hz
        time=0:1/Fs:1;
        f_sin=2:0.1:30;
        pwr_sin=rand(size(f_sin));
        pwr_sin=pwr_sin*10;
        clean=zeros(length(time),1);
        for i = 1:length(f_sin)
            clean=clean+pwr_sin(i)*sin(2*pi*f_sin(i)*time+1*rand*2*pi)';
        end
        signal=clean;
        signal=signal-mean(signal);
        signal=signal/max(signal)*5;
        % ERP addition
        xt=[-250 0 50 120 200 220 240 340 400 480 499 750]+250;
        yt=[   0 0  5 -55  26  29  24  22 -27   0   0   0];
        erp=pchip(xt,yt,1:length(time))';
        signal=signal+erp;
    case 'Custom sinusoid'
        prompt = {'Sampling frequency (Hz):','Signal length (s):','Frequency band (Hz):','White noise strength:'};
        title = 'Generate custom sinusoid signal';
        dims = [1 50];
        definput = {'1000','1','2:0.1:30','3'};
        answer = inputdlg(prompt,title,dims,definput);
        try signal=sinsig(answer);
            Fs=str2num(answer{1});
        catch
        end
end
end

