function  [L, L_I]=max_eig_abs(D,c)
 if ~exist('c','var'), c = 0; end
  [M,N] = size(D);
  if isa(D,'gpuArray')
    L = zeros(size(D),'single','gpuArray');
  else
    L = zeros(size(D));
  end
  
  m = min(M,N);
  h1=diag(D);
%   Ir1 = h1 < c;
%   %reLU
%   r1 = h1;
%   r1(Ir1) = 0;
  
  L_I = abs(h1) < c;
  L_P = h1 > 0;
  %reLU
  h1(L_I& L_P) = c;  
  h1(L_I& ~L_P) = -c;  

  L(1:m,1:m) = diag(h1);