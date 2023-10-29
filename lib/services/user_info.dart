import 'dart:convert';
import '../services/device_services.dart';

class UserInfoService {
  Future<String> updateUserInfo(String jsonString) async {
    try {
      Map<String, dynamic> jsonData = jsonDecode(jsonString);

      print('inside the adduserinfo.dart file');
      print(jsonData);

      jsonData['battery_level'] = await DeviceService.getBatteryLevel();
      print('after adding batttery ');
      print(jsonData);

      String updatedJsonString = jsonEncode(jsonData);

      return updatedJsonString;
    } catch (e) {
      print(e);
      return 'error';
    }
  }
}
