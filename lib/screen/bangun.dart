import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BangunPage extends StatefulWidget {
  const BangunPage({super.key});

  @override
  State<BangunPage> createState() => _BangunPageState();
}

class _BangunPageState extends State<BangunPage> {
  final TextEditingController _alasController = TextEditingController();
  final TextEditingController _tinggiController = TextEditingController();

  double? _luasAlas;
  double? _luasPermukaan;
  double? _volume;
  String? _errorMessage;

  // Rumus piramida persegi:
  //   Luas Alas      = s²
  //   Tinggi Sisi (apotema sisi tegak) = √((s/2)² + t²)
  //   Luas Permukaan = Luas Alas + 4 × (½ × s × apotema)
  //                  = s² + 2 × s × √((s/2)² + t²)
  //   Volume         = ⅓ × Luas Alas × t
  void _hitung() {
    final String inputAlas = _alasController.text.trim();
    final String inputTinggi = _tinggiController.text.trim();

    if (inputAlas.isEmpty || inputTinggi.isEmpty) {
      setState(() {
        _errorMessage = 'Semua field harus diisi.';
        _luasAlas = null;
        _luasPermukaan = null;
        _volume = null;
      });
      return;
    }

    final double? alas = double.tryParse(inputAlas);
    final double? tinggi = double.tryParse(inputTinggi);

    if (alas == null || tinggi == null || alas <= 0 || tinggi <= 0) {
      setState(() {
        _errorMessage = 'Masukkan angka positif yang valid.';
        _luasAlas = null;
        _luasPermukaan = null;
        _volume = null;
      });
      return;
    }

    final double luasAlas = alas * alas;
    final double apotema = sqrt(pow(alas / 2, 2) + pow(tinggi, 2));
    final double luasPermukaan = luasAlas + (2 * alas * apotema);
    final double volume = (1 / 3) * luasAlas * tinggi;

    setState(() {
      _errorMessage = null;
      _luasAlas = luasAlas;
      _luasPermukaan = luasPermukaan;
      _volume = volume;
    });
  }

  void _reset() {
    _alasController.clear();
    _tinggiController.clear();
    setState(() {
      _luasAlas = null;
      _luasPermukaan = null;
      _volume = null;
      _errorMessage = null;
    });
  }

  String _format(double val) {
    // Tampilkan tanpa desimal jika bulat, maks 4 angka di belakang koma
    if (val == val.truncateToDouble()) {
      return val.toStringAsFixed(0);
    }
    return val.toStringAsFixed(4).replaceAll(RegExp(r'0+$'), '');
  }

