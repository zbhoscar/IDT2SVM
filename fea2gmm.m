function [ gmm ] = fea2gmm( file,savedir,fea,k )
if nargin==2
    fea=[0,15,48,54,48,48];
    k=256;
elseif nargin==3
    k=256;
elseif nargin~=4
    error('wrong input of smp2pca');
end;
if ~exist('gmmof256t','var')
    gmmof256t=load(file);     %在此修改采样文件
end
%fea=[10,30,96,108,96,96];

cut=cumsum(fea);            % 转化成在数据中的列位置

for i=2:length(fea)

    temp=gmmof256t(:,cut(i-1)+1:cut(i))';       % 转置见vl_feat用法
    [gmm(i-1).mean,gmm(i-1).cov,gmm(i-1).pri]=vl_gmm(temp,k);
    
end
save(savedir,'gmm');
fprintf('%s write done.\n',savedir);    