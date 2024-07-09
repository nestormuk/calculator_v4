import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService._privateConstructor();

  static final ConnectivityService _instance =
  ConnectivityService._privateConstructor();

  static ConnectivityService get instance => _instance;

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();

  void initialize() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      // Assuming you care about the first result in the list
      var result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      _showConnectivitySnackBar(result != ConnectivityResult.none);
    });

    _checkInitialConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _showConnectivitySnackBar(connectivityResult != ConnectivityResult.none);
  }

  void _showConnectivitySnackBar(bool isConnected) {
    String message =
    isConnected ? 'Connected to the Internet' : 'No Internet Connection';
    Color bgColor = isConnected ? Colors.green : Colors.red;

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bgColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
