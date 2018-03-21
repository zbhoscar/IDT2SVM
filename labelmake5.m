%已经得到IDT特征，已经通过全样本抽取GMM，用GMM将所有样本提为FV
%并根据labelindex50.xlsx得到类别序号
function [ lmin ] = labelmake( mydir , metrix )
%加载 GMM eg.m1 c1 p1 m2 c2 p2 m3 c3 p3 m4 c4 p4 m5 c5 p5
% st=datestr(now);
% fprintf('Program starts at %s.\n',st);
%load('/home/zbh/codenote/IPTclasM2FV/GMMnoPCA.mat');
%[lbname,lbindex]=textread('/home/zbh/codenote/IPTclasM2FV/labelindex50.txt','%s%u');    %先名字后序号
if mydir(end)~='/'                      % 检测mydir结尾是否有'/'，没有就加上
    mydir=[mydir,'/'];
end
DIRS=dir([mydir,'*.txt']);              % DIR下除了检测出来已有文件，MATLAB中的检测还包括.和..
% 可以用指定后缀表示，但是得到的特征不带后缀，只能在循环阶段去除.和..
n=length(DIRS);                         % 得到DIRS长度

%trainsets=[];l
labelsets=[];l
lbname={};        %字符串数组的特殊格式

for i=1:5:n            %temp num
    
    name=DIRS(i).name;
    %filename=[mydir,name];
    fprintf('Counting %d-th file: %s.\n ',i,name);
    
    idxst=strfind(name,'v_');
    idxen=strfind(name,'_g');
    label=name(idxst+2:idxen-1);        %掐头去尾得到BaseballPitch,后面与index比较得到序号
    
    ll=length(lbname);
    
    %此判定只适用与matlab在便利文件夹时已经按照名称排列，即xAx,xAx,xAx,..xBx,xBx,xBx,...
    i5=floor(i/5)+1;           %1,6,11,16...
    if ll==0        
        labelsets(i5)=1;lbname{i5}=label;
    elseif ll>0
        if strcmp(label,lbname{ll})==1
            labelsets(i5)=ll;
        elseif strcmp(label,lbname{ll})==0
            lbname{ll+1}=label;
            labelsets(i5)=ll+1;
        end
    end
    %     time=datestr(now);
    %     fprintf('Finished at %s.\n',time);
    
    %     if mod(i,300)==0
    %         save V2Btemp trainsets labelsets
    %         fprintf('save mat at i=%d.\n',i);
    %     end
end
lbname=lbname';
fprintf('DONE\n');