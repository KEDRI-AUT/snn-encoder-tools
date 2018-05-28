function [out, thr, stpoint] = TBR(signal, factor)
L=length(signal);
diff=zeros(L,1);
stpoint=signal(1);
for t = 1:(L-1)
   diff(t) = signal(t+1)-signal(t);
end
diff(L)=diff(L-1);
thr = mean(diff)+factor*std(diff);
% thr = factor*std(diff);

% thr=factor;
out=zeros(L,1);
for t = 1:L
   if diff(t)>thr
       out(t)=1;
   elseif diff(t)<-thr
       out(t)=-1;
   else
       
   end
end

end