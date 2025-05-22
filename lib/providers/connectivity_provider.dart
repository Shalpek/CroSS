import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  ConnectivityProvider() {
    Connectivity().onConnectivityChanged.listen((result) {
      final online = result != ConnectivityResult.none;
      if (_isOnline != online) {
        _isOnline = online;
        notifyListeners();
      }
    });
    // Проверяем начальное состояние
    Connectivity().checkConnectivity().then((result) {
      final online = result != ConnectivityResult.none;
      if (_isOnline != online) {
        _isOnline = online;
        notifyListeners();
      }
    });
  }
}