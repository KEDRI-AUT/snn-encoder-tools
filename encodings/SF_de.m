function recon = SF_de(spikes, thr, start)
L=length(spikes);
recon = zeros(L,1);
recon(1)=start;
for t = 2:L
   if spikes(t)==1
      recon(t)=recon(t-1)+thr;
   elseif spikes(t) == -1
      recon(t)=recon(t-1)-thr;
   else
      recon(t)=recon(t-1);
   end
end

end