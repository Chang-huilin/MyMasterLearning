result_folder = 'D:\茶叶干燥过程\茶叶多光谱图像\热风第二批140个样+水分\纹理2\';

for folder_index = 1:20
   
     folder_name = num2str(folder_index);
    W9 = zeros(25, 16);
    H9 = zeros(25, 2);

    for image_index = 1:25
        % Construct the full path to the image
        image_path = fullfile('D:\茶叶干燥过程\茶叶多光谱图像\热风第二批140个样+水分\1鲜叶_processed', folder_name, '25个波段对应的图像\interestingspace', [num2str(image_index) '.bmp']);
        
        % Read the image
        A = imread(image_path);
        
        % Calculate mean and standard deviation
        m = mean2(A);
        s = std2(A);
        
        % Convert the image to grayscale
        A = im2gray(A);
        
        % Compute GLCM
        GLCM11 = graycomatrix(A, 'offset', [0 1; -1 1; -1 0; -1 -1]);
        
        % Compute texture properties
        stats1 = graycoprops(GLCM11, {'Contrast', 'Correlation', 'Energy', 'Homogeneity'});
        T1 = [stats1.Contrast stats1.Correlation stats1.Energy stats1.Homogeneity];
        T2 = [m s];
        
        % Store the features in matrices
        W9(image_index, :) = T1;
        H9(image_index, :) = T2;
    end
    
    % Save the results to Excel
    result_filename = sprintf('%03d.xlsx', folder_index+120);
    result_path = fullfile(result_folder, result_filename);
    xlswrite(result_path, W9);
end
