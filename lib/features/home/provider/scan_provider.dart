import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScanState {
  final String? studentName;
  final String? time;
  final String? status;

  ScanState({this.studentName, this.time, this.status});
}

class ScanNotifier extends StateNotifier<ScanState?> {
  ScanNotifier() : super(null);

  void setScanResult(String name, String status) {
    final now = DateTime.now();
    state = ScanState(
      studentName: name,
      status: status,
      time: "${now.hour}:${now.minute}:${now.second}",
    );
  }
  
  void reset() => state = null;
}

final scanProvider = StateNotifierProvider<ScanNotifier, ScanState?>((ref) {
  return ScanNotifier();
});