import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  Stopwatch stopwatch = Stopwatch();
  Timer? timer;

  List<String> lapTimes = [];

  int initialMilliseconds = 0; // 🔥 untuk waktu awal

  /// FORMAT JAM:MENIT:DETIK:MILI
  String formatTime(int milliseconds) {
    int hours = (milliseconds ~/ 3600000);
    int minutes = (milliseconds ~/ 60000) % 60;
    int seconds = (milliseconds ~/ 1000) % 60;
    int millis = (milliseconds % 1000) ~/ 10;

    return "${hours.toString().padLeft(2, '0')}:"
        "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}."
        "${millis.toString().padLeft(2, '0')}";
  }

  int get totalTime => initialMilliseconds + stopwatch.elapsedMilliseconds;

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
  }

  void startStopwatch() {
    stopwatch.start();
    startTimer();
  }

  void stopStopwatch() {
    stopwatch.stop();
    timer?.cancel();
  }

  void resetStopwatch() {
    stopwatch.reset();
    timer?.cancel();
    lapTimes.clear();
    initialMilliseconds = 0;
    setState(() {});
  }

  void simpanWaktu() {
    setState(() {
      lapTimes.add(formatTime(totalTime));
    });
  }

  /// 🔥 INPUT WAKTU AWAL
  void setInitialTime() {
    TextEditingController jam = TextEditingController();
    TextEditingController menit = TextEditingController();
    TextEditingController detik = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Set Waktu Awal"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: jam,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Jam"),
              ),
              TextField(
                controller: menit,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Menit"),
              ),
              TextField(
                controller: detik,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Detik"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                int h = int.tryParse(jam.text) ?? 0;
                int m = int.tryParse(menit.text) ?? 0;
                int s = int.tryParse(detik.text) ?? 0;

                setState(() {
                  initialMilliseconds =
                      (h * 3600000) + (m * 60000) + (s * 1000);
                });

                Navigator.pop(context);
              },
              child: const Text("Set"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text(
          "Stopwatch",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            /// CARD STOPWATCH
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [

                    const Icon(Icons.timer, size: 60, color: Colors.blue),

                    const SizedBox(height: 20),

                    /// DISPLAY
                    Text(
                      formatTime(totalTime),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// BUTTON ROW
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: startStopwatch,
                          child: const Text("Start",
                              style: TextStyle(color: Colors.white)),
                        ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          onPressed: stopStopwatch,
                          child: const Text("Stop",
                              style: TextStyle(color: Colors.white)),
                        ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: resetStopwatch,
                          child: const Text("Reset",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// SET TIME BUTTON 🔥
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                        ),
                        onPressed: setInitialTime,
                        child: const Text(
                          "Set Waktu Awal",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// SIMPAN
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: simpanWaktu,
                        child: const Text(
                          "Simpan Waktu",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// LAP LIST
            if (lapTimes.isNotEmpty)
              Card(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: lapTimes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(lapTimes[index]),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}