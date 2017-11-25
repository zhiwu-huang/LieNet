function hdm05_setup(i_exp)
if nargin<1
    i_exp = 1;
end
    
addpath(genpath('..\hdm_utils\parser'))
% addpath(genpath('animate'))
addpath('..\hdm_utils\quaternions')
%% load input files
path = 'E:\Research\Dataset\HDM05\data\HDM05_cut_amc';
% savepath = ['C:\Scratch\dataset\HDM05\spd93_half_inter' num2str(i_exp)];
k = 0;
dur_clip = 16;
skeletal_data = [];
tr_te_lable = [];
for d = dir(fullfile(path))'
    k = k +1;
    if(k<3)
        continue;
    end
    ims = dir(fullfile(path,d.name, '*.amc')) ;
%     saveFilePath = [savepath '\' d.name];
%     mkdir(saveFilePath);
    tic;
    ranList = randperm(length(ims));    

    for i_ims = 1 : length(ims)
        pathamc = ims(ranList(i_ims)).name;
        indasf = strfind(pathamc,'_');
        pathasf = [path '\' d.name '\' pathamc(1: indasf(2)-1) '.asf'];
        pathamc = [path '\' d.name '\' pathamc];
        
        [skel,mot]  = readMocap(pathasf,pathamc);
%         body_model = [];
%         body_model.relative_body_part_pairs = generate_relative_pair(skel.njoints,skel.paths);
%         save(['..\data\hdm05\body_model'],'body_model');

        traj = mot.jointTrajectories;
        cords_t = [];
        for ii = 1 : 31
            cords_t = [cords_t; traj{ii}];
        end
        cords = reshape(cords_t,[3 31 size(traj{1},2)]);
        
        if i_ims <= floor(length(ims)/2)
            
            nImg = size(cords,3);
            step = floor(nImg/dur_clip);
            for ii = 1 : step
                 skeletal_data{end+1}.joint_locations = cords(:,:, ii : step: nImg);  
                 skeletal_data{end}.action = k-2;
                 skeletal_data{end}.subject = ranList(i_ims);
                 tr_te_lable(end+1) = 0;
%                 save([saveFilePath '\' num2str(ranList(i_ims)) '_' num2str(ii) '.mat'],'Y1');
            end
%             skeletal_data{end+1}.joint_locations = cords;  
%             skeletal_data{end}.action = k-2;
%             skeletal_data{end}.subject = ranList(i_ims);
%             tr_te_lable(end+1) = 0;
        else
            skeletal_data{end+1}.joint_locations = cords; 
             skeletal_data{end}.action = k-2;
            skeletal_data{end}.subject = ranList(i_ims);
            tr_te_lable(end+1) = -1;
%             save([saveFilePath '\' num2str(ranList(i_ims)) '.mat'],'cords');
        end       
        
    end
    
    toc;
end
save(['..\data\hdm05\skeletal_data'],'skeletal_data','tr_te_lable');



function relative_pairs = generate_relative_pair(njoints,paths)
nedges = njoints-1;
% relative_pairs = zeros(nedges*(nedges-1),4);
% edges = zeros(nedges,2);
relative_pairs = [];
edges = [];
for i = 1 : length(paths)
    path_i = paths{i};
    for j = 1 : length(path_i)-1
        edges(end+1,1)=path_i(j);
        edges(end,2)=path_i(j+1);
    end
end
for i = 1 : nedges
    for j = i +1: nedges
        relative_pairs(end+1,1:2) = edges(i,:);
        relative_pairs(end,3:4) = edges(j,:);
        relative_pairs(end+1,1:2) = edges(j,:);
        relative_pairs(end,3:4) = edges(i,:);
    end
end