function [recon, base] = MW_de(spikes, thr, window, start)
L=length(spikes);
recon = zeros(L,1);
recon(1)=start;
base=recon;
for t = 2:L
   if spikes(t)==1
      base(t)=base(t-1)+thr;
   elseif spikes(t) == -1
      base(t)=base(t-1)-thr;
   else
      base(t)=base(t-1);
   end
    recon(t)=base(t);
end
end