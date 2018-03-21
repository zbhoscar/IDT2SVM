function [ word ] = bag2fv(bag,m1,c1,p1,m2,c2,p2,m3,c3,p3,m4,c4,p4,m5,c5,p5)
%输入是按行排列点特征的样本、各种描述子的字典；输出是样本的BOW
%*****行排列的点特征需要截取以对应各自的字典，在程序中设置*********
%fidin为每个视频的IPT处理结果,v1,v2,v3,v4,v5为字典
%上一版本:为简化程序,用wordmax设置每个视频最大的轨迹点数,多了就筛掉.最后归一化用概率表示(和为1).已取消.

ftra=bag(:,11:40);
fhog=bag(:,41:136);
fhof=bag(:,137:244);
fmbhx=bag(:,245:340);
fmbhy=bag(:,341:436);

eco1=vl_fisher(ftra',m1,c1,p1);
eco2=vl_fisher(fhog',m2,c2,p2);
eco3=vl_fisher(fhof',m3,c3,p3);
eco4=vl_fisher(fmbhx',m4,c4,p4);
eco5=vl_fisher(fmbhy',m5,c5,p5);

word=[eco1',eco2',eco3',eco4',eco5'];