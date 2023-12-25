import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:watch_tower_flutter/pages/login.dart';
import 'package:watch_tower_flutter/services/device_services.dart';
import 'package:watch_tower_flutter/services/payload_services.dart';
import 'package:watch_tower_flutter/utils/alert_utils.dart';
import 'package:watch_tower_flutter/utils/login_utils.dart';
import 'login_Services.dart';
import './user_info.dart';
import 'db_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class WritingResult {
  NfcData nfcData;
  bool status;
  WritingResult(this.nfcData, this.status);
}

class NfcData {
  String card_id;
  String name;
  Location loc;

  NfcData({required this.card_id, required this.name, required this.loc});

  factory NfcData.fromJson(Map<String, dynamic> json) {
    return NfcData(
      card_id: json['ID'] as String,
      name: json['name'] as String,
      loc: Location.fromJson(json['loc']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'card_id': card_id,
      'name': name,
      'loc': loc.toJson(),
    };
  }
}

class Location {
  String lat;
  String long;

  Location({required this.lat, required this.long});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat'],
      long: json['long'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'long': long,
    };
  }
}

class NfcService {
  String BaseUrl = LoginUtils().baseUrl;
  // Future<bool> resetReadOrder() async {
  //   try {
  //     print('inside reset read order');
  //     final response = await http.get(
  //       Uri.parse(BaseUrl + 'reset'),
  //     );
  //     if (response.statusCode == 200) {
  //       print(response.body);
  //       return true;
  //     } else {
  //       print(response.body);
  //       return false;
  //     }
  //   } catch (e) {
  //     print('Error in resetReadOrder : $e');
  //     return false;
  //   }
  // }

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

  Future<ApiResponse> getOrderArray() async {
    if (await HttpServices().verifyToken()) {
      try {
        print(
            '====================================Order which the system expects==================================== ');
        final response = await http.get(
          Uri.parse(BaseUrl + 'tagOrder/get'),
        );

        final statusCode = response.statusCode;
        final responseBody = response.body;

        print('Response Status Code: $statusCode');
        print('Response Body: $responseBody');

        return ApiResponse(statusCode, responseBody);
      } catch (e) {
        print("Error in fetching ORDER : $e");
        return ApiResponse(-1, "Error: $e");
      }
    } else {
      print('JWT is not valid');
      return ApiResponse(-1, "Error: JWT is not valid");
    }
  }

  static ValueNotifier<dynamic> result = ValueNotifier(null);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<int> tagRead(BuildContext context, String sessionId) async {
    if (await HttpServices().verifyToken()) {
      Completer<int> completer = Completer<int>();

      try {
        NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
          try {
            result.value = tag.data;

            List<int> intList = PayloadServices().convertStringToArray(
                PayloadServices().getPayload(result.toString()));
            String payload_as_String =
                PayloadServices().decodedResultPayload((intList));

            result.value = payload_as_String;

            payload_as_String = await UserInfoService()
                .updateUserInfo(payload_as_String, sessionId);

            if (payload_as_String.length > 2) {
              int statusCode =
                  await DbServices().saveToDatabase(context, payload_as_String);
              NfcManager.instance.stopSession();
              completer.complete(statusCode);
            }
          } catch (e) {
            NfcManager.instance.stopSession();
            completer.complete(-1);
          }
        });

        return completer.future;
      } catch (e) {
        AlertUtils().errorAlert(
            'Unexpected error occurred, please check your connection', context);
        Navigator.pop(context);
        print('error in tagread: $e');
        return -1;
      }
    } else {
      await AlertUtils()
          .errorAlert('Session Timeout. Please login again', context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
      print('JWT is not valid');
      return -1;
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
  Future<WritingResult> writeService(NfcData newNfcTag) async {
    Future<WritingResult> writeNfcData(NfcData tagData) async {
      try {
        String json = jsonEncode(tagData.toJson());
        bool success = false;
        await NfcManager.instance.stopSession();

        await NfcManager.instance.startSession(
            onDiscovered: (NfcTag tag) async {
          var ndef = Ndef.from(tag);

          if (ndef == null || !ndef.isWritable) {
            await NfcManager.instance
                .stopSession(errorMessage: 'Tag is not ndef writable');
            return;
          }

          NdefMessage message = NdefMessage([
            NdefRecord.createText(json),
          ]);

          try {
            await ndef.write(message);
            print('Success to ndef write');
            success = true;
            await NfcManager.instance.stopSession();
          } on PlatformException catch (e) {
            await NfcManager.instance.stopSession();

            print('Platform Exception: $e');
          } catch (e) {
            await NfcManager.instance.stopSession();

            print('Exception: $e');
          }
        });

        await Future.delayed(Duration(milliseconds: 500));

        if (success) {
          print('Success achieved!');
          await NfcManager.instance.stopSession();
          return WritingResult(tagData, true);
        } else {
          print('Retrying...');
          await NfcManager.instance.stopSession();
          return writeNfcData(tagData);
        }
      } catch (e) {
        print('Error: $e');
        await NfcManager.instance.stopSession();
        return writeNfcData(tagData);
      }
    }

    return writeNfcData(newNfcTag);
  }

//////////
  Future<NfcData> createNfcData(String name) async {
    var uuid = Uuid();
    String uniqueId = uuid.v4();
    List<String> location = await DeviceService().getLocation();
    print('======================LOCATION======================');
    print(location);
    if (location[0] == 'err') {
      AlertUtils()
          .getCustomToast("Please enable your location services.", Colors.red);
      throw Exception('Error getting location');
    } else {
      Location loc = Location(lat: location[0], long: location[1]);
      print('======================LOCATION======================');
      print(location[0]);
      print(location[1]);
      NfcData nfcData = NfcData(card_id: uniqueId, name: name, loc: loc);
      print('======================NFC DATA======================');
      print(nfcData.toJson());
      return nfcData;
    }
  }
}
