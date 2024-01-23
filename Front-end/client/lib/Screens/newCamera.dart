import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test1/Screens/loading.dart';
import 'package:test1/refector.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../DATA/disease.dart';
import 'loading_text.dart';
import 'mainScreen.dart';
import 'package:http/http.dart' as http;

class newCamere extends StatefulWidget {
  const newCamere({Key? key}) : super(key: key);

  @override
  State<newCamere> createState() => _newCamereState();
}

class _newCamereState extends State<newCamere> {
  List<String> todos = [];

  Future<void> _takePhoto() async {
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
      maxWidth: MediaQuery.of(context).size.width,
      maxHeight: MediaQuery.of(context).size.height,
    );
    final bytes = await File(image!.path).readAsBytes();

    if (image != null) {
      ImageFile imageFile = ImageFile(image.name,
          name: image.name,
          extension: image.path.split('.').last,
          bytes: bytes,
          path: image.path,
          readStream: image.openRead());

      print(imageFile);
      // setState(() {
      //   controller.addImage(imageFile);
      // });
    }
  }

  final controller = MultiImagePickerController(
    images: <ImageFile>[],
    withData: true,
    maxImages: 3,
    withReadStream: true,
    allowedImageTypes: ['png', 'jpg', 'jpeg'],
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    disease();
  }

  void disease() async {
    List<dynamic> userData = await getDisease();
    for (var ele in userData) {
      todos.add(ele);
    }
  }

  DateTime? currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      final msg = "'뒤로'버튼을 한 번 더 누르면 종료됩니다.";

      Fluttertoast.showToast(msg: msg);
      return Future.value(false);
    }

    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              if (controller.images.length >= 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Loading(images: controller.images),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      content: Text("사진을 선택해주세요"),
                    );
                  },
                );
              }
            },
            child: Text(
              "확인하기",
              style: textStyle(15, Colors.black87, FontWeight.w600, 1.5),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: Drawer(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                child: Center(
                  child: Text(
                    "북마크",
                    style: textStyle(20, Colors.black, FontWeight.w600, 1.0),
                  ),
                ),
              ),
              Divider(color: Colors.black54, height: 1.0),
              TextButton(
                onPressed: () async {
                  print(await getDisease());
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        content: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            itemCount: todos.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Dismissible(
                                // 삭제 버튼 및 기능 추가
                                key: Key(todos[index]),
                                child: Card(
                                  elevation: 4,
                                  margin: EdgeInsets.all(8),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: ListTile(
                                    leading: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Loading2(
                                              disName: todos[index],
                                            ),
                                          ),
                                        );

                                        // Navigator.pushAndRemoveUntil(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (BuildContext context) =>
                                        //         Loading2(
                                        //       disName: todos[index],
                                        //     ),
                                        //   ),
                                        //   (route) => false,
                                        // );
                                      },
                                      child: Text(
                                        todos[index],
                                        style: textStyle(16, Colors.black,
                                            FontWeight.normal, 1.0),
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_sharp,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                onDismissed: (direction) async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.remove(todos[index]);
                                  setState(() {
                                    todos.removeAt(index);
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  "검색기록 확인",
                  style: textStyle(16, Colors.black, FontWeight.normal, 1.0),
                ),
              ),
              Divider(color: Colors.black54, height: 1.0),
              TextButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear();
                    todos.clear();
                  },
                  child: Text(
                    "기록 초기화",
                    style: textStyle(16, Colors.black, FontWeight.normal, 1.0),
                  )),
              Divider(color: Colors.black54, height: 1.0),
            ],
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Container(
          padding: const EdgeInsets.all(8),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "사진을 선택해주세요",
                        style:
                            textStyle(30, Colors.black, FontWeight.w500, 1.2),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "최대 3장까지 업로드 가능합니다",
                        style:
                            textStyle(15, Colors.black, FontWeight.w500, 1.2),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.black87,
                height: 15,
                thickness: 0.5,
              ),
              MultiImagePickerView(
                draggable: true,
                onChange: (list) {
                  debugPrint(list.toString());
                },
                controller: controller,
                padding: const EdgeInsets.all(10),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.black,
                      elevation: 1.0,
                      onPressed: () {
                        if (controller.images.length < 3)
                          _takePhoto();
                        else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                content: Text("사진은 최대 3장 가능합니다."),
                              );
                            },
                          );
                        }
                      },
                      child: Icon(Icons.camera_alt_outlined, size: 30),
                    ),
                  ],
                ),
              ),
            ],
          ),
          color: Colors.white,
        ),
      ),
    );
  }

  void GetMydisease_text(String disName) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.101.50.92:5000/text_info'));
    var data = {'disName': disName};
    var jsonEncodedData = jsonEncode(data);
    request.fields['UploadJsonData'] = jsonEncodedData;
    var response = await request.send();
    if (response.statusCode == 200) {
      //Uint8List imageBytes = await response.stream.toBytes();
      var imageBytes = await response.stream.bytesToString();
      var jsonData = jsonDecode(imageBytes);
      print(jsonData['info1']);
      print(jsonData['info2']);
      print(jsonData['info3']);
      Uint8List decodedImage = base64.decode(jsonData['image']);

// 디코딩된 이미지를 Flutter Image 위젯에 사용
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => mainScreen(
            serverImage: decodedImage,
            info1: jsonData['info1'],
            info2: jsonData['info2'],
            info3: jsonData['info3'],
          ),
        ),
        (route) => false,
      );
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(
      //       builder: (BuildContext context) =>
      //           MyImageScreen(imageUrl: jsonData['image'])),
      //   (route) => false,
      // );
    } else {
      print('Failed to upload image. Error code: ${response.statusCode}');
    }

    //서버와 통신하는 코드 작성
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
