function aa =  calRotAngel(r)

% a1 = -asin(r(3));
% ca1 = real(cos(a1));
% r6 = real(r(6));
% r9 = real(r(9));
% r2 = real(r(2));
% r1 = real(r(1));
% a2 = atan2(r6/ca1,r9/ca1);
% a3 = atan2(r2/ca1,r1/ca1);
% 
% aa = (abs(a1)+abs(a2)+abs(a3))/3;
% % aa = max([abs(a1),abs(a2),abs(a3)]);


 epsilon = 1e-12;
 mtrc = trace(r);

 
 if (abs(mtrc - 3) <= epsilon)
     aa = 0;
 elseif (abs(mtrc + 1) <= epsilon)
     aa = pi;
 else
     aa = acos((mtrc - 1)/2);
 end


%  if (abs(mtrc - 3) <= epsilon)|| (abs(mtrc + 1) <= epsilon)
%      aa = 0;
%   else
%      aa = acos((mtrc - 1)/2);
%      if aa > pi/2
%          aa = pi - aa;
%      end
%  end


%   axis_angle = vrrotmat2vec_modified(r);
%   aa = sum(abs(axis_angle(1)*axis_angle(2:4)));  