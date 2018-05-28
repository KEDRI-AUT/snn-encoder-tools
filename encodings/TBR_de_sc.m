function recon = TBR_de_sc(spikes, thr, bounds, stpt)
L=length(spikes);
recon = zeros(L,1);
% recon(1)=mean(bounds);
recon(1)=stpt;
for t = 2:L
   if spikes(t)==1
      recon(t)=recon(t-1)+thr;
      if recon(t)>bounds(2)
          recon(t)=bounds(2);
      end
   elseif spikes(t) == -1
      recon(t)=recon(t-1)-thr;
      if recon(t)<bounds(1)
          recon(t)=bounds(1);
      end
   else
      recon(t)=recon(t-1);
   end
end

end