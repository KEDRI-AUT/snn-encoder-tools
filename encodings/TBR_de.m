function recon = TBR_de(spikes, thr,start)
%TBR_de Threshold-based representation decoding algorithm.
% This algorithm is the same as that of MW and SF.
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