function out = BSAmult(signal,fir,threshold)
% multiplicative threshold
L = length(signal);
F = length(fir);
out = zeros(L,1);
input = signal-min(signal); %zero min shift
for t = 1 : (L-F)
   err1=0;
   err2=0;
   for k = 1:F
      err1 = err1 + abs(input(t+k)-fir(k)); 
      err2 = err2 + abs(input(t+k-1));
   end
   if err1 <= (err2*threshold) 
       out(t) = 1; %give spike
       for k = 1:F
          input(t+k-1) = input(t+k-1)-fir(k);
       end
   end
end
end