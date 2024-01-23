import base64
import json
import os
from tkinter.tix import IMAGE
from flask import Flask, request, jsonify, send_file
import DB.test as db
import DB.command as co

app = Flask(__name__)





@app.route('/upload_image', methods=['POST'])
def upload_image():
    if 'image' not in request.files:
        return jsonify({'error': 'no image uploaded'}), 400
    print("(--------------------------------)")
    image = request.files['image']
    upload_folder = r"C:\Users\MM\Desktop\aaaa"
    if not os.path.exists(upload_folder):
        os.makedirs(upload_folder)
    filename = os.path.join(upload_folder, image.filename)
    image.save(filename)   
    
    number = co.yolo_1234(filename)
    
    try:
        
        result = db.DBSelect(number)
        encoded_image = base64.b64encode(result[3]).decode('utf-8')
        return jsonify({'image': encoded_image,'info1' : result[0],'info2' : result[1],'info3' : result[2]}), 200
    except Exception as e:
        print("error" + str(e))
        return jsonify({'error': 'image upload failed'}), 500
    
    
    
@app.route('/text_info', methods=['POST'])
def text_info():

    try:
        json_str = request.form['UploadJsonData']
        print(json_str)
        data_dict = json.loads(json_str)
        # 회원 정보 추출
        text = data_dict['disName']
        
        
        
        result = db.DBSelect_text(text)
        encoded_image = base64.b64encode(result[3]).decode('utf-8')
        return jsonify({'image': encoded_image,'info1' : result[0],'info2' : result[1],'info3' : result[2]}), 200
    except Exception as e:
        print("error" + str(e))
        return jsonify({'error': '다시한번 시도해주세요'}), 500
    
@app.route('/', methods=['GET', 'POST'])
def handle_request():
    return "Flask Server & Android are Working Successfully"        


@app.route('/upload', methods=['POST'])
def upload():
    # 이미지를 저장하고, 분석을 수행하는 코드 작성

    return jsonify({'success': 'image uploaded and analyzed'}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)