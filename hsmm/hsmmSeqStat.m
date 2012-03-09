function [mmax,mmedian,mmean]=hsmmSeqStat(data)
%function [mmax,mmedian,mmean]=hsmmSeqStat(data)
% detecting statistics for repeating sequences

d=rle(data);
c=rle2hist(d);
lvalue=size(c,1);
mmax=zeros(1,lvalue);
mmedian=zeros(1,lvalue);
mmean=zeros(1,lvalue);
for i=1:lvalue
   mmax(i)= max(c{i,2});
   mmedian(i)= median(c{i,2});
   mmean(i)= mean(c{i,2});
end

mmax = max(mmax);
end