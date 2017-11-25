function Y = vl_mysoftmaxloss(X,c,dzdy)

% classNum = size(c,2);
% s = X;
% s = bsxfun(@minus, s, max(s, [], 1));
% s = exp(s);
% s = s + 1e-8; %avoid NaN
% y = s./repmat(sum(s,1),[classNum 1]);
% if nargin < 3
%     loss = -c'.* log(y);
%     Y = sum(loss(:));
% else
%     % gradient computation    
%     Y =dzdy* (-1) *(c'-y);%loss delta or output delta
% end

% class c = 0 skips a spatial location
mass = single(c > 0) ;
mass = mass';

% convert to indexes
c_ = c - 1 ;
for ic = 1  : length(c)
    c_(ic) = c(ic)+(ic-1)*size(X,1);
end

% compute softmaxloss
Xmax = max(X,[],1) ;
ex = exp(bsxfun(@minus, X, Xmax)) ;

% s = bsxfun(@minus, X, Xmax);
% ex = exp(s) ;
% y = ex./repmat(sum(ex,1),[size(X,1) 1]);

%n = sz(1)*sz(2) ;
if nargin < 3
  t = Xmax + log(sum(ex,1)) - reshape(X(c_), [1 size(X,2)]) ;
  Y = sum(sum(mass .* t,1)) ;
else
  Y = bsxfun(@rdivide, ex, sum(ex,1)) ;
  Y(c_) = Y(c_) - 1;
  Y = bsxfun(@times, Y, bsxfun(@times, mass, dzdy)) ;
end