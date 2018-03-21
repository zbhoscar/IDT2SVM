function [ output ] = findlabel( name,lbname,lbindex )
idxst=strfind(name,'v_');
idxen=strfind(name,'_g');
label=name(idxst+2:idxen-1);        %掐头去尾得到BaseballPitch,后面与index比较得到序号

ln=length(lbindex);
z=1;TF=0;
while ( z<=ln && TF==0 )
    lbchar=char(lbname(z));
    TF = strcmpi(lbchar,label);
    if TF==1
        output=z;
    end
    z=z+1;
end
if ~exist('output','var')         % mark as 51 and wait check
    output=51;
end

end