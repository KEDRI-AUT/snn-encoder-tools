
%%
k=1; %index for window size
clear signalnoiseratio search_snr search_rmse search_r2
bounds=[min(signal) max(signal)];
for wsize=2:2:30
    %create FIR filter
        %optimize threshold
        i=1; %index for threshold
%         clear search search_rmse
%         clear search search_r search_t search_rmse search_r2
        for threshold = (0.02:0.01:0.6)*range(signal)
%             search_t(i)=threshold;
%             spikes=BSAmult(signal,fir,threshold);
%             recon = conv(spikes,fir,'full');

            [spikes,stpt]=MW(signal,threshold,wsize);
            recon=MW_de(spikes,threshold,wsize,stpt); % scaling here!
%             recon=MW_de_sc(spikes,threshold,wsize,bounds,stpt); % scaling here!
            recon=recon(1:(min(length(recon),length(signal))));
            search_snr(k,i)=snr(signal(1:length(recon)),recon-signal(1:length(recon)));
%             search_r(i)=sum(spikes)/length(spikes);
            search_rmse(k,i)=sqrt(sum((signal-recon).^2)/length(signal));
%             tmp=corrcoef(recon,signal);
            search_r2(k,i)=rsquared(signal,recon);
            i=i+1;
        end
%         signalnoiseratio(k,l)=m;

    k=k+1
end

%% visualize
figure
mesh((0.02:0.01:0.6)*uplim,2:2:30,search_snr)
xlabel('threshold')
ylabel('window size')
zlabel('SNR')
% zlim([-10 5])
title('Optimization of Moving Window encoding')
% zlim([-0.3 -0.15])