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

  Future<List<String>> getLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        LocationPermission permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      String lat = position.latitude.toString();
      String long = position.longitude.toString();

      return [lat, long];
    } catch (e) {
      print('Error getting location: $e');
      return ['err'];
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
}
