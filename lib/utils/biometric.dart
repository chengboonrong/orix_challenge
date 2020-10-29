import 'dart:io';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

final LocalAuthentication auth = LocalAuthentication();

Future<bool> checkBiometrics() async {
  try {
    await auth.canCheckBiometrics;
    return true;
  } on PlatformException catch (e) {
    // print(e);
    return null;
  }
}

Future<List> getAvailableBiometrics() async {
  List<BiometricType> availableBiometrics;
  try {
    availableBiometrics = await auth.getAvailableBiometrics();
    if (Platform.isIOS) {
      if (availableBiometrics.contains(BiometricType.face)) {
        // Face ID.
        // print('Yes, you have FaceID.');
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        // Touch ID.
        // print('Yes, you have TouchID.');
      }
    } else {
      // print('Android only has fingerprint sensor :)');
    }

    return availableBiometrics;
  } on PlatformException catch (e) {
    // print(e);
    return null;
  }
}

Future<bool> authenticate() async {
  try {
    var _result = await auth.authenticateWithBiometrics(
        localizedReason: 'Scan your fingerprint to authenticate',
        useErrorDialogs: true,
        stickyAuth: true);
    return _result;
  } on PlatformException catch (e) {
    // print(e);
    return false;
  }
}

void cancelAuthentication() {
  auth.stopAuthentication();
}
