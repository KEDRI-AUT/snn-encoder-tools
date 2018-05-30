function [out, thr, start] = TBR(signal, factor)
%TBR Threshold-based representation encoding algorithm.
% Requires input signal and a factor that is independent of signal
% amplitude (should be between 0-3 in general).
L=length(signal);
diff=zeros(L,1);
start=signal(1);
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