import subprocess
from torch import tensor

# def predict(self, x):
#     x = self.forward(x)
    
#     return x

def yolo_1234(directory):
    resultDic = directory.split("\\")
    #print(resultDic[resultDic.length-1])
    resultDic2 = resultDic[-1].split(".")
    
    command = "python detect.py --source %s --weights C:\\Users\\MM\\Desktop\\yo_test\\yolov5\\plant_disease.v2i.yolov5pytorch\\best.pt --conf 0.02 --project C:\\Users\\MM\\Desktop\\yo_test\\yolov5\\plant_disease.v2i.yolov5pytorch\\ultra_workdir3\\output --name=run_image --exist-ok --line-thickness 2 --save-txt"%(directory)
    
    try:
        subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT, universal_newlines=True)
        return result(resultDic2[0])

    except subprocess.CalledProcessError as e:
        print("오류 발생:", e.output)
    
# 텍스트 파일 경로 설정

def result(dic):
    file_path = "C:\\Users\\MM\\Desktop\\yo_test\\yolov5\\plant_disease.v2i.yolov5pytorch\\ultra_workdir3\\output\\run_image\\labels\%s.txt"%(dic)
    # 배열 초기화
    text_array = []

    # 텍스트 파일 읽기
    with open(file_path, "r") as file:
    # 파일의 각 줄을 읽어 배열에 추가
        for line in file:
    #     # 줄바꿈 문자 제거하고 배열에 추가 
            text_array.append(line[0])
    print(text_array)
    print(most_frequent(text_array))
    
    return most_frequent(text_array)
    # 결과 출력

def most_frequent(data):
    return max(data, key=data.count)
# try:
#     output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT)
#     output = output.decode("utf-8")  # 또는 다른 유효한 인코딩으로 디코딩

#     print(output)
# except subprocess.CalledProcessError as e:
#     print("오류 발생:", e.output.decode("utf-8"))  # 또는 다른 유효한 인코딩으로 디코딩



