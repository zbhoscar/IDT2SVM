%已经得到IDT特征，已经通过全样本抽取kmeans到VOC，用voc将所有样本提为BOW
%并根据labelindex50.xlsx得到类别序号
clear all;close all;
%加载 vocabulary eg.vtraC1 vhogC1 vhofC1 vmbhxC1 vmbhyC1
st=datestr(now);
fprintf('Program starts at %s.\n',st);
load('/home/zbh/Desktop/v4000CAn.mat');
[lbname,lbindex]=textread('/home/zbh/Desktop/IPTclasM2/labelindex50.txt','%s%u');    %先名字后序号
mydir=uigetdir('/home/zbh/Desktop/Portal/UCF50Im','选择一个目录');
if mydir(end)~='/'                      % 检测mydir结尾是否有'/'，没有就加上
    mydir=[mydir,'/'];
end
DIRS=dir([mydir,'*.txt']);              % DIR下除了检测出来已有文件，MATLAB中的检测还包括.和..
% 可以用指定后缀表示，但是得到的特征不带后缀，只能在循环阶段去除.和..
n=length(DIRS);                         % 得到DIRS长度

trainsets=[];
labelsets=[];

if exist('V2Btemp.mat','file')
    load('V2Btemp');
    [wst hst]=size(trainsets);
    st=wst+1;
else st=1;
end

v1=vtraC1';v2=vhogC1';v3=vhofC1';v4=vmbhxC1';v5=vmbhyC1';

for i=st:n            %temp num
    
    name=DIRS(i).name;
    filename=[mydir,name];
    fprintf('Counting %d-th file: %s. ',i,name);
    fidin=load(filename);
    
    [hf wf]=size(fidin);
    [ temp ] = bag2word(fidin,v1,v2,v3,v4,v5);
    %no normalize yet, now norm:
    trainsets(i,:)=temp/hf;
    
    [ labelsets(i) ] = findlabel( name,lbname,lbindex );
    
    time=datestr(now);
    fprintf('Finished at %s.\n',time);
    
    if mod(i,300)==0
        save V2Btemp trainsets labelsets
        fprintf('save mat at i=%d.\n',i);
    end
end

fprintf('DONE\n');