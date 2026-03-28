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
    if (!mounted) return;

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

    /// VALIDASI
    if (inputDate.year != t ||
        inputDate.month != b ||
        inputDate.day != h) {
      setState(() {
        hasil = "Tanggal tidak valid!";
      });
      return;
    }

    tanggalLahir = inputDate;

    timer?.cancel();

    /// 🔥 UPDATE SETIAP 1 MENIT
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
          "Umur Kamu:\n\n"
          "$tahunU Tahun\n"
          "$bulanU Bulan\n"
          "$hariU Hari\n\n"
          "$jamU Jam\n"
          "$menitU Menit";
    });
  }

  Widget inputBox(TextEditingController c, String label) {
    return TextField(
      controller: c,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hitung Umur")),
body: SingleChildScrollView(
  child: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [

        Row(
          children: [
            Expanded(child: inputBox(hari, "Hari")),
            const SizedBox(width: 10),
            Expanded(child: inputBox(bulan, "Bulan")),
            const SizedBox(width: 10),
            Expanded(child: inputBox(tahun, "Tahun")),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(child: inputBox(jam, "Jam")),
            const SizedBox(width: 10),
            Expanded(child: inputBox(menit, "Menit")),
          ],
        ),

        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: mulaiHitung,
          child: const Text("Hitung Umur"),
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
),
);
}
}