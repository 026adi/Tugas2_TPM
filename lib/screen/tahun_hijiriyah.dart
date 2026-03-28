import 'package:flutter/material.dart';

class HijriyahPage extends StatefulWidget {
  const HijriyahPage({super.key});

  @override
  State<HijriyahPage> createState() => _HijriyahPageState();
}

class _HijriyahPageState extends State<HijriyahPage> {

  final TextEditingController tanggal = TextEditingController();
  String hasil = "";

  @override
  void dispose() {
    tanggal.dispose();
    super.dispose();
  }

  void konversiHijriyah() {
    if (!mounted) return;

    final input = tanggal.text.trim();

    if (input.isEmpty || !input.contains("-")) {
      setState(() {
        hasil = "Format harus YYYY-MM-DD!";
      });
      return;
    }

    try {
      final parts = input.split("-");
      if (parts.length != 3) throw Exception();

      final tahun = int.parse(parts[0]);
      final bulan = int.parse(parts[1]);
      final hari = int.parse(parts[2]);

      final date = DateTime(tahun, bulan, hari);

      /// VALIDASI TANGGAL
      if (date.year != tahun || date.month != bulan || date.day != hari) {
        setState(() {
          hasil = "Tanggal tidak valid!";
        });
        return;
      }

      /// =========================
      /// 🔥 KONVERSI KE JDN
      /// =========================
      int a = (14 - bulan) ~/ 12;
      int y = tahun + 4800 - a;
      int m = bulan + 12 * a - 3;

      int jdn = hari +
          ((153 * m + 2) ~/ 5) +
          365 * y +
          (y ~/ 4) -
          (y ~/ 100) +
          (y ~/ 400) -
          32045;

      /// =========================
      /// 🔥 JDN → HIJRI
      /// =========================
      int l = jdn - 1948440 + 10632;
      int n = (l - 1) ~/ 10631;
      l = l - 10631 * n + 354;
      int j = ((10985 - l) ~/ 5316) *
              ((50 * l) ~/ 17719) +
          (l ~/ 5670) *
              ((43 * l) ~/ 15238);
      l = l -
          ((30 - j) ~/ 15) *
              ((17719 * j) ~/ 50) -
          (j ~/ 16) *
              ((15238 * j) ~/ 43) +
          29;

      int bulanH = (24 * l) ~/ 709;
      int hariH = l - (709 * bulanH) ~/ 24;
      int tahunH = 30 * n + j - 30;

      final namaBulanHijri = [
        "",
        "Muharram",
        "Safar",
        "Rabiul Awal",
        "Rabiul Akhir",
        "Jumadil Awal",
        "Jumadil Akhir",
        "Rajab",
        "Sya'ban",
        "Ramadhan",
        "Syawal",
        "Dzulqa'dah",
        "Dzulhijjah"
      ];

      /// =========================
      /// 🔥 TAHUN JAWA
      /// =========================
      final tahunJawa = tahunH + 512;

      setState(() {
        hasil =
            "Masehi:\n$input\n\n"
            "Hijriyah:\n"
            "$hariH ${namaBulanHijri[bulanH]} $tahunH\n\n"
            "Tahun Jawa:\n$tahunJawa";
      });

    } catch (e) {
      setState(() {
        hasil = "Input tidak valid!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Konversi Hijriyah"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: tanggal,
              keyboardType: TextInputType.datetime,
              decoration: const InputDecoration(
                labelText: "Masukkan tanggal (YYYY-MM-DD)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: konversiHijriyah,
              child: const Text("Konversi"),
            ),

            const SizedBox(height: 30),

            Text(
              hasil,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

          ],
        ),
      ),
    );
  }
}