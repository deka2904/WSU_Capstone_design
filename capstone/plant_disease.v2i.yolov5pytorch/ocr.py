import cv2
import os
from PIL import Image
import pytesseract

# 설치한 tesseract 프로그램 경로 (64비트)
pytesseract.pytesseract.tesseract_cmd = r'C:\\Program Files\\Tesseract-OCR\\tesseract'
# 32비트인 경우 => r'C:\Program Files (x86)\Tesseract-OCR\tesseract'

# 이미지 불러오기, Gray 프로세싱
image = cv2.imread("C:\\Users\\deka2\\OneDrive\\Desktop\\capstone\\plant_disease.v2i.yolov5pytorch\\www.jpg")
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

# 이진화를 사용하여 이미지 전처리
_, threshold = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)

# write the thresholded image to disk as a temporary file so we can
# 글자 프로세싱을 위해 이진화된 이미지 임시파일 형태로 저장.
filename = "{}.jpg".format(os.getpid())
cv2.imwrite(filename, threshold)

# Simple image to string
text = pytesseract.image_to_string(Image.open(filename), lang='eng')
os.remove(filename)

print(text)

cv2.imshow("Image", gray)
cv2.waitKey(0)