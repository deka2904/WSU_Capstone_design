import 'dart:convert';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test1/DATA/disease.dart';
import 'package:test1/Screens/loading_text.dart';
import 'package:test1/Screens/newCamera.dart';
import '../refector.dart';

class mainScreen extends StatefulWidget {
  const mainScreen(
      {super.key,
      required this.serverImage,
      required this.info1,
      required this.info2,
      required this.info3});
  final Uint8List serverImage;
  final String info1;
  final String info2;
  final String info3;
  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  Iterable<ImageFile> _images = [];
  final _formkey = GlobalKey<FormState>();
  String _disName = "서버 정보1";
  String _disFea = "서버 정보2";
  String _disCle = "서버 정보3";
  late Uint8List serverImage;

  void showDialogWithData(BuildContext context) async {}
  List<String> todos = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _disName = widget.info1;
    _disFea = widget.info2;
    _disCle = widget.info3;
    serverImage = widget.serverImage;
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
          IconButton(
            onPressed: () async {
              bool result = todos.contains(_disName);
              print(result);
              if (result == false) {
                todos.add(_disName);
              }
              await saveDisease(_disName);
            },
            icon: Icon(Icons.save_alt),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => (newCamere()),
                ),
                (route) => false,
              );
            },
            icon: Icon(Icons.restore),
          ),
        ],
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: Drawer(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                                      onPressed: () {},
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
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(8),
          color: Colors.white,
          child: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Row(
                      children: [
                        GestureDetector(
                          child: Image.memory(serverImage),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: Container(
                                  child: Image.memory(serverImage),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black45,
                    height: MediaQuery.of(context).size.height * 0.01,
                    thickness: 1.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 1.0,
                    height: MediaQuery.of(context).size.height * 0.23,
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            //폰트별로 특징이 다를떄 사용
                            text: TextSpan(
                              //텍스트나 문단을 모아서 만들수 있음
                              text: "예측되는 질병명 :  ",
                              style: textStyle(
                                  20, Colors.black, FontWeight.w500, 1.2),
                              children: [
                                TextSpan(
                                  text: _disName,
                                  style: textStyle(
                                      20, Colors.black, FontWeight.w500, 1.2),
                                )
                              ],
                            ),
                          ),
                          _sizedBox(null, 0.02),
                          Row(
                            children: [
                              Text(
                                "특징",
                                style: textStyle(
                                    20, Colors.black, FontWeight.w600, 1.0),
                              ),
                              _sizedBox(0.01, null),
                              const Icon(
                                Icons.arrow_circle_down,
                                color: Colors.black87,
                                size: 25,
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(7),
                            child: Text(
                              _disFea,
                              style: textStyle(
                                  15, Colors.black, FontWeight.w500, 1.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black45,
                    height: MediaQuery.of(context).size.height * 0.01,
                    thickness: 1.0,
                  ),
                  Container(
                    padding: const EdgeInsets.all(7),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "해결방법",
                                style: textStyle(
                                    20, Colors.black, FontWeight.w600, 1.0),
                              ),
                              _sizedBox(0.01, null),
                              const Icon(
                                Icons.arrow_circle_down,
                                color: Colors.black87,
                                size: 25,
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(4),
                            child: Text(
                              _disCle,
                              style: textStyle(
                                  15, Colors.black, FontWeight.w500, 1.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _sizedBox(double? wid, double? hei) {
    if (wid == null) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * hei!,
      );
    } else if (hei == null) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * wid,
      );
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width * wid,
        height: MediaQuery.of(context).size.height * hei,
      );
    }
  }
}
