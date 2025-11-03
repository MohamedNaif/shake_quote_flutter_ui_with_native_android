import 'package:flutter/services.dart';

/// Service to handle communication with native Android shake detection
class ShakeService {
  static const EventChannel _shakeEventChannel = EventChannel(
    'com.example.shake_quote/shake_events',
  );

  static const MethodChannel _shakeMethodChannel = MethodChannel(
    'com.example.shake_quote/shake_methods',
  );

  Stream<String>? _shakeStream;

  /// Get a stream of shake events from native Android
  Stream<String> getShakeStream() {
    _shakeStream ??= _shakeEventChannel.receiveBroadcastStream().map(
      (event) => event.toString(),
    );
    return _shakeStream!;
  }

  /// Start shake detection (optional - already starts when listening to stream)
  Future<bool> startShakeDetection() async {
    try {
      final result = await _shakeMethodChannel.invokeMethod<bool>(
        'startShakeDetection',
      );
      return result ?? false;
    } on PlatformException catch (e) {
      print('Error starting shake detection: ${e.message}');
      return false;
    }
  }

  /// Stop shake detection
  Future<bool> stopShakeDetection() async {
    try {
      final result = await _shakeMethodChannel.invokeMethod<bool>(
        'stopShakeDetection',
      );
      return result ?? false;
    } on PlatformException catch (e) {
      print('Error stopping shake detection: ${e.message}');
      return false;
    }
  }
}
