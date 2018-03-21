%????IDT???Get label from txt_dir
function [ lbname, index,vdname,dtnum ] = labelmake( mydir,savedir,SEP,ext )
if nargin==1
    savedir=[];SEP='_SEP_'; ext='.txt';
elseif nargin==2
    SEP='_SEP_'; ext='.txt';
elseif nargin~=4
    error('wrong input of labelmake');
end;lsep=length(SEP);
if mydir(end)~='/'                      % ??mydir?????'/'??????
    mydir=[mydir,'/'];
end
DIRS=dir([mydir,'*.txt']);              % DIR????????????MATLAB???????.?..
% ???????????????????????????????.?..
n=length(DIRS);                         % ??DIRS??

index=zeros(n,1,'int8');
lbname={};        %??????????
vdname={};

% idt_feature_example: /home/zbh/features/UCF50I//YoYo_SEP_v_YoYo_g25_c05.txt
for i=1:n            %temp num
    
    name=DIRS(i).name;          % YoYo_SEP_v_YoYo_g25_c05.txt
    %filename=[mydir,name];
    %fprintf('Counting %d-th file: %s.\n ',i,name);
    
    idxst=strfind(name,SEP);
    idxen=strfind(name,ext);
    label=name(1:idxst-1);        %??????BaseballPitch,???index??????
    video=name(idxst+lsep:idxen-1);% get video name
    % accord every video's name
    vdname=[vdname;video];    
    [~,inx]=ismember(label,lbname);
    if inx==0
        lbname=[lbname;label];
        index(i)=length(lbname);
    else
        index(i)=inx;
    end
end
%lbname=int(lbname');
dtnum=n;
if ~isempty(savedir)
    save(savedir,'lbname','vdname','index','dtnum','-v6');
    fprintf('lbname, index,vdname already writen in %s.\n',savedir);
end
fprintf('labelmake DONE\n');