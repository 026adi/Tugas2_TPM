import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class WetonPage extends StatefulWidget {
  const WetonPage({super.key});

  @override
  State<WetonPage> createState() => _WetonPageState();
}

class _WetonPageState extends State<WetonPage> {
  final TextEditingController hariC = TextEditingController();
  final TextEditingController bulanC = TextEditingController();
  final TextEditingController tahunC = TextEditingController();

  String hasil = "";

  final List<String> pasaran = ["Legi", "Pahing", "Pon", "Wage", "Kliwon"];

  @override
  void dispose() {
    hariC.dispose();
    bulanC.dispose();
    tahunC.dispose();
    super.dispose();
  }

  void hitungWeton() {
  if (!mounted) return;

  final hText = hariC.text;
  final bText = bulanC.text;
  final tText = tahunC.text;

  if (hText.isEmpty || bText.isEmpty || tText.isEmpty) {
    setState(() {
      hasil = "Isi semua!";
    });
    return;
  }

  final hari = int.tryParse(hText);
  final bulan = int.tryParse(bText);
  final tahun = int.tryParse(tText);

  if (hari == null || bulan == null || tahun == null) {
    setState(() {
      hasil = "Harus angka!";
    });
    return;
  }

  final date = DateTime(tahun, bulan, hari);

  int a = (14 - bulan) ~/ 12;
  int y2 = tahun + 4800 - a;
  int m2 = bulan + 12 * a - 3;

  int jdn = hari +
      ((153 * m2 + 2) ~/ 5) +
      365 * y2 +
      (y2 ~/ 4) -
      (y2 ~/ 100) +
      (y2 ~/ 400) -
      32045;

  final pasaran = ["Legi", "Pahing", "Pon", "Wage", "Kliwon"];
  final hasilPasaran = pasaran[jdn % 5];

  final hariMasehi = getHari(date.weekday);

  setState(() {
    hasil = "$hariMasehi $hasilPasaran";
  });
}

  String getHari(int weekday) {
    switch (weekday) {
      case 1:
        return "Senin";
      case 2:
        return "Selasa";
      case 3:
        return "Rabu";
      case 4:
        return "Kamis";
      case 5:
        return "Jumat";
      case 6:
        return "Sabtu";
      case 7:
        return "Minggu";
      default:
        return "";
    }
  }

  Widget inputBox(TextEditingController c, String label) {
    return Expanded(
      child: TextField(
        controller: c,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weton Jawa"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                inputBox(hariC, "Hari"),
                const SizedBox(width: 10),
                inputBox(bulanC, "Bulan"),
                const SizedBox(width: 10),
                inputBox(tahunC, "Tahun"),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: hitungWeton,
              child: const Text("Hitung Weton"),
            ),
            const SizedBox(height: 30),
            Text(
              hasil,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}