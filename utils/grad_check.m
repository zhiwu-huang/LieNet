function average_error = grad_check(fun, theta0, num_checks, varargin)

  delta=1e-3; 
  sum_error=0;

  fprintf(' Iter       i      j       err');
  fprintf('           g_est               g               f\n')
  
  for i=1:num_checks
    tic;
    T = theta0;
    ind_i = randsample(size(T,1),1);
    ind_j = randsample(size(T,2),1);
    T0=T; T0(ind_i,ind_j) = T0(ind_i,ind_j) -delta;
    T1=T; T1(ind_i,ind_j)  = T1(ind_i,ind_j) +delta;

    [f,g] = fun(T, varargin{:});
    f0 = fun(T0, varargin{:});
    f1 = fun(T1, varargin{:});

    g_est = (f1-f0) / (2*delta);

    error = abs(g(ind_i,ind_j) - g_est);

    fprintf('% 5d  % 6d % 6d % 15g % 15f % 15f % 15f\n', ...
            i,ind_i,ind_j,error,g(ind_i,ind_j),g_est,f);

    sum_error = sum_error + error;
    toc;
  end

  average_error=sum_error/num_checks;
