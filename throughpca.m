function [ output ] = throughpca( fidin,fea,cut,fct,fpca )
n=length(cut);
[w,~]=size(fidin);
output=[];
for i=1:n-1                   % 因为fea第一位为空置位
    temp=fidin(:,cut(i)+1:cut(i+1));
    l=floor(fea(i+1)*fct);
    afterpca=(temp-repmat(fpca(i).colmean,w,1))*fpca(i).coeff;
    finalpca=afterpca(:,1:l);
    output=[output,finalpca];
end