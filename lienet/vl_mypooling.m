function [Y, R] = vl_mypooling(R, pool, dzdy)
%logarithm mapping (LogMap) layer
X = R.x;
A = R.aux;
[n1,n2,n3,n4,n5] = size(X);
if pool == 2
    Y = zeros(n1,n2,ceil(n3/pool),n4,n5);
else
    Y = zeros(n1,n2,n3,ceil(n4/pool),n5);
end

if isempty(A)==1
    IY = zeros(n1,n2,n3,n4,n5);
    Id = 1 : n1*n2;
    if pool == 2
        for i4 = 1 : n4
            for i5 = 1 : n5
                for i3 = 1 : pool : n3
                    if i3+(pool-1) <=n3
                        r_tt = X(:,:, i3:i3+(pool-1),i4,i5);
                        [m,I] = maxRotAngel(r_tt);
                        I1 = I*ones(n1*n2,1);
                        tI = zeros(n1,n2,pool);
                        tI((I1-1)*n1*n2+Id') = 1;
                        IY(:,:, i3: i3+(pool-1),i4,i5) = tI;                        
                    else
                         r_tt = X(:,:, i3:end,i4,i5);
                        [m,I] = maxRotAngel(r_tt);
                        I1 = I*ones(n1*n2,1);
                        tI = zeros(n1,n2,n3-i3+1);
                        tI((I1-1)*n1*n2+Id') = 1;
                        IY(:,:, i3: end,i4,i5) = tI;
                    end
                    Y(:,:,floor(i3/pool)+1,i4,i5) = r_tt(:,:,I);
                end
            end
        end
    else
       for i3 = 1 : n3
           for i5 = 1 : n5
               for i4 = 1 : pool : n4
                    if i4+(pool-1) <=n4
                        r_tt = X(:,:,i3, i4:i4+(pool-1),i5);
                        r_tt = reshape(r_tt, n1,n2,pool);
                        [m,I] = maxRotAngel(r_tt);
                        I1 = I*ones(n1*n2,1);
                        tI = zeros(n1,n2,pool);
                        tI((I1-1)*n1*n2+Id') = 1;
                        IY(:,:,i3, i4: i4+(pool-1),i5) = tI;                        
                    else
                         r_tt = X(:,:, i3,i4:end,i5);
                         r_tt = reshape(r_tt, n1,n2,n4-i4+1);

                        [m,I] = maxRotAngel(r_tt);
                        I1 = I*ones(n1*n2,1);
                        tI = zeros(n1,n2,n4-i4+1);
                        tI((I1-1)*n1*n2+Id') = 1;
                        IY(:,:, i3,i4: end,i5) = tI;
                    end
                    Y(:,:,i3,floor(i4/pool)+1,i5) = r_tt(:,:,I);
               end
           end
       end
    end
    R.aux = IY;
else
    Y = zeros(n1,n2,n3,n4,n5);
    Y(logical(A)) = dzdy;

end

