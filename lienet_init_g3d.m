function net = lienet_init_g3d()
% lienet_init: initialize a lienet

rng('default');
rng(0) ;

opts.framenum = 100;
opts.datadim = [3, 3, 3, 3];
opts.skedim = [342, 171, 171, 15];


opts.layernum = length(opts.datadim)-1;

Winit = cell(opts.layernum+1,1);

for i_w = 1 : opts.layernum
    Winit{i_w}.w = zeros(opts.datadim(1),...
                          opts.datadim(1),opts.datadim(i_w));
    for i_s = 1 : opts.skedim(i_w)
        A = rand(opts.datadim(i_w));
        [U1, S1, V1] = svd(A * A');
        Winit{i_w}.w(:,:,i_s) = U1(:,1:opts.datadim(i_w+1))';
    end
end

f=1/100 ;
classNum = 20;
fdim = opts.datadim(1)*opts.datadim(1)*171*7;

theta = f*randn(fdim, classNum, 'single');
Winit{i_w+1}.w = theta';

net.layers = {} ;

% 1 block setting
% net = init_block(net,1,1,Winit,pooling_index{1});

% % 2 block setting
% net = init_block(net,1,0,Winit,pooling_index{1});
% net = init_block(net,2,1,Winit,pooling_index{2});

% 3 block setting
net = init_block(net,1,0,Winit);
net = init_block(net,2,0,Winit);
net = init_block(net,3,1,Winit);


net.layers{end+1} = struct('type', 'fc', 'weight', Winit{end}.w);
net.layers{end+1} = struct('type', 'softmaxloss');


function net = init_block(net,i_layer,i_flag,Winit)

net.layers{end+1} = struct('type', 'rotmap') ;
net.layers{end}.weight = Winit{i_layer}.w;
net.layers{end+1} = struct('type', 'pooling') ;
if i_layer < 2
    net.layers{end}.pool = 2;
else
    net.layers{end}.pool = 4;
end

if i_flag ~= 0
    net.layers{end+1} = struct('type', 'logmap') ;
    net.layers{end+1} = struct('type', 'relu') ;

end

