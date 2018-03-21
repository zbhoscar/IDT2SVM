function [ lmin ] = findword( vec , metrix )
% vec为行向量;metrix为矩阵,每一行是一个字典.
% findword就是找到vec向量在metirx中最近的一行.
% 欧式距离中最近的即为最小
[ w , h ]=size(metrix);
%%%%%%%% set org at i=1
abc=vec-metrix(1,:);
dmin=norm(abc);
lmin=1;
%%%%%%%% when i>1, replace the dmin, lmin
for i=2:w
    abc=vec-metrix(i,:);
    if dmin>norm(abc);
        lmin=i;
    end
end
%k=find(temp==min(temp));    %最近即最小
end