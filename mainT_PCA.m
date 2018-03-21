clearvars -except random256t;
if ~exist('random256t','var')
    load('/home/zbh/features/random256t.txt');
end
feature=random256t(1:200,11:40);
%feature=ingredients;
[co, sc, latent] = pca(feature) ;
%%%%每列减去列均值之后的feature再乘co才是sc
[w,h]=size(feature);
fmeanv=sum(feature)/w;
fmeanm=repmat(fmeanv,w,1);  % or B=A(ones(3,1),:)
sct=(feature-fmeanm)*co;
%%%%验证操作
exm=sct-sc;
exf=sum(sum(exm))/w/h;
drank=cumsum(latent)./sum(latent);