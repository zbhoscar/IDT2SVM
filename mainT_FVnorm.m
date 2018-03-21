clearvars -except trainsets lbname labelsets;
if ~exist('trainsets','var')
    load('/home/zbh/codenote/IPTclasM2FV/ucf50fvNOpca&Norm.mat');
end
n=length(labelsets);
for i=1:n
    trainsets(i,:)