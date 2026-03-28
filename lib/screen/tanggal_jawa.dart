import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WetonPage extends StatefulWidget {
  const WetonPage({super.key});

  @override
  State<WetonPage> createState() => _WetonPageState();
}

class _WetonPageState extends State<WetonPage> {
  final hariC = TextEditingController();
  final bulanC = TextEditingController();
  final tahunC = TextEditingController();

  String hasil = "";

  @override
  void dispose() {
    hariC.dispose();
    bulanC.dispose();
    tahunC.dispose();
    super.dispose();
  }

  String getHari(int weekday) {
    const hariMap = [
      "", "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu"
    ];
    return hariMap[weekday];
  }

  void hitungWeton() {
    final h = int.tryParse(hariC.text);
    final b = int.tryParse(bulanC.text);
    final t = int.tryParse(tahunC.text);

    if (h == null || b == null || t == null) {
      setState(() => hasil = "Input tidak valid");
      return;
    }

    final date = DateTime(t, b, h);

    if (date.day != h || date.month != b || date.year != t) {
      setState(() => hasil = "Tanggal tidak valid");
      return;
    }

    int a = (14 - b) ~/ 12;
    int y2 = t + 4800 - a;
    int m2 = b + 12 * a - 3;

    int jdn = h +
        ((153 * m2 + 2) ~/ 5) +
        365 * y2 +
        (y2 ~/ 4) -
        (y2 ~/ 100) +
        (y2 ~/ 400) -
        32045;

    const pasaran = ["Legi", "Pahing", "Pon", "Wage", "Kliwon"];

    setState(() {
      hasil = "${getHari(date.weekday)} ${pasaran[jdn % 5]}";
    });
  }

  Widget inputBox(TextEditingController c, String hint) {
    return Expanded(
      child: SizedBox(
        height: 40,
        child: TextField(
          controller: c,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF8F1F7),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFCEBED3)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFF2F84DB),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Hitung Hari Jawa",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 280,
              height: 280,
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                'assets/iconjawa.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                inputBox(hariC, "Hari"),
                const SizedBox(width: 8),
                inputBox(bulanC, "Bulan"),
                const SizedBox(width: 8),
                inputBox(tahunC, "Tahun"),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 200,
              height: 45,
              child: ElevatedButton(
                onPressed: hitungWeton,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F84DB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Hitung Weton",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// RESULT
            if (hasil.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFDCEBFA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
              children: [
                const Text(
                  "Weton Anda yaitu :",
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 10),
                Text(
                  hasil,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            ),
          ],
        ),
      ),
    );
  }
}