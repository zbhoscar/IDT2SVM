%已经得到IDT特征，已经通过全样本抽取GMM，用GMM将所有样本提为FV
%并根据labelindex50.xlsx得到类别序号
clear all;close all;
%加载 GMM eg.m1 c1 p1 m2 c2 p2 m3 c3 p3 m4 c4 p4 m5 c5 p5
st=datestr(now);
fprintf('Program starts at %s.\n',st);
load('/home/zbh/codenote/IPTclasM2FV/GMMnoPCA.mat');
[lbname,lbindex]=textread('/home/zbh/codenote/IPTclasM2FV/labelindex50.txt','%s%u');    %先名字后序号
mydir=uigetdir('/home/zbh/features/UCF50Im','选择一个目录');
if mydir(end)~='/'                      % 检测mydir结尾是否有'/'，没有就加上
    mydir=[mydir,'/'];
end
DIRS=dir([mydir,'*.txt']);              % DIR下除了检测出来已有文件，MATLAB中的检测还包括.和..
% 可以用指定后缀表示，但是得到的特征不带后缀，只能在循环阶段去除.和..
n=length(DIRS);                         % 得到DIRS长度

trainsets=[];
labelsets=[];

parfor i=1:n            %temp num
    
    name=DIRS(i).name;
    filename=[mydir,name];
    fprintf('Counting %d-th file: %s. ',i,name);
   fidin=load(filename);
    
    [ w , h ]=size(fidin);
    if w==0
        trainsets(i,:) = zeros(1,218112);   %特例txt为空，vl报错，特此令其置0。长度预先算出来，2DK
    else
        [ trainsets(i,:) ] = bag2fv(fidin,m1,c1,p1,m2,c2,p2,m3,c3,p3,m4,c4,p4,m5,c5,p5);
    end
    
    
    time=datestr(now);
    fprintf('Finished at %s.\n',time);
    
    %     if mod(i,300)==0
    %         save V2Btemp trainsets labelsets
    %         fprintf('save mat at i=%d.\n',i);
    %     end
end

fprintf('DONE\n');