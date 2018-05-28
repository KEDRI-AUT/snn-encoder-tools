function [recon, base] = MW_de_sc(spikes, thr, window, bounds, stpt)
L=length(spikes);
recon = zeros(L,1);
% recon(1:window)=mean(spikes(1:window))*thr;
recon(1:window)=stpt;
% recon(1:window)=0.5;
base=recon;

% for t = 2:window
%    if spikes(t)==1
%       recon(t)=recon(t-1)+thr;
%     if base(t)>1
%         base(t) = 1;
%     end
%    elseif spikes(t) == -1
%       recon(t)=recon(t-1)-thr;
%     if base(t)<0
%         base(t) = 0;
%     end
%    else
%       recon(t)=recon(t-1);
%    end
% end

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
%    recon(t)=mean(base(t-floor(window/2):t));
%     recon(t)=mean(base(t-window:t));
    recon(t)=base(t);
end
% recon=[recon(floor(window*0.75)+1:end);recon(1:floor(window*0.75))];
end