import cv2
import numpy as np
import matplotlib.pyplot as plt

def compute_glcm(image):
    # Convert the image to grayscale
    gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    
    # Compute the GLCM with specified parameters
    glcm = cv2.imgproc.textureCorrelation(gray_image, 0, 1, 256)
    
    return glcm

def visualize_glcm(glcm):
    # Normalize the GLCM for visualization
    glcm_normalized = glcm / np.sum(glcm)
    
    # Plot the GLCM
    plt.imshow(glcm_normalized, cmap='gray')
    plt.title('Normalized GLCM')
    plt.colorbar()
    plt.show()

# Load an image
image_path = r"D:\茶叶干燥过程\茶叶多光谱图像\热风第二批140个样+水分\1鲜叶_processed\1\25个波段对应的图像\interestingspace\1.bmp"
image = cv2.imread(image_path)

# Compute the GLCM
glcm = compute_glcm(image)

# Visualize the GLCM
visualize_glcm(glcm)
