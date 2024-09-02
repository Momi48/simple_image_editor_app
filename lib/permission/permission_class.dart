import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermission() async {
  if (await Permission.storage.request().isGranted) {
    debugPrint('Permission Granted');
  } else {
    debugPrint('Permssion is Denied');
  }
}
