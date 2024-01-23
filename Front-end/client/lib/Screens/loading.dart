import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:http/http.dart' as http;

import 'mainScreen.dart';

class Loading extends StatefulWidget {
  const Loading({super.key, required this.images});
  final Iterable<ImageFile> images;
  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Iterable<ImageFile> _images = [];
  late String im;
  @override
  void initState() {
    super.initState();
    _images = widget.images;
    print(_images.elementAt(0).path!);
    GetMydisease();
  }

  void GetMydisease() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.101.117.230:5000/upload_image'));
    request.files.add(
        await http.MultipartFile.fromPath('image', _images.elementAt(0).path!));
    print(request);
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
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(
      //       builder: (BuildContext context) =>
      //           MyImageScreen(imageUrl: jsonData['image'])),
      //   (route) => false,
      // );
    } else {
      print('Failed to upload image. Error code: ${response.statusCode}');
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('사진이 입력되지 않았습니다', textAlign: TextAlign.center),
        ),
      );
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
