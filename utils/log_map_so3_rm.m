function [direction] = log_map_so3_rm(start_point, end_point)

    axis_angle = vrrotmat2vec_modified(end_point*start_point');
        
    direction = axis_angle(1:3)*axis_angle(4);    
end
