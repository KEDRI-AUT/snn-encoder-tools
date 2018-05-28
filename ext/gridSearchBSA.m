function gridSearchBSA(signal,Fs)
k=1; %index for numtaps
clear snrat rsquare
snrat=zeros(length(16:4:80),length(20:2:80));
signal=signal - min(signal); %shift to zero min
for wsize=16:4:80
    %create FIR filter
    numtaps = wsize;
    l=1; %index for frequency
    for fcut=(0.02:0.002:0.08)*Fs
        cutoff = fcut/(Fs/2);
        fir=fir1(numtaps,cutoff);
        fir=fir*range(signal)*2;

        %optimize threshold
        i=1;
        clear search_snr search_rmse search_r2
        search_snr=zeros(length(0.8:0.01:1.1),1);
        for threshold = 0.8:0.01:1.1
            spikes=BSAmult(signal,fir,threshold);
            recon = conv(spikes,fir,'full');
            recon=recon(1:(min(length(recon),length(signal))));
            search_snr(i)=snr(signal(1:length(recon)),recon-signal(1:length(recon)));
%             search_rmse(i)=sqrt(sum((signal-recon).^2)/length(signal));
%             search_r2(i)=rsquared(signal,recon);
            i=i+1;
        end
%         [m, i]=max(search_r2);
%         rsquare(k,l)=m;
        [m, i]=max(search_snr);
        snrat(k,l)=m;

        l=l+1;
    end
    k=k+1
end
figure
mesh((0.02:0.002:0.08)*Fs,16:4:80,snrat)
xlabel('cutoff frequency')
ylabel('filter size')
zlabel('SNR encoding fit')
title('BSA filter parameters with optimized threshold parameter')
end