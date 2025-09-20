import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SessionPage extends StatefulWidget {
  final String className;
  const SessionPage({super.key, required this.className});

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  DateTime selectedDate = DateTime.now();

  // Store generated integers
  late List<int> randomIntegers;
  int currentIndex = 0;
  Timer? qrTimer;

  // Link for QR (static for one session)
  final String baseLink = "https://smart-attendance.app/session";

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023, 1),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF3B82F6),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF3B82F6),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  /// Start attendance session -> open popup with QR
  void _startAttendance() {
    // Generate 20 random integers
    final random = Random();
    randomIntegers = List.generate(20, (_) => random.nextInt(9000) + 1000);

    currentIndex = 0;

    // Start timer to update QR every 5 sec
    qrTimer?.cancel();
    qrTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        if (currentIndex < randomIntegers.length - 1) {
          currentIndex++;
        } else {
          timer.cancel(); // stop after last integer
        }
      });
    });

    // Show dialog with QR
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            String qrData =
                "$baseLink?class=${widget.className}&code=${randomIntegers[currentIndex]}";

            // Timer inside dialog
            qrTimer?.cancel();
            qrTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
              if (currentIndex < randomIntegers.length - 1) {
                currentIndex++;
                setStateDialog(() {});
              } else {
                timer.cancel();
              }
            });

            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              title: const Text("Attendance Session"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Code: ${randomIntegers[currentIndex]}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    qrTimer?.cancel();
                    Navigator.of(context).pop();
                  },
                  child: const Text("End Session"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    qrTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isToday = DateTime.now().year == selectedDate.year &&
        DateTime.now().month == selectedDate.month &&
        DateTime.now().day == selectedDate.day;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.className} Attendance"),
        backgroundColor: const Color(0xFF3B82F6),
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.calendar_today,
                    color: Color(0xFF3B82F6)),
                title: Text(
                  "Selected Date",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                      fontSize: 16),
                ),
                subtitle: Text(
                  DateFormat('EEEE, dd MMM yyyy').format(selectedDate),
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_calendar,
                      color: Color(0xFF3B82F6)),
                  onPressed: _pickDate,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: isToday
                  ? ElevatedButton.icon(
                      icon: const Icon(Icons.qr_code_2),
                      label: const Text("Start Attendance Session"),
                      onPressed: _startAttendance,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 28),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    )
                  : Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      color: Colors.grey[100],
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Attendance history for this date will appear here.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