  Widget _hasilCard({
    required IconData icon,
    required Color color,
    required String label,
    required String rumus,
    required double nilai,
    required String satuan,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  rumus,
                  style: TextStyle(
                    fontSize: 11,
                    color: color.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${_format(nilai)} $satuan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _alasController.dispose();
    _tinggiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Luas & Volume Piramida'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ilustrasi piramida
            Center(
              child: Column(
                children: [
                  CustomPaint(
                    size: const Size(140, 110),
                    painter: _PyramidPainter(),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Piramida Persegi',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black45,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Card input
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Masukkan Ukuran',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Field alas
                    TextField(
                      controller: _alasController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*')),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Panjang Alas (s)',
                        hintText: 'Contoh: 6',
                        prefixIcon: const Icon(Icons.square_outlined),
                        suffixText: 'cm',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 14),

                    // Field tinggi
                    TextField(
                      controller: _tinggiController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*')),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Tinggi Piramida (t)',
                        hintText: 'Contoh: 4',
                        prefixIcon: const Icon(Icons.height),
                        suffixText: 'cm',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _hitung(),
                    ),

                    // Pesan error
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          border: Border.all(color: Colors.red.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline,
                                color: Colors.red, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              _errorMessage!,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // Tombol aksi
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _reset,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reset'),
                            style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: _hitung,
                            icon: const Icon(Icons.calculate),
                            label: const Text(
                              'Hitung',
                              style: TextStyle(fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Hasil perhitungan
            if (_luasAlas != null) ...[
              const SizedBox(height: 24),
              const Text(
                'Hasil Perhitungan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              _hasilCard(
                icon: Icons.grid_4x4,
                color: Colors.orange,
                label: 'Luas Alas',
                rumus: 'L.alas = s²',
                nilai: _luasAlas!,
                satuan: 'cm²',
              ),
              _hasilCard(
                icon: Icons.dashboard_outlined,
                color: Colors.purple,
                label: 'Luas Permukaan',
                rumus: 'L.perm = s² + 2s√((s/2)² + t²)',
                nilai: _luasPermukaan!,
                satuan: 'cm²',
              ),
              _hasilCard(
                icon: Icons.change_history,
                color: Colors.teal,
                label: 'Volume',
                rumus: 'V = ⅓ × s² × t',
                nilai: _volume!,
                satuan: 'cm³',
              ),
            ],

            const SizedBox(height: 16),

            // Info rumus
            ExpansionTile(
              leading: const Icon(Icons.info_outline, color: Colors.blue),
              title: const Text(
                'Lihat Rumus',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('s  = panjang sisi alas'),
                      Text('t  = tinggi piramida'),
                      Text('ap = apotema sisi tegak = √((s/2)² + t²)'),
                      Divider(height: 16),
                      Text('Luas Alas      = s²'),
                      Text('Luas Permukaan = s² + 2 × s × ap'),
                      Text('Volume         = ⅓ × s² × t'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Painter untuk ilustrasi piramida sederhana
class _PyramidPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.5;

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.blue.shade800;

    final cx = size.width / 2;

    // Titik-titik
    final apex = Offset(cx, 0); // puncak
    final frontLeft = Offset(10, size.height * 0.75); // depan kiri
    final frontRight = Offset(size.width - 10, size.height * 0.75); // depan kanan
    final backLeft = Offset(cx - 30, size.height * 0.55); // belakang kiri
    final backRight = Offset(cx + 30, size.height * 0.55); // belakang kanan

    // Sisi kiri (gelap)
    paint.color = Colors.blue.shade200;
    canvas.drawPath(
      Path()
        ..moveTo(apex.dx, apex.dy)
        ..lineTo(frontLeft.dx, frontLeft.dy)
        ..lineTo(backLeft.dx, backLeft.dy)
        ..close(),
      paint,
    );

    // Sisi kanan (terang)
    paint.color = Colors.blue.shade400;
    canvas.drawPath(
      Path()
        ..moveTo(apex.dx, apex.dy)
        ..lineTo(frontRight.dx, frontRight.dy)
        ..lineTo(backRight.dx, backRight.dy)
        ..close(),
      paint,
    );

    // Sisi depan (paling terang)
    paint.color = Colors.blue.shade300;
    canvas.drawPath(
      Path()
        ..moveTo(apex.dx, apex.dy)
        ..lineTo(frontLeft.dx, frontLeft.dy)
        ..lineTo(frontRight.dx, frontRight.dy)
        ..close(),
      paint,
    );

    // Alas (perspektif jajaran genjang)
    paint.color = Colors.blue.shade100;
    canvas.drawPath(
      Path()
        ..moveTo(frontLeft.dx, frontLeft.dy)
        ..lineTo(backLeft.dx, backLeft.dy)
        ..lineTo(backRight.dx, backRight.dy)
        ..lineTo(frontRight.dx, frontRight.dy)
        ..close(),
      paint,
    );

    // Outline semua sisi
    canvas.drawPath(
      Path()
        ..moveTo(apex.dx, apex.dy)
        ..lineTo(frontLeft.dx, frontLeft.dy)
        ..lineTo(frontRight.dx, frontRight.dy)
        ..lineTo(apex.dx, apex.dy)
        ..lineTo(backLeft.dx, backLeft.dy)
        ..lineTo(frontLeft.dx, frontLeft.dy)
        ..moveTo(backLeft.dx, backLeft.dy)
        ..lineTo(backRight.dx, backRight.dy)
        ..lineTo(frontRight.dx, frontRight.dy)
        ..moveTo(backRight.dx, backRight.dy)
        ..lineTo(apex.dx, apex.dy),
      strokePaint,
    );

    // Garis putus-putus alas belakang
    final dashPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Colors.blue.shade400;

    _drawDashed(canvas, backLeft, backRight, dashPaint);

    // Label s dan t
    final textStyle = TextStyle(
      color: Colors.blue.shade900,
      fontSize: 11,
      fontWeight: FontWeight.bold,
    );
    final tp = TextPainter(textDirection: TextDirection.ltr);

    // label "s" di bawah
    tp.text = TextSpan(text: 's', style: textStyle);
    tp.layout();
    tp.paint(canvas, Offset(cx - 5, size.height * 0.78));

    // label "t" di tengah-kiri
    tp.text = TextSpan(text: 't', style: textStyle);
    tp.layout();
    tp.paint(canvas, Offset(cx + 4, size.height * 0.3));
  }

  void _drawDashed(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashLen = 5.0;
    const gapLen = 3.0;
    final total = (end - start).distance;
    final dir = (end - start) / total;
    double dist = 0;
    while (dist < total) {
      final a = start + dir * dist;
      final b = start + dir * (dist + dashLen).clamp(0, total);
      canvas.drawLine(a, b, paint);
      dist += dashLen + gapLen;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}