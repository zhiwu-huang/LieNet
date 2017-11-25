
% clc;
clear;

load('toy_data');
Metric_Flag = 2; %1:AIRM, 2:Stein, 3:LED 4:dist similarity
graph_kw = 2;
graph_kb = 2;
newDim = 10;

%initializing training structure
bound=1:20;
trnStruct.X = covD_Struct.trn_X(:,:,bound);
trnStruct.y = covD_Struct.trn_y(bound);
trnStruct.n = size(covD_Struct.trn_X,1);
trnStruct.nClasses = max(trnStruct.y);
trnStruct.r = newDim;
trnStruct.Metric_Flag = Metric_Flag;

%Generating graph
nPoints = length(trnStruct.y);
trnStruct.G = generate_Graphs(trnStruct.X,trnStruct.y,graph_kw,graph_kb,Metric_Flag);


%- different ways of initializing, the first 10 features are genuine so
%- the first initialization is the lucky guess, the second one is a random
%- attempt and the last one is the worst possible initialization.

% U = orth(rand(trnStruct.n,trnStruct.r));
U = rand(trnStruct.n,trnStruct.r);
% U = eye(trnStruct.n,trnStruct.r);
% U = [zeros(trnStruct.n-trnStruct.r,trnStruct.r);eye(trnStruct.r)];

nPoints = length(trnStruct.y);
UXU = zeros(covD_Struct.r,covD_Struct.r,nPoints);
for tmpC1 = 1:nPoints
    UXU(:,:,tmpC1) = U'*trnStruct.X(:,:,tmpC1)*U;
end
% [pair_dist, beta] =  Compute_AIRM_Sim(UXU,UXU,true);
[pair_dist, beta] =  Compute_Stein_Sim(UXU,UXU,true);
% [pair_dist, beta] =  Compute_LERM_Sim(UXU,UXU,true);beta = beta*1000;


av_error=grad_check(@supervised_WB_CostGrad,U,10,trnStruct,beta);
fprintf('avarage error is %f\n',av_error);