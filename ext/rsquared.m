function rsq=rsquared(signal,recon)
    ssres=sum((signal-recon).^2);
    sst=sum((signal-mean(signal)).^2);
    rsq=1-ssres/sst;
end