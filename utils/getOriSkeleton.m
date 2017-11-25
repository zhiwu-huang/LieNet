% path = 'C:\Scratch\dataset\G3D\Fighting\example_puchright'; %125-151

% path = 'C:\Scratch\dataset\G3D\Fighting\example_kickleft'; %148: 265
close;
% path = 'C:\Scratch\dataset\G3D\Fighting\example_kickleft1'; %66: 204
path = 'C:\Scratch\dataset\G3D\Fighting\example_kickleft148'; %125-151


% imgDir = dir(fullfile(path, '*.png')) ;

h=figure(1);
n =0; 
for d = dir(fullfile(path, '*.png'))' 
    n = n + 1;
    imshow([path '\' d.name]);
    F(n)=getframe(h); 
end
movie2avi(F, 'skeleton_kickleft148_ori.avi', 'compression', 'none');
