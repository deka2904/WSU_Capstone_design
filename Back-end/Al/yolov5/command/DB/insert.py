import test as db


DisName = "마름병 (Blight)"
DisFea = "색변화, 마름 현상"
DisSol = "병든 부분을 제거한다. 분갈이를 하여 오염된 흙을 제거한다. 적당한 양의 살균제를 사용한다."
image = r"C:\Users\MM\Desktop\aaaa\KakaoTalk_20230524_164723475.jpg"
number = "4"
db.DBinsert(DisName,DisFea,DisSol,image,number)