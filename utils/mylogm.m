function r = mylogm(m)
%VRROTMAT2VEC Convert rotation from matrix to axis-angle representation.
%   R = VRROTMAT2VEC(M) returns an axis-angle representation of  
%   rotation defined by the rotation matrix M.
%
%   R = VRROTMAT2VEC(M, OPTIONS) converts the rotation with the default 
%   algorithm parameters replaced by values defined in the structure
%   OPTIONS.
%
%   The OPTIONS structure contains the following parameters:
%
%     'epsilon'
%        Minimum value to treat a number as zero. 
%        Default value of 'epsilon' is 1e-12.
%
%   The result R is a 4-element axis-angle rotation row vector.
%   First three elements specify the rotation axis, the last element
%   defines the angle of rotation.
%
%   See also VRROTVEC2MAT, VRROTVEC.

%   Copyright 1998-2011 HUMUSOFT s.r.o. and The MathWorks, Inc.
%   $Revision: 1.1.6.2 $ $Date: 2011/04/02 01:08:49 $ $Author: batserve $

% Rotation axis elements flipping in the singular case phi == pi 
% is discussed here:
% www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToAngle

% mtrc = trace(m);
% 
% % general case
% phi = acos((mtrc - 1)/2);
% den = 2*sin(phi);
% axis = [m(2,1)-m(1,2) m(3,1)-m(1,3) m(3,2)-m(2,3)] ./ den;
% r = [phi axis];

% X_t = m;
m_m = (m(1,1)+m(2,2)+m(3,3)-1)/2;
m_s = (m(2,1)-m(1,2))^2+(m(3,1)-m(1,3))^2+(m(3,2)-m(2,3))^2;
phi1 = acos(m_m);
axis1 = [m(2,1)-m(1,2) m(3,1)-m(1,3) m(3,2)-m(2,3)] ./ sqrt(m_s);
r = [phi1 axis1];

  
