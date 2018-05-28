function [recon, base] = MW_de(spikes, thr,window, stpt)
L=length(spikes);
recon = zeros(L,1);
% recon(1:window)=mean(spikes(1:window))*thr;
recon(1)=stpt;
base=recon;

% for t = 2:window
%    if spikes(t)==1
%       recon(t)=recon(t-1)+thr;
%    elseif spikes(t) == -1
%       recon(t)=recon(t-1)-thr;
%    else
%       recon(t)=recon(t-1);
%    end
% end

for t = 2:L
   if spikes(t)==1
      base(t)=base(t-1)+thr;
   elseif spikes(t) == -1
      base(t)=base(t-1)-thr;
   else
      base(t)=base(t-1);
   end
%    recon(t)=mean(base(t-floor(window/2):t));
%     recon(t)=mean(base(t-window:t));
    recon(t)=base(t);
end
% recon=[recon(floor(window*0.75)+1:end);recon(1:floor(window*0.75))];
end