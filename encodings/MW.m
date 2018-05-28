function [out,stpt] = MW(signal, threshold, window)
L=length(signal);
stpt=signal(1);

out=zeros(L,1);

base = mean(signal(1:window+1));
for t = 1:window+1
    
    if signal(t) > base+threshold
       out(t)=1;
       
    elseif signal(t) < base-threshold
       out(t)=-1;
    end
end

for t = window+2:L
   base=mean(signal(t-window-1:t-1));
%    stds=std(signal(t-window:t));
   if signal(t) > base+threshold
       out(t)=1;
       
   elseif signal(t) < base-threshold
       out(t)=-1;
       
   else
       
   end
end

end