threshold = 0.3
location = "C:\Users\aksha\Documents\GitHub\snn-encoder-tools\data\dataIBM.csv"
sample_rate = 1000

signal = xlsread(location);
signal = signal(:,1);

i=1;
for threshold = (0.001:0.001:0.8)*range(signal)
    [spikes, start]=SF(signal,threshold);
    recon = SF_de(spikes,threshold,start);
    search_snr(i)=snr(signal,recon-signal)
    search_rate(i)=mean(abs(spikes));
    search_rmse(i)=sqrt(sum((signal-recon).^2)/length(signal));
    search_t(i) = threshold;
    search_r2(i)=rsquared(signal,recon);
    if search_rate(i)<0.001
        break
    end    
    i=i+1;
end

[~, i] = max(search_snr);
search_t(i)