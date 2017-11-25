function M = dDiag(M)
% double diag function i.e. return a matrix with all the elements except
% for the diagonal 

if isa(M,'gpuArray')
  I = eye(size(M),'single','gpuArray');
else
  I = eye(size(M));
end

M = I.*M;