import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:http/http.dart' as http;
import 'package:watch_tower_flutter/pages/login.dart';
import 'package:watch_tower_flutter/services/payload_services.dart';
import 'package:watch_tower_flutter/utils/alert_utils.dart';
import 'package:watch_tower_flutter/utils/login_utils.dart';
import 'login_Services.dart';
import './user_info.dart';
import 'db_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NfcService {
  String BaseUrl = LoginUtils().baseUrl;
  Future<bool> resetReadOrder() async {
    try {
      final response = await http.get(
        Uri.parse(BaseUrl + 'reset'),
      );
      if (response.statusCode == 200) {
        print(response.body);
        return true;
      } else {
        print(response.body);
        return false;
      }
    } catch (e) {
      print('Error in resetReadOrder : $e');
      return false;
    }
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<void> printAllSharedPreferences() async {
    print('================SHARED PREFERENCES================');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> allData =
        prefs.getKeys().fold({}, (previousValue, key) {
      previousValue[key] = prefs.get(key);
      return previousValue;
    });

    print("SharedPreferences Data:");
    allData.forEach((key, value) {
      print("$key: $value");
    });
  }

  Future<ApiResponse> getOrderArray(BuildContext context) async {
    if (await HttpServices().verifyToken()) {
      try {
        print(
            '====================================Order which the system expects==================================== ');
        final response = await http.get(
          Uri.parse(BaseUrl + 'order'),
        );

        final statusCode = response.statusCode;
        final responseBody = response.body;

        print('Response Status Code: $statusCode');
        print('Response Body: $responseBody');

        return ApiResponse(statusCode, responseBody);
      } catch (e) {
        print("Error in fetching ORDER : $e");
        print("Error in fetching ORDER : $e");
        return ApiResponse(-1, "Error: $e");
      }
    } else {
      await AlertUtils()
          .errorAlert('Session  Timeout. Please login again', context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
      print('JWT is not valid');
      return ApiResponse(-1, "Error: JWT is not valid");
    }
  }

  static ValueNotifier<dynamic> result = ValueNotifier(null);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<bool> tagRead(BuildContext context) async {
    if (await HttpServices().verifyToken()) {
      Completer<bool> completer = Completer<bool>();

      try {
        NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
          try {
            result.value = tag.data;

            List<int> intList = PayloadServices().convertStringToArray(
                PayloadServices().getPayload(result.toString()));
            String payload_as_String =
                PayloadServices().decodedResultPayload((intList));

            result.value = payload_as_String;

            payload_as_String =
                await UserInfoService().updateUserInfo(payload_as_String);
                
            if (payload_as_String.length > 2) {
              if (await DbServices()
                  .saveToDatabase(context, payload_as_String)) {
                NfcManager.instance.stopSession();
                completer.complete(
                    true); // Complete the Future with true for successful condition
              } else {
                NfcManager.instance.stopSession();
                completer.complete(
                    false); // Complete the Future with false for failure
              }
            }
          } catch (e) {
            NfcManager.instance.stopSession();
            completer.complete(
                false); // Complete the Future with false in case of an exception
          }
        });

        // Return the Future from the Completer
        return completer.future;
      } catch (e) {
        AlertUtils().errorAlert(
            'Unexpected error occured ,please check your connection', context);
        Navigator.pop(context);
        print('error in tagread :  $e');
        return false;
      }
    } else {
      await AlertUtils()
          .errorAlert('Session Timeout.Please login again', context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
      print('JWT is not valid');
      return false;
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  String updateMessage(String lat, String long, String id) {
    String jsonData = '''
{
  "ID":"$id",
  "name": "APP",
  "loc": {
    "lat" :"$lat",
    "long" :"$long"
  }
}
''';
    return jsonData;
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void resetNfcTag() async {
    if (await HttpServices().verifyToken()) {
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        var ndef = Ndef.from(tag);
        if (ndef == null || !ndef.isWritable) {
          result.value = 'Tag is not ndef writable';
          NfcManager.instance.stopSession(errorMessage: result.value);
          return;
        }

        // Create an NDEF record with the text "TEST"
        String testText = 'D';
        Uint8List payload = Uint8List.fromList(testText.codeUnits);
        NdefRecord testRecord = NdefRecord.createMime('text/plain', payload);

        NdefMessage testMessage = NdefMessage([testRecord]);

        try {
          await ndef.write(testMessage);
          result.value = 'NFC tag resetted successfully';
          print(" NFC tag resetted successfully");
          NfcManager.instance.stopSession();
        } catch (e) {
          NfcManager.instance
              .stopSession(errorMessage: result.value.toString());
        }
      });
    } else {
      print('JWT is not valid');
    }
  }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
