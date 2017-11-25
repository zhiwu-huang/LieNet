function r = vrrotmat2vec_modified(m, options)
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

% test input arguments
narginchk(1, 2);

if any(~isreal(m) || ~isnumeric(m))
    error(message('sl3d:vrdirorirot:argnotreal'));
end

if ((size(m,1) ~= 3) || (size(m,2) ~= 3))
    error(message('sl3d:vrdirorirot:argbaddim33'));
end

if nargin == 1
    
    % default options values
    epsilon = 1e-12;
    
else
    if ~isstruct(options)
        error(message('sl3d:vrdirorirot:optsnotstruct'));
    else
        % check / read the 'epsilon' option
        if ~isfield(options,'epsilon')
            error(message('sl3d:vrdirorirot:optsfieldnameinvalid'));
        elseif (~isreal(options.epsilon) || ~isnumeric(options.epsilon) || options.epsilon < 0)
            error(message('sl3d:vrdirorirot:optsfieldvalueinvalid'));
        else
            epsilon = options.epsilon;
        end
        
    end
    
end

% make the conversion

mtrc = trace(m);

if (abs(mtrc - 3) <= epsilon)
    
    % phi == 0
    % use default VRML SFRotation, [0 1 0 0], see VRML97 Standard, C.6.7
    r = [0 0 1 0];
    
elseif  (abs(mtrc + 1) <= epsilon)
    %     fprintf('phi is equal to pi!!!!!');
    
    % phi == pi
    % This singularity requires elaborate sign ambiguity resolution
    
    % compute axis of rotation, make sure all elements are >= 0
    % real signs are obtained by the flipping algorithm below
    axis = sqrt(max((diag(m)' + 1)./2, [0 0 0]));
    % axis elements that are <= epsilon set to zero
    axis = axis .* (axis > epsilon);
    
    % Flipping
    %
    % The algorithm uses the elements above diagonal to determine the signs
    % of rotation axis coordinate in the singular case Phi = pi.
    % All valid combinations of 0, positive and negative values lead to
    % 3 different cases:
    % If (Sum(signs)) >= 0 ... leave all coordinates positive
    % If (Sum(signs)) == -1 and all values are non-zero
    %   ... flip the coordinate that is missing in the term that has + sign,
    %       e.g. if 2AyAz is positive, flip x
    % If (Sum(signs)) == -1 and 2 values are zero
    %   ... flip the coord next to the one with non-zero value
    %   ... ambiguous, we have chosen shift right
    
    % construct vector [M23 M13 M12] ~ [2AyAz 2AxAz 2AxAy]
    % (in the order to facilitate flipping):    ^
    %                                  [no_x  no_y  no_z ]
    
    m_upper = [m(2,3) m(1,3) m(1,2)];
    % elements with || smaller than epsilon are considered to be 0
    signs = sign(m_upper) .* (abs(m_upper) > epsilon);
    
    if (sum(signs) >= 0)
        % none of the signs is negative
        
        % don't flip any axis element
        flip = [1 1 1];
        fprintf('phi is equal to pi, case 1!');
        
    elseif isempty (find(signs == 0, 1))
        % none of the signs is zero, 2 negative 1 positive
        
        % flip the coordinate that is missing in the term that has + sign
        flip = -signs;
        fprintf('phi is equal to pi, case 2!');
        
    else
        % 2 signs are 0, 1 negative
        
        % flip the coord to the right of the one with non-zero value
        % [-1 0 0]->[1 -1 1], [0 -1 0]->[1 1 -1], [0 0 -1]->[-1 1 1]
        shifted = [signs(3) signs(1) signs(2)];
        flip = shifted + (shifted == 0);
        fprintf('phi is equal to pi, case 3!');
        
    end
    
    % flip the axis
    axis = axis .* flip;
    r = [pi axis];
    
    % Modification that ensures A = vrrotvec2mat(vrrotmat2vec(A)) when angle
    % is equal to pi
    
    thr = 10^-5;
    t = r;
    if (norm(vrrotvec2mat(r) - m, 'fro') > thr)
        
        r(1) = -r(1);
        
        if (norm(vrrotvec2mat(r) - m, 'fro') > thr)
            
            r = t;
            r(2) = -r(2);
            
            if (norm(vrrotvec2mat(r) - m, 'fro') > thr)
                
                r = t;
                r(3) = -r(3);
                
                if (norm(vrrotvec2mat(r) - m, 'fro') > thr)
                    
                    % 	  error('Could not find an appropriate value');
                    fprintf('Could not find an appropriate value');
                end
                
            end
            
        end
        
    end
    
    
else
    
    %general case
    %   phi = acos((mtrc - 1)/2);
    %   den = 2*sin(phi);
    %   axis = [m(2,1)-m(1,2) m(3,1)-m(1,3) m(3,2)-m(2,3)] ./ den;
    %   r1 = [phi axis];
    
    
    m_m = (m(1,1)+m(2,2)+m(3,3)-1)/2;
    m_s = (m(2,1)-m(1,2))^2+(m(3,1)-m(1,3))^2+(m(3,2)-m(2,3))^2;
    phi1 = acos(m_m);
    axis1 = [m(2,1)-m(1,2) m(3,1)-m(1,3) m(3,2)-m(2,3)] ./ sqrt(m_s);
    r = [phi1 axis1];
    
    %   sum(abs(r-r1))
end

