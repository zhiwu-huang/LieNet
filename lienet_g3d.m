function [net, info] = lienet_g3d(varargin)
%set up the path
confPath;
%parameter setting
opts.dataDir = fullfile('./data/g3d') ;
opts.imdbPathtrain = fullfile(opts.dataDir, 'liedb_g3d_lie20_half_inter.mat');
opts.batchSize = 30 ;
opts.test.batchSize = 1;
opts.numEpochs = 1000 ;
opts.gpus = [] ;
opts.learningRate = 0.01*ones(1,opts.numEpochs);
opts.weightDecay = 0.0005 ;
opts.continue = 1;
%loading metadata 
load(opts.imdbPathtrain) ;
%lienet initialization
net = lienet_init_g3d() ;
%lienet training
[net, info] = lienet_train_g3d(net, lie_train, opts);


