function [Y, Y_w] = vl_myrotmap(X, W, dzdy)
%rotation mapping (RotMap) layers

[n1,n2,n3,n4,n5] = size(X);
Y = zeros(n1,n2,n3,n4,n5);

if nargin < 3
    parfor i3 = 1  : n3
        for i4 = 1 : n4
            for i5 = 1 : n5
                Y(:,:,i3,i4,i5) = W(:,:,i3)*X(:,:,i3,i4,i5);
            end
        end
    end
else
    Y_w = zeros(n1,n2,n3);
    dzdy = reshape(dzdy,n1,n2,n3,n4,n5);
    parfor i3 = 1  : n3
        for i4 = 1 : n4
            for i5 = 1 : n5
                d_t = dzdy(:,:,i3,i4,i5);
                Y(:,:,i3,i4,i5) =  W(:,:,i3)'*d_t;
                Y_w(:,:,i3) =  Y_w(:,:,i3)+ d_t*X(:,:,i3,i4,i5)';
            end
        end
    end
end
