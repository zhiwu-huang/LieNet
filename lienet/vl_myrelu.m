function [Y, R] = vl_myrelu(R, dzdy)
%ReLU layer
X = R.x;
A = R.aux;
[n1,n2,n3,n4,n5] = size(X);
Y = zeros(n1,n2,n3,n4,n5);
epslon = 0.3;

if isempty(A) ==1
    A = zeros(n1,n2,n3,n4,n5);
    parfor i3 = 1  : n3
        for i4 = 1 : n4
            for i5 = 1 : n5
                r_t = X(:,:,i3,i4,i5);
                Ir_t1 = zeros(3,3);
                Ir_t1([1 2 3 6]) = abs(r_t([1 2 3 6])) < epslon;
                Ir_t3 = r_t < 0;
                r_t(Ir_t1 & Ir_t3) = -epslon;
                r_t(Ir_t1 & ~Ir_t3) = epslon;
                A(:,:,i3,i4,i5) = Ir_t1;
                Y(:,:,i3,i4,i5) = r_t;
            end
        end
    end
    R.aux = A;
else
    dzdy = reshape(dzdy,n1,n2,n3,n4,n5); 
    
    parfor i3 = 1  : n3        
        for i4 = 1 : n4
            for i5 = 1 : n5
                dzdy_t = dzdy(:,:,i3,i4,i5);
                Ir1 = A(:,:,i3,i4,i5);
                dzdy_t = dzdy_t .* not(Ir1);%through ReLU
                Y(:,:,i3,i4,i5) = dzdy_t;
            end
        end
    end
end
