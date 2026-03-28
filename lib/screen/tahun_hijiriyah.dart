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

      if (date.year != tahun || date.month != bulan || date.day != hari) {
        setState(() {
          hasil = "Tanggal tidak valid!";
        });
        return;
      }

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

      int l = jdn - 1948440 + 10632;
      int n = (l - 1) ~/ 10631;
      l = l - 10631 * n + 354;
      int j = ((10985 - l) ~/ 5316) * ((50 * l) ~/ 17719) +
          (l ~/ 5670) * ((43 * l) ~/ 15238);
      l = l -
          ((30 - j) ~/ 15) * ((17719 * j) ~/ 50) -
          (j ~/ 16) * ((15238 * j) ~/ 43) +
          29;

      int bulanH = (24 * l) ~/ 709;
      int hariH = l - (709 * bulanH) ~/ 24;
      int tahunH = 30 * n + j - 30;

      const namaBulanHijri = [
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

      final tahunJawa = tahunH + 512;

      setState(() {
        hasil =
            "Masehi   :   $input\n"
            "Hijriyah :   $hariH ${namaBulanHijri[bulanH]} $tahunH\n"
            "Tahun Jawa : $tahunJawa";
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2F84DB),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Konversi Hijriyah",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2F84DB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.nightlight_round,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 34),

                SizedBox(
                  height: 38,
                  child: TextField(
                    controller: tanggal,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      hintText: "Masukkan tanggal (YYYY-MM-DD)",
                      hintStyle: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8F1F7),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide: const BorderSide(
                          color: Color(0xFFCEBED3),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide: const BorderSide(
                          color: Color(0xFFCEBED3),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide: const BorderSide(
                          color: Color(0xFFB99FC0),
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                Center(
                  child: SizedBox(
                    width: 120,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: konversiHijriyah,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F84DB),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Konversi",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                if (hasil.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCEBFA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      hasil,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.7,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}