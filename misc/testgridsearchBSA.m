
%%
k=1; %index for numtaps
Fs=1000;
clear signalnoiseratio rsquare
signal=signal - min(signal); %shift to zero min
for wsize=16:4:80
    %create FIR filter
    numtaps = wsize;
    l=1; %index for frequency
    for fcut=30:2:100
        cutoff = fcut/(Fs/2);
        fir=fir1(numtaps,cutoff);
        fir=fir*range(signal)*2;

        %optimize threshold
        i=1;
        clear search_snr search_rmse search_r2
%         clear search search_r search_t search_rmse search_r2
        for threshold = 0.8:0.01:1.1
%             search_t(i)=threshold;
            spikes=BSAmult(signal,fir,threshold);
            recon = conv(spikes,fir,'full');
            recon=recon(1:(min(length(recon),length(signal))));
            search_snr(i)=snr(signal(1:length(recon)),recon-signal(1:length(recon)));
%             search_r(i)=sum(spikes)/length(spikes);
            search_rmse(i)=sqrt(sum((signal-recon).^2)/length(signal));
% %             tmp=corrcoef(recon,signal);
            search_r2(i)=rsquared(signal,recon);
            i=i+1;
        end
        [m, i]=max(search_r2);
        rsquare(k,l)=m;
        [m, i]=max(search_snr);
        snrat(k,l)=m;

        l=l+1;
    end
    k=k+1
end

%% visualize
figure
mesh(30:2:100,16:4:80,snrat)
xlabel('cutoff frequency')
ylabel('filter size')
zlabel('SNR encoding fit')
% zlabel('SNR')
title('BSA filter parameters with optimized threshold parameter')