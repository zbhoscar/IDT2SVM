%已经得到IDT特征，已经通过全样本抽取GMM，用GMM将所有样本提为FV
function [  ] = pca_the_idt( mydir, outdir, fpca, fea, fct)
if nargin==3
    fea=[10,30,96,108,96,96]; % 第一个为空置，第二～最后是每种描述子的长度
    %fea=[0,15,48,54,48,48];
    fct=0.5;                  % pca降维系数，与原数据维度校准整数维
elseif nargin==4
    fct=0.5;
elseif nargin~=5
    error('wrong input of pca_the_idt');
end;
st=datestr(now);
fprintf('%s - Program starts at %s.\n',mfilename,st);
%load('/home/zbh/Desktop/IPTdata/fpca.mat');     
% IN FUNCTION fpca is a input
%fpca(i).coeff,fpca(i).score,fpca(i).latent,fpca(i).colmean
if mydir(end)~='/'                      % 检测mydir结尾是否有'/'，没有就加上
    mydir=[mydir,'/'];
end
DIRS=dir([mydir,'*.txt']);              % DIR下除了检测出来已有文件，MATLAB中的检测还包括.和..
% 可以用指定后缀表示，但是得到的特征不带后缀，只能在循环阶段去除.和..
n=length(DIRS);                         % 得到DIRS长度
% out path
if outdir(end)~='/'                      % 检测mydir结尾是否有'/'，没有就加上
    outdir=[outdir,'/'];
end

%newfea=[0,15,48,54,48,48];
cut=cumsum(fea);
bpca=sum(fea(2:end))*0.5;

parfor i=1:n            % temp num
    
    name=DIRS(i).name;
    filename=[mydir,name];
    fprintf('Counting %d-th file: %s. ',i,name);
    savename=[outdir,name];
    
    if ~exist(savename,'file')
        fidin=load(filename);
        if isempty(fidin)
            output = zeros(1,bpca);
        else
            [ output ] = throughpca( fidin,fea,cut,fct,fpca );
        end
        dlmwrite(savename,output,'delimiter', '\t','precision','%.7f');
        %time=datestr(now);
        %fprintf('Finished at %s.\n',time);
    else
        %fprintf('... already exists.\n');
    end
    
    %     if mod(i,300)==0
    %         save V2Btemp trainsets labelsets
    %         fprintf('save mat at i=%d.\n',i);
    %     end
end
fprintf('DONE\n');