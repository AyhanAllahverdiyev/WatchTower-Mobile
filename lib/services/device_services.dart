import 'dart:async';
import 'package:torch_light/torch_light.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nfc_manager/nfc_manager.dart';
import '../utils/login_utils.dart';

class DeviceService {
    String BaseUrl = LoginUtils().baseUrl;

  static const platform = MethodChannel('battery');

  static Future<int?> getBatteryLevel() async {
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      return result;
    } on PlatformException {
      return -1;
    }
  }

  Future<List<String>?> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Request location permission
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied.');
    }

    try {
      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      String lat = position.latitude.toString();
      String long = position.longitude.toString();

      // Return latitude and longitude as an array
      return [lat, long];
    } catch (e) {
      throw Exception('Error getting location: $e');
    }
  }

  Future<void> toggleTorch(bool torch) async {
    if (torch) {
      await _enableTorch();
    } else {
      await _disableTorch();
    }
  }

  Future<void> _enableTorch() async {
    print('=========================TOGGLE TORCH=========================');
    try {
      await TorchLight.enableTorch();
    } on Exception catch (_) {
      print('Could not enable torch');
    }
  }

  Future<void> _disableTorch() async {
    print('=========================TOGGLE TORCH=========================');
    try {
      await TorchLight.disableTorch();
    } on Exception catch (_) {
      print('Could not disable torch');
    }
  }

  Future<bool> writeService(
      ValueNotifier<dynamic> result, String jsonData) async {
    try {
      bool tagFound = false;
      bool writeSuccess = false;

      await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        tagFound = true;
        var ndef = Ndef.from(tag);
        if (ndef == null || !ndef.isWritable) {
          result.value = 'Tag is not ndef writable';
          NfcManager.instance.stopSession(errorMessage: result.value);
          return;
        }

        NdefMessage message = NdefMessage([
          NdefRecord.createText(jsonData.toString()),
        ]);
        print('messagedata inside ndef write:');
        print(message.toString());

        try {
          await ndef.write(message);
          result.value = 'Success to "Ndef Write"';
          print('Success to ndef write');
          writeSuccess = true;
        } on PlatformException catch (e) {
          result.value = 'PlatformException: $e';
        } catch (e) {
          result.value = 'An error occurred: $e';
        } finally {
          NfcManager.instance.stopSession();
        }
      });

      if (!tagFound) {
        result.value = 'No NFC tag found. Please scan an NFC tag.';
      }

      return writeSuccess;
    } catch (e) {
      result.value = 'An error occurred while starting the NFC session: $e';
      return false;
    }
  }
}
