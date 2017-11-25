function  data_location_i = cal_joint_location(data_rot, data_location,joint_unknow)

bone1_global = data_location(:, 2) - data_location(:, 1);
bone2_global = data_location(:, 4) - data_location(:, 3);

if joint_unknow == 4
    
    R = vrrotvec2mat(vrrotvec(bone1_global, [1, 0, 0]));
    r = vrrotmat2vec(data_rot);
    
    b1 = cal_vec_from_rotation(R*bone1_global, R*bone2_global, r);
    
    
    data_location_i = inv(R)*b1+data_location(:, 3);
else
    error('skeleton id are expected to be the 4-th');
end