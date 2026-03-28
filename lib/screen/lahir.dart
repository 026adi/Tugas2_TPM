import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TanggalLahirPage extends StatefulWidget {
  const TanggalLahirPage({super.key});

  @override
  State<TanggalLahirPage> createState() => _TanggalLahirPageState();
}

class _TanggalLahirPageState extends State<TanggalLahirPage> {
  final tahun = TextEditingController();
  final bulan = TextEditingController();
  final hari = TextEditingController();
  final jam = TextEditingController();
  final menit = TextEditingController();

  String hasil = "";
  Timer? timer;
  DateTime? tanggalLahir;

  @override
  void dispose() {
    timer?.cancel();
    tahun.dispose();
    bulan.dispose();
    hari.dispose();
    jam.dispose();
    menit.dispose();
    super.dispose();
  }

  void mulaiHitung() {
    final t = int.tryParse(tahun.text);
    final b = int.tryParse(bulan.text);
    final h = int.tryParse(hari.text);
    final j = int.tryParse(jam.text);
    final m = int.tryParse(menit.text);

    if (t == null || b == null || h == null || j == null || m == null) {
      setState(() {
        hasil = "Input harus angka!";
      });
      return;
    }

    final inputDate = DateTime(t, b, h, j, m);

    if (inputDate.year != t || inputDate.month != b || inputDate.day != h) {
      setState(() {
        hasil = "Tanggal tidak valid!";
      });
      return;
    }

    tanggalLahir = inputDate;

    timer?.cancel();
    timer = Timer.periodic(const Duration(minutes: 1), (_) {
      hitungUmur();
    });

    hitungUmur();
  }

  void hitungUmur() {
    if (tanggalLahir == null) return;

    final now = DateTime.now();
    Duration diff = now.difference(tanggalLahir!);

    int totalDetik = diff.inSeconds;

    int tahunU = totalDetik ~/ (365 * 24 * 3600);
    int sisa = totalDetik % (365 * 24 * 3600);

    int bulanU = sisa ~/ (30 * 24 * 3600);
    sisa = sisa % (30 * 24 * 3600);

    int hariU = sisa ~/ (24 * 3600);
    sisa = sisa % (24 * 3600);

    int jamU = sisa ~/ 3600;
    int menitU = (sisa % 3600) ~/ 60;

    setState(() {
      hasil =
          "Umur Anda Sekarang :\n\n"
          "$tahunU Tahun, $bulanU Bulan, $hariU Hari\n\n"
          "$jamU Jam, $menitU menit";
    });
  }

  Widget buildInput(TextEditingController c, String hint, {double flex = 1}) {
    return Expanded(
      flex: flex.toInt(),
      child: SizedBox(
        height: 42,
        child: TextField(
          controller: c,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textAlign: TextAlign.left,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
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
                color: Color(0xFFCFBED2),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2),
              borderSide: const BorderSide(
                color: Color(0xFFCFBED2),
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
    );
  }

  Widget inputRow3() {
    return Row(
      children: [
        buildInput(hari, "Hari"),
        const SizedBox(width: 8),
        buildInput(bulan, "Bulan"),
        const SizedBox(width: 8),
        buildInput(tahun, "Tahun"),
      ],
    );
  }

  Widget inputRow2() {
    return Row(
      children: [
        buildInput(jam, "Jam"),
        const SizedBox(width: 8),
        buildInput(menit, "Menit"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2F84DB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          "Hitung Umur",
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
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2F84DB), // biru
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.cake,
                    size: 32,
                    color: Colors.white, // icon jadi terang
                  ),
                ),
                const SizedBox(height: 34),

                inputRow3(),
                const SizedBox(height: 8),
                inputRow2(),
                const SizedBox(height: 18),

                SizedBox(
                  height: 30,
                  child: ElevatedButton(
                    onPressed: mulaiHitung,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F84DB),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      minimumSize: const Size(92, 30),
                    ),
                    child: const Text(
                      "Generate",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                if (hasil.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCEBFA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      hasil,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
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