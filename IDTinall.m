%% detect platform to set path
clear;close all;
if filesep=='/'             %   linux & mac is '/'
    dataset_path='/data3_alpha/datasets/UCF-101';
    idtprog_path='/home/zbh/Desktop/improved_trajectory_release/release/DenseTrackStab';
    midfile_path='/data2_alpha/zbh';
    shellsh_path='/data/zbh/SHELL_v2'; % this.sh 20 prog 'passpara'
    fileseq_mark='z1';
elseif filesep=='\'         %   windows is '\'
    error('undefined platform!\n')
end
[~,dataset,~]=fileparts(dataset_path);
midfile_idt=fullfile(midfile_path,strcat(dataset,'_idt'));      % where DenseTrackStab put it's file
midfile_idt_pca=strcat(midfile_idt,'_pca');                     % where filter_pca put it's file
midfile_data=fullfile(midfile_path,'IDTdata');                  % where IDT2SVM midle file
shellsh_parallel=fullfile(shellsh_path,'parallel_v2.sh');       % where parallel.sh
shellsh_idt=fullfile(shellsh_path,'IDT_v2.sh');                 % where IDT_v2.sh
shellsh_smp=fullfile(shellsh_path,'sampleIDT_v2.sh');           % where sampleIDT_v2.sh
%% set what to do
%  do idt?lb-make?pca?gmm-make?fv?
step01=[0,    1,   1,       1,    0,0,0,0,0];
fprintf('VEC setup01=\n');disp(step01);
%% make idt feature 1
fprintf('Making IDT features:\nFROM:%s\nTO:%s\n',dataset_path,midfile_idt);
% usage: this.sh 20 prog 'passpara'
% 'passpara':/home/zbh/Desktop/SHELL_v2/IDT_v2.sh ds to pg pgext
passpara=strcat(shellsh_idt,32,dataset_path,32,midfile_idt,32,idtprog_path);
pnum=27;
runsh=strcat(shellsh_parallel,32,num2str(pnum),32,passpara);
fprintf('orig_cmd:%s\n',runsh);
if step01(1)==1
    unix(runsh);
    %%% # /home/zbh/features/UCF50I//YoYo_SEP_v_YoYo_g25_c05.txt
end
%% use idt feature to make index 1
indexfile=fullfile(midfile_data,strcat(dataset,'_',fileseq_mark,'_index.mat'));
fprintf('Making video index:\nFROM:%s\nTO:%s\n',midfile_idt,indexfile);
if step01(2)==1&&~exist(indexfile,'file')
    [ lbname,index,vdname,dtnum ] = labelmake( midfile_idt,indexfile );
elseif step01(2)==1&&exist(indexfile,'file')
    load(indexfile);
end
%% use pca to reduce idt dementions 3
if step01(3)==1
    % sample a part of idt
    smpall=336000;smps=ceil(smpall/dtnum);
    % num dir file
    smpfile1=fullfile(midfile_data,strcat(dataset,'_',fileseq_mark,'_samp_',num2str(smpall),'.txt'));
    smpsh=strcat(shellsh_smp,32,num2str(smps),32,midfile_idt,32,smpfile1);
    if ~exist(smpfile1,'file')
        fprintf('Sampling idt_features:\nTotal num:%d\nTO:%s\n',smpall,smpfile1);
        fprintf('orig_cmd:%s\n',smpsh);
        unix(smpsh);
    else fprintf('%s already exists.\n',smpfile1);
    end
    % make this part's pca
    savepca=strcat(smpfile1(1:end-4),'_pca.mat');
    if ~exist(savepca,'file')
        fprintf('Making pca...\n');
        [ fpca ] = smp2pca( smpfile1,savepca );
    else
        fprintf('%s already exists.\n',savepca);
        load(savepca);
    end
    fprintf('PCA the files in %s...\nputting the files into %s.\n',midfile_idt,midfile_idt_pca);
    pca_the_idt( midfile_idt, midfile_idt_pca, fpca );
end
%% get features gmm 2
if step01(4)==1
    % sample a part of idt
    smpall=256000;smps=ceil(smpall/dtnum);
    % num dir file
    smpfile2=fullfile(midfile_data,strcat(dataset,'_',fileseq_mark,'_samp_pca_',num2str(smpall),'.txt'));
    smpsh=strcat(shellsh_smp,32,num2str(smps),32,midfile_idt_pca,32,smpfile2);
    if ~exist(smpfile2,'file')
        fprintf('Sampling idt_features:\nTotal num:%d\nTO:%s\n',smpall,smpfile2);
        unix(smpsh);
    else fprintf('%s already exists.\n',smpfile2);
    end
    % make this part's gmm
    savegmm=strcat(smpfile2(1:end-4),'_gmm.mat');
    if ~exist(savegmm,'file')
        fprintf('Making gmm...\n');
        [ gmm ] = fea2gmm( smpfile2,savegmm );                % [ gmm ] = fea2gmm( file,savedir,fea,k )
    else
        fprintf('%s already exists.\n',savegmm);
        load(savegmm);
    end
end
%% use gmm to get all samples fv 1
if step01(5)==1
    savefv=strcat(savegmm(1:end-4),'_fv.mat');
    fprintf('Making fv via gmm...\n');
    [ fv ] = fea_gmm2fv( midfile_idt_pca,savegmm,savefv );         % [ fv ] = fea_gmm2fv( mydir,gmmfile,savedir,fea,k )
end
%% use fv\indexfile to svm

