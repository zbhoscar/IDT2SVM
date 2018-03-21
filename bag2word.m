function [ word ] = bag2word(bag,v1,v2,v3,v4,v5)
%输入是按行排列点特征的样本、各种描述子的字典；输出是样本的BOW
%*****行排列的点特征需要截取以对应各自的字典，在程序中设置*********
%fidin为每个视频的IPT处理结果,v1,v2,v3,v4,v5为字典
%上一版本:为简化程序,用wordmax设置每个视频最大的轨迹点数,多了就筛掉.最后归一化用概率表示(和为1).已取消.
[a b]=size(bag);            %特征点个数
vocmax=4000;                %字典个数, size from v1,v2,v3,v4,v5
word=zeros(1,5*vocmax);
parfor j=1:a
    fb=bag(j,:);
    ftra=fb(11:40);
    fhog=fb(41:136);
    fhof=fb(137:244);
    fmbhx=fb(245:340);
    fmbhy=fb(341:436);
    [ k1(j) ] = findword( ftra , v1 );
    [ k2(j) ] = findword( fhog , v2 );
    [ k3(j) ] = findword( fhof , v3 );
    [ k4(j) ] = findword( fmbhx , v4 );
    [ k5(j) ] = findword( fmbhy , v5 );
end
% designed for parfor:
for j=1:a
    word(k1(j))=word(k1(j))+1;
    word(k2(j)+vocmax)=word(k2(j)+vocmax)+1;
    word(k3(j)+2*vocmax)=word(k3(j)+2*vocmax)+1;
    word(k4(j)+3*vocmax)=word(k4(j)+3*vocmax)+1;
    word(k5(j)+4*vocmax)=word(k5(j)+4*vocmax)+1;
end
%no normalize yet