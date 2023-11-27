import 'dart:convert';
import 'dart:io';
import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_info/model/iso_battery_info.dart';
import 'package:watch_tower_flutter/utils/login_utils.dart';

import '../services/device_services.dart';

class UserInfoService {
  String BaseUrl = LoginUtils().baseUrl;

  Future<String> updateUserInfo(String jsonString) async {
    try {
      Map<String, dynamic> jsonData = jsonDecode(jsonString);

      print("##################################################");

      if (Platform.isAndroid) {
        print('inside the android if statement');

        jsonData['battery_level'] = await DeviceService.getBatteryLevel();
      } else if (Platform.isIOS) {
        print('inside the ios if statement');
        int? level = (await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel;
        jsonData['battery_level'] = level;  
      }
     
      jsonData['user_id'] = await LoginUtils().getUserId();
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
