function [R1,R2,U]  = inv_abs_r(Q,R,X)
U = ones(size(R,1),size(R,2));
for j=1:size(Q,2)    
%     if(Q(:,j)'*X(:,j)<0)
    if(R(j,j)<0)
        R(j,:) = -R(j,:);
        U(j,:) = -1;
    end
end

% U = R < 0;
% %reLU
% R(U) = -R(U);

R1 = inv(R);
R2 = R1*R1;