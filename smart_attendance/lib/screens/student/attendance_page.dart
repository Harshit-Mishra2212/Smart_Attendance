import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:local_auth/local_auth.dart';

class AttendancePage extends StatefulWidget {
  final String className;
  const AttendancePage({super.key, required this.className});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final MobileScannerController _controller = MobileScannerController();
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _hasScanned = false;

  /// Step 1: Fingerprint, Step 2: Face, Step 3: Show QR info
  Future<void> _authenticateAndProcess(String qrData) async {
    try {
      // 🔹 Step 1: Fingerprint authentication
      final bool fingerprintOk = await _localAuth.authenticate(
        localizedReason: 'Place your finger to confirm attendance',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (!fingerprintOk) {
        debugPrint('❌ Fingerprint failed');
        _hasScanned = false;
        return;
      }
      debugPrint('✅ Fingerprint success');

    


      // 🔹 Step 3: Process QR data
      String qrInfo;
      final uri = Uri.tryParse(qrData);
      if (uri != null && uri.queryParameters.containsKey('code')) {
        final link = uri.origin + uri.path;
        final classParam = uri.queryParameters['class'];
        final codeParam = uri.queryParameters['code'];
        qrInfo = 'Link: $link, Class: $classParam, Code: $codeParam';
      } else if (qrData.contains('|')) {
        final parts = qrData.split('|');
        qrInfo = 'Link: ${parts[0]}, Number: ${parts.length > 1 ? parts[1] : 'n/a'}';
      } else {
        qrInfo = 'Raw QR: $qrData';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Attendance recorded ✅\n$qrInfo')),
        );
      }
    } catch (e) {
      debugPrint('Biometric error: $e');
      _hasScanned = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.className} Attendance')),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: MobileScanner(
              controller: _controller,
              onDetect: (capture) {
                if (_hasScanned) return;
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  final raw = barcodes.first.rawValue;
                  if (raw != null) {
                    _hasScanned = true;
                    _controller.stop(); // stop scanning temporarily
                    _authenticateAndProcess(raw).then((_) {
                      // Restart scanner for next student if needed:
                      // _hasScanned = false;
                      // _controller.start();
                    });
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          const Text('Point camera at the class QR to mark attendance'),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
