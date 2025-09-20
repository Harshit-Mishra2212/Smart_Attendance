import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

class AttendanceChartPage extends StatefulWidget {
  final int classId;
  AttendanceChartPage({required this.classId});

  @override
  _AttendanceChartPageState createState() => _AttendanceChartPageState();
}

Future<void> fetchAttendance() async {
  final response = await http.get(
    Uri.parse("http://YOUR_SERVER_IP:5000/get_attendance?class_id=${widget.classId}")
  );
  if (response.statusCode == 200) {
    setState(() {
      attendanceData = json.decode(response.body);
    });
  }
}


  @override
  void initState() {
    super.initState();
    fetchAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Attendance Record")),
      body: attendanceData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: attendanceData.length,
                    itemBuilder: (context, index) {
                      var student = attendanceData[index];
                      return ListTile(
                        title: Text(student['name']),
                        subtitle: Text("Attendance: ${student['attendance_percent']}%"),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      barGroups: attendanceData.map((student) {
                        return BarChartGroupData(
                          x: attendanceData.indexOf(student),
                          barRods: [
                            BarChartRodData(
                              toY: double.parse(student['attendance_percent'].toString()),
                              width: 15,
                              color: Colors.blue,
                            )
                          ],
                        );
                      }).toList(),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() < attendanceData.length) {
                                return Text(
                                  attendanceData[value.toInt()]['name'],
                                  style: TextStyle(fontSize: 10),
                                );
                              }
                              return Text('');
                            },
                          ),
                        ),
                      ),
                      maxY: 100,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
