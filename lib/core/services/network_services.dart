import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';


class NetworkService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  // Check current connectivity status
  Future<ConnectivityResult> checkConnectivity() async {
    return await _connectivity.checkConnectivity();
  }

  // Check if device is connected to internet
  Future<bool> isConnected() async {
    final result = await checkConnectivity();
    return result != ConnectivityResult.none;
  }

  // Stream of connectivity changes
  Stream<ConnectivityResult> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }

  // Listen to connectivity changes
  void listenToConnectivity(Function(ConnectivityResult) callback) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(callback);
  }

  // Cancel connectivity subscription
  void cancelConnectivitySubscription() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  // Get connectivity status as string
  String getConnectivityStatus(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return 'Connected to WiFi';
      case ConnectivityResult.mobile:
        return 'Connected to Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Connected to Ethernet';
      case ConnectivityResult.vpn:
        return 'Connected via VPN';
      case ConnectivityResult.bluetooth:
        return 'Connected via Bluetooth';
      case ConnectivityResult.other:
        return 'Connected to other network';
      case ConnectivityResult.none:
        return 'No internet connection';
    }
  }

  // Check if connection is WiFi
  Future<bool> isWifi() async {
    final result = await checkConnectivity();
    return result == ConnectivityResult.wifi;
  }

  // Check if connection is mobile data
  Future<bool> isMobileData() async {
    final result = await checkConnectivity();
    return result == ConnectivityResult.mobile;
  }

  // Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
  }
}

// Singleton instance
NetworkService networkService = NetworkService();