function [ fv ] = fea_gmm2fv( mydir,gmmfile,savedir,fea,k )
%已经得到IDT特征，已经通过全样本抽取GMM，用GMM将所有样本提为FV
%并根据labelindex50.xlsx得到类别序号
if nargin==3
    fea=[0,15,48,54,48,48];
    k=256;
elseif nargin==4
    k=256;
elseif nargin~=5
    error('wrong input of smp2pca');
end;
st=datestr(now);
fprintf('%s - Program starts at %s.\n',mfilename,st);
%load('/home/zbh/codenote/IPTclasM2FV/GMMnoPCA.mat');   % m c p 1-5
load(gmmfile);          % gmm(i).mean,gmm(i).cov,gmm(i).pri
if mydir(end)~='/'                      % 检测mydir结尾是否有'/'，没有就加上
    mydir=[mydir,'/'];
end
DIRS=dir([mydir,'*.txt']);              % DIR下除了检测出来已有文件，MATLAB中的检测还包括.和..
% 可以用指定后缀表示，但是得到的特征不带后缀，只能在循环阶段去除.和..
n=length(DIRS);                         % 得到DIRS长度
fv=[];
cut=cumsum(fea);
lpca=2*k*sum(fea(2:end));

parfor i=1:n            %temp num
    
    name=DIRS(i).name;
    filename=[mydir,name];
    fidin=load(filename);
    
    if isempty(fidin)
        fv(i,:) = zeros(1,lpca);   %特例txt为空，vl报错，特此令其置0。长度预先算出来，2DK
    else
        [ fv(i,:) ] = bag2fvnew(fidin,cut,gmm);
    end
    
    time=datestr(now);
    
    if mod(i,100)==0
        fprintf('%s finished at %s.\n',name,time);
    end
    
end
save(savedir,'fv');
fprintf('%s write done.\n%s DONE\n',savedir,mfilename);
