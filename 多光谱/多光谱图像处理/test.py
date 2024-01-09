import os
import cv2
import pandas as pd
input_folder = r'D:\茶叶干燥过程\茶叶多光谱图像\热风第二批140个样+水分\7碾茶_processed'
result_folder = r'D:\茶叶干燥过程\茶叶多光谱图像\热风第二批140个样+水分\纹理3'

for folder_number in range(1, 21):
  
    W9 = []
    H9 = []

    for image_index in range(1, 26):
        # Construct the full path to the image
        image_path = os.path.join(input_folder, str(folder_number), '25个波段对应的图像\interestingspace', f'{image_index}.bmp')

        # Read the image
        A = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)

        if A is not None:
            # Calculate mean and standard deviation
            m = A.mean()
            s = A.std()

            # Compute GLCM
            GLCM11 = cv2.calcGLCM(A, [0, 1], symmetric=True, normed=True)

            # Compute texture properties
            contrast, correlation, energy, homogeneity = cv2.compareHist(GLCM11.flatten(), GLCM11.flatten(), cv2.HISTCMP_CHISQR_ALT), cv2.compareHist(GLCM11.flatten(), GLCM11.flatten(), cv2.HISTCMP_CORREL), cv2.compareHist(GLCM11.flatten(), GLCM11.flatten(), cv2.HISTCMP_INTERSECT), cv2.compareHist(GLCM11.flatten(), GLCM11.flatten(), cv2.HISTCMP_BHATTACHARYYA)
            T1 = [contrast, correlation, energy, homogeneity]
            T2 = [m, s]

            # Append the features to the lists
            W9.append(T1)
            H9.append(T2)
        else:
            print(f'Error reading image: {image_path}')

    if len(W9) > 0 and len(H9) > 0:
        # Create a DataFrame for the features
        df = pd.DataFrame(W9, columns=['Contrast', 'Correlation', 'Energy', 'Homogeneity'])
        df[['Mean', 'Std']] = pd.DataFrame(H9, columns=['Mean', 'Std'])

        # Save the DataFrame to Excel
        result_filename = f'{folder_index + 120:03d}.xlsx'
        result_path = os.path.join(result_folder, result_filename)
        df.to_excel(result_path, index=False)
