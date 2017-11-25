function F = plot_skeleton_g3d_i (joint_locations,parts,FigPath, layerInd, labelText)

% parts = body_model.bones;
% joint_locations = skeletal_data{j,1}.joint_locations;

% figure; hold on;

BE = parts;

if strcmp(labelText, 'punch left')
    BE1 = BE([5, 7, 9, 11],:);
    BE2 = BE([1, 2, 3, 4, 6, 8, 10, 12, 13, 14, 15, 16, 17, 18, 19], :);
end

%punch right
if strcmp(labelText, 'punch right')
    
    BE1 = BE([4, 6, 8, 10],:);
    BE2 = BE([1, 2, 3, 5, 7, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19], :);
end

%kick left
% BE1 = BE([12, 14, 16, 18],:);
% BE2 = BE([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19], :);

%kick right
if strcmp(labelText, 'kick right')
    BE1 = BE([13, 15, 17, 19],:);
    BE2 = BE([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 16, 18], :);
end



for n = 1:size(joint_locations,3)    
    close;
    h=figure(1);

    C=joint_locations(:,:,n)'; 

%     plot3( ...
%         [C(BE(:,1),1) C(BE(:,2),1)]', ...
%         [C(BE(:,1),2) C(BE(:,2),2)]', ...
%         [C(BE(:,1),3) C(BE(:,2),3)]', ...
%         '-bo', ...
%         'LineWidth',2, ...
%         'MarkerSize',8, ...
%         'MarkerEdgeColor','k', ...
%         'MarkerFaceColor','r');


   plot3( ...
        [C(BE2(:,1),1) C(BE2(:,2),1)]', ...
        [C(BE2(:,1),2) C(BE2(:,2),2)]', ...
        [C(BE2(:,1),3) C(BE2(:,2),3)]', ...
        '-bo', ...
        'LineWidth',2, ...
        'MarkerSize',8, ...
        'MarkerEdgeColor','k', ...
        'MarkerFaceColor','r');
    
    
    hold on;
    
    plot3( ...
        [C(BE1(:,1),1) C(BE1(:,2),1)]', ...
        [C(BE1(:,1),2) C(BE1(:,2),2)]', ...
        [C(BE1(:,1),3) C(BE1(:,2),3)]', ...
        '-ro', ...
        'LineWidth',2, ...
        'MarkerSize',8, ...
        'MarkerEdgeColor','k', ...
        'MarkerFaceColor','r');
    
    
    if layerInd == 0
        layertext1 = 'Input Skeletons';
        layertext2 = 'predict:--';
    elseif layerInd == 1 || layerInd == 3 || layerInd == 5
        layertext1 = ['Reconstructed Skeletons of RotMap Layer' num2str((layerInd+1)/2)];
        layertext2 = 'predict:--';
        
    elseif layerInd == 2 || layerInd == 4 || layerInd == 6
        layertext1 = ['Reconstructed Skeletons of RotPooling Layer' num2str(layerInd/2)];
        layertext2 = 'predict:--';
        
    elseif layerInd == 7
        layertext1 = 'Reconstructed Skeletons of LogMap Layer';
        layertext2 = 'predict:--';
        
    else
        layertext1 = 'Reconstructed Skeletons of Output Layer';
        layertext2 = ['predict:' labelText];
        
    end
    
    axis equal;
    axis image;
    
%     position1 = [50 50];
%     position2 = [50 800];
    
    layertext = ['label:' labelText];
    
    dim = [0.01 0.1 0.3 0.3];
    annotation('textbox',dim,'String',layertext,'FitBoxToText','on','Color','green','FontSize',14);
    
    dim = [0.01 0.01 0.3 0.3];
    annotation('textbox',dim,'String',layertext2,'FitBoxToText','on','Color','red','FontSize',14);
   
  
    
    title(layertext1,'Color','blue','FontSize',14);

%     text(position1(1),position1(2),layertext1,'Color','green','FontSize',18);
% 
%     text(position2(1),position2(2),layertext2,'Color','green','FontSize',18);
    
    
    axis off;
    
    
  
    
    set(gcf,'Color','white');
    drawnow;
    len = length(FigPath);
    
    F(n)=getframe(h);

%     print(1, [FigPath(1:len-4) '_' num2str(n) '.png'], '-dpng') ;

end

