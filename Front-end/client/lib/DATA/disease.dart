import 'package:shared_preferences/shared_preferences.dart';

// 질병명 저장하기
Future<void> saveDisease(String diseaseName) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('$diseaseName', diseaseName);
}

// 질병명 불러오기
Future<List> getDisease() async {
  final prefs = await SharedPreferences.getInstance();
  //return prefs.getString('DiseaseName');
  return prefs.getKeys().toList();
}
