%MATLAB自带deKmeans
load('trainfeature.mat');
clear Idx C sumD D;
kword=4000;
[Idx,C,sumD,D]=kmeans(fmbhx,kword);