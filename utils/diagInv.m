function invX = diagInv(X)
% compute the inverse of a diagonal matrix
% no verification for speed 
% FIXME add some checks for zeros on the diagonal

  diagX = diag(X);
  invX = diag(1./diagX);
end