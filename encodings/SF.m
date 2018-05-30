function [out, start] = SF(signal, thr)
%SF Step-Forward encoding algoritm.
% Requires input signal and additive threshold (depends on signal scale).
L=length(signal);
start=signal(1);
out=zeros(L,1);
base=signal(1);
for t = 2:L
   if signal(t) > base+thr
       out(t)=1;
       base=base+thr;
   elseif signal(t)< base-thr
       out(t)=-1;
       base=base-thr;
   end
end

end