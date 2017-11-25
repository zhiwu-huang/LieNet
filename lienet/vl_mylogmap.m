function [Y, R] = vl_mylogmap(R, dzdy)
%logarithm mapping (LogMap) layer

X = R.x;
A = R.aux;
[n1,n2,n3,n4,n5] = size(X);
Y = zeros(n1,n2,n3,n4,n5);


if isempty(A) == 1
    parfor i3 = 1  : n3
        for i4 = 1 : n4
            for i5 = 1 : n5
                X_t = X(:,:,i3,i4,i5);
                Y_t = zeros(n1,n2);
                axis_angle = vrrotmat2vec_modified(X_t);
                Y_t([1 2 3 6]) = axis_angle;
                Y(:,:,i3,i4,i5) = Y_t;
            end
        end
    end
    R.aux = 1;
else   
    dzdy = reshape(dzdy,n1,n2,n3,n4,n5);
    parfor i3 = 1  : n3
        for i4 = 1 : n4
            for i5 = 1 : n5
                X_t = X(:,:,i3,i4,i5); D_t = dzdy(:,:,i3,i4,i5);
                Y(:,:,i3,i4,i5) = calculate_grad_log_angel(X_t,D_t,n1);
            end
        end
    end
end

function dzdx = calculate_grad_log_angel(X_t,D_t,n1)

epsilon = 1e-12;
dzdx_t = zeros(n1,n1);

if abs(trace(X_t) - 3) <= epsilon || abs(trace(X_t) + 1) <= epsilon
    dzdx_t = zeros(n1,n1);
else  
    X_s = (X_t(2,1)-X_t(1,2))^2+(X_t(3,1)-X_t(1,3))^2+(X_t(3,2)-X_t(2,3))^2;
    X_m = (X_t(1,1)+X_t(2,2)+X_t(3,3)-1)/2;
    
    dzdx_t(1) = -1/sqrt(1-(X_m)^2)*0.5; 
    dzdx_t(2) = X_s^(-0.5)-(X_t(2,1)-X_t(1,2))^2*X_s^(-1.5);
    dzdx_t(3) = X_s^(-0.5)-(X_t(3,1)-X_t(1,3))^2*X_s^(-1.5);
    dzdx_t(6) = X_s^(-0.5)-(X_t(3,2)-X_t(2,3))^2*X_s^(-1.5);
    
end

dzdx = D_t.*dzdx_t; 


