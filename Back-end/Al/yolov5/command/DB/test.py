import pymysql
from PIL import Image
import io

def convertToBinaryData(filename):
    # Convert digital data to binary format
    with open(filename, 'rb') as file:
        binaryData = file.read()
    return binaryData

def DBTEST(filename):
    try:
        data = convertToBinaryData(filename)
        con = pymysql.connect(host='localhost', user='root', password='1234',
                       db='test1', charset='utf8') # 한글처리 (charset = 'utf8')

        sql = "INSERT INTO image(image) VALUES (%s)"
        cur = con.cursor()  
        cur.execute(sql, data)
        con.commit()
    except Exception as e:
        print(e)
# STEP 5: DB 연결 종료
    finally:
        con.close() 
    
    
def DBinsert(DisName,DisFea,DisSol,filename,number):
    try:
        data = convertToBinaryData(filename)
        con = pymysql.connect(host='localhost', user='root', password='1234',
                       db='test1', charset='utf8') # 한글처리 (charset = 'utf8')

        sql = "INSERT INTO pleantdisease(DisName, DisFea, DisSol, image, number) VALUES (%s,%s,%s,%s,%s)"
        cur = con.cursor()  
        cur.execute(sql, (DisName,DisFea,DisSol,data,number))
        con.commit()
    except Exception as e:
        print(e)
# STEP 5: DB 연결 종료
    finally:
        con.close() 
        


def DBSelect(number):
    try:
        con = pymysql.connect(host='localhost', user='root', password='1234',
                       db='test1', charset='utf8') # 한글처리 (charset = 'utf8')
        
        sql = "SELECT * FROM test1.pleantdisease WHERE number = %s"
        cur = con.cursor()  
        cur.execute(sql, (number,))
        result = cur.fetchone()
        ary = []
        ary.append(result[1])#명
        ary.append(result[2])#특징
        ary.append(result[3])#해결법
        ary.append(result[4])#이미지

        return ary
    except Exception as e:
        print(e)
# STEP 5: DB 연결 종료
    finally:
        con.close()        
        
        
def DBSelect_text(text):
    try:
        con = pymysql.connect(host='localhost', user='root', password='1234',
                       db='test1', charset='utf8') # 한글처리 (charset = 'utf8')
        sql = "SELECT * FROM test1.pleantdisease WHERE DisName = %s"
        cur = con.cursor()  
        cur.execute(sql, (text,))
        result = cur.fetchone()
        ary = []
        ary.append(result[1])#명
        ary.append(result[2])#특징
        ary.append(result[3])#해결법
        ary.append(result[4])#이미지

        return ary
    except Exception as e:
        print(e)
# STEP 5: DB 연결 종료
    finally:
        con.close()        



