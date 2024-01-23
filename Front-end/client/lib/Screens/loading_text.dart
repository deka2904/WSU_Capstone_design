import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:http/http.dart' as http;

import 'mainScreen.dart';

class Loading2 extends StatefulWidget {
  const Loading2({super.key, required this.disName});
  final String disName;
  @override
  State<Loading2> createState() => _Loading2State();
}

class _Loading2State extends State<Loading2> {
  late String im;
  String? disName;

  @override
  void initState() {
    super.initState();
    disName = widget.disName;
    GetMydisease_text(disName!);
  }

  void GetMydisease_text(String disName) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.101.117.230:5000/text_info'));
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

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => mainScreen(
      //       serverImage: decodedImage,
      //       info1: jsonData['info1'],
      //       info2: jsonData['info2'],
      //       info3: jsonData['info3'],
      //     ),
      //   ),
      // );
    } else {
      print('Failed to upload image. Error code: ${response.statusCode}');
    }

    //서버와 통신하는 코드 작성
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.green,
                Colors.cyan,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const SpinKitDoubleBounce(
            color: Colors.white,
            size: 80.0,
          ),
        ),
      ),
    );
  }
}
