function [ fpca ] = smp2pca( file,savedir,fea )
if nargin==2
    fea=[10,30,96,108,96,96];
    %fea=[0,15,48,54,48,48];
elseif nargin~=3
    error('wrong input of smp2pca');
end;
forpca=load(file);     %在此修改采样文件
[w,~]=size(forpca);

cut=cumsum(fea);            % 转化成在数据中的列位置

for i=2:length(fea)
    temp=forpca(:,cut(i-1)+1:cut(i));       % 转置见vl_feat用法
    [fpca(i-1).coeff,fpca(i-1).score,fpca(i-1).latent]=pca(temp);
    fpca(i-1).colmean=sum(temp)/w;    
end
save(savedir,'fpca');
fprintf('%s write done.\n',savedir);