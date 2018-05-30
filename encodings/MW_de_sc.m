function [recon, base] = MW_de_sc(spikes, thr, window, bounds, stpt)
%MW_de_sc Moving Window decoding algorithm with bounded reconstructed
%signal.
% The signal being reconstructed will exceed the upper/lower bounds of the
% original signal (passed as input here).
L=length(spikes);
recon = zeros(L,1);
recon(1:window)=stpt;
base=recon;
for t = window+1:L
   if spikes(t)==1
      base(t)=base(t-1)+thr;
    if base(t)>bounds(2)
        base(t) = bounds(2);
    end
   elseif spikes(t) == -1
      base(t)=base(t-1)-thr;

    if base(t)<bounds(1)
        base(t) = bounds(1);
    end
   else
      base(t)=base(t-1);
   end
    recon(t)=base(t);
end
end