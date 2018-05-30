function gridSearchMW(signal)
%gridSearhMW Performs grid search for MW encoding parameters
% Brute-force grid search to find optimal window size (and threshold)
% parameter of MW encoding. Indicates progress in console by counting.
k=1; %index for window size
    clear signalnoiseratio search_snr search_rmse search_r2
    for wsize=2:2:30
        %optimize threshold
        i=1; %index for threshold
        for threshold = (0.02:0.01:0.6)*range(signal)
            [spikes,stpt]=MW(signal,threshold,wsize);
            recon=MW_de(spikes,threshold,wsize,stpt); % scaling here!
%             recon=MW_de_sc(spikes,threshold,wsize,bounds,stpt); % scaling here!
            recon=recon(1:(min(length(recon),length(signal))));
            search_snr(k,i)=snr(signal(1:length(recon)),recon-signal(1:length(recon)));
            search_rmse(k,i)=sqrt(sum((signal-recon).^2)/length(signal));
%             search_r2(k,i)=rsquared(signal,recon);
            i=i+1;
        end
        k=k+1
    end
    figure()
    mesh((0.02:0.01:0.6)*range(signal),2:2:30,search_snr)
    xlabel('threshold')
    ylabel('window size')
    zlabel('SNR')
    % zlim([-10 5])
    title('Optimization of Moving Window encoding')
    % zlim([-0.3 -0.15])
end