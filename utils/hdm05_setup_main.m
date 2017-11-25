function hdm05_setup_main (i_exp)
% ytc_setup();

opts.dataDir = fullfile('/scratch/dataset/HDM05') ;
opts.lite = false ;

liedb.lieDir = fullfile(opts.dataDir) ;

strFolder1 = ['lie20_half_inter' num2str(i_exp)]; 
[liedb] = readImdbTrain(liedb, opts, strFolder1,0);
mkdir(['../data/hdm05_' num2str(i_exp)]);
save(['../data/hdm05_' num2str(i_exp) '/liedb_hdm05_lie20_half_inter.mat'],'-struct','liedb');



function [liedb] = readImdbTrain(liedb, opts, strFolder,flag)
% -------------------------------------------------------------------------
%                                                           Training images
% -------------------------------------------------------------------------

fprintf(['searching' strFolder 'spds ...\n']) ;
names = {} ;
labels = {} ;
sets = {} ;

k = 0;

for d = dir(fullfile(opts.dataDir, strFolder))'
    k = k +1;
    if(k<3)
        continue;
    end
    lab = k -2;
    ims = dir(fullfile(opts.dataDir, strFolder,d.name, '*.mat')) ;
  
%     ranList = randperm(length(ims));    
        
    names{end+1} = strcat([strFolder '/' d.name, filesep], {ims.name}) ;
    labels{end+1} = ones(1, length(names{end})) * lab;
    
    temp_set = ones(1,length(names{end}));
    for ii = 1 : length(names{end})
        name_ii = ims(ii).name;
        str_pos = strfind(name_ii,'_');
        if str2num(name_ii(str_pos(end)+1))==0
            temp_set(ii) = 2;
        end
    end
    sets{end+1} = temp_set;
    
%     sets{end+1} = [ones(1, floor(length(names{end})/2)) 2*ones(1, length(names{end})-floor(length(names{end})/2))];
    
    fprintf('.') ;
    if mod(numel(names), 50) == 0, fprintf('\n') ; end
    %fprintf('found %s with %d images\n', d.name, numel(ims)) ;
end
names = horzcat(names{:}) ;
labels = horzcat(labels{:}) ;
sets = horzcat(sets{:}) ;

if flag == 0
    liedb.lie.id = 1:numel(names) ;
    liedb.lie.name = names ;
    liedb.lie.set = sets ;
    liedb.lie.label = labels ; 
else
    liedb.lie.id = horzcat(liedb.lie.id, (1:numel(names)) + 1e7 - 1) ;
    liedb.lie.name = horzcat(liedb.lie.name, names) ;
    liedb.lie.set = horzcat(liedb.lie.set, 2*ones(1,numel(names))) ;
    liedb.lie.label = horzcat(liedb.lie.label, labels) ;
end

