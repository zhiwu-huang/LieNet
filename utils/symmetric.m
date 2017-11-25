function ssX = symmetric(X)
% symmetrized tensor
% this is a version of symmetric that does symmetric of matrices on the
% first 2 dimensions for each of the matrices given by the 3rd dimension
%
% (c) 2015 catalin ionescu -- catalin.ionescu@ins.uni-bonn.de

  ssX = .5*(X+permute(X,[2 1 3]));
end