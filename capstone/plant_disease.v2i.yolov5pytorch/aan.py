import cv2
import subprocess
import numpy as np

def perform_object_detection(image_path):
    # YOLO 모델과 가중치 파일 경로 설정
    model_path = 'path/to/yolo_model'
    weights_path = 'path/to/yolo_weights'

    # 이미지 파일 경로 설정
    image_file = image_path

    # detect.py 스크립트 실행
    command = f"python detect.py --source {image_file} --weights {weights_path} --model {model_path}"
    output = subprocess.check_output(command, shell=True)

    # 결과 파일에서 객체 검출 정보 추출
    results = output.decode().strip().split('\n')

    # 이미지 로드
    image = cv2.imread(image_file)

    # 객체 검출 정보를 이용하여 이미지에 박스 그리기
    for result in results:
        class_id, confidence, x, y, w, h = map(float, result.split())
        x = int(x * image.shape[1])
        y = int(y * image.shape[0])
        w = int(w * image.shape[1])
        h = int(h * image.shape[0])
        label = f"Class {int(class_id)}"
        cv2.rectangle(image, (x, y), (x + w, y + h), (0, 255, 0), 2)
        cv2.putText(image, label, (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 255, 0), 2)

    # 결과 이미지 출력
    cv2.imshow("Object Detection", image)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

# 이미지 경로 설정
image_path = 'path/to/your_image.jpg'

# 객체 검출 수행
perform_object_detection(image_path)
