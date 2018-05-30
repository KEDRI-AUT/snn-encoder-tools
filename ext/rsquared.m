function rsq=rsquared(signal,recon)
%rsquared Coefficient of regression
%   calculate coefficient of regression with the 1-residual/total method.
    ssres=sum((signal-recon).^2);
    sst=sum((signal-mean(signal)).^2);
    rsq=1-ssres/sst;
end