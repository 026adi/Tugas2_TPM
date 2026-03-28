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
    if (val == val.truncateToDouble()) {
      return val.toStringAsFixed(0);
    }
    return val.toStringAsFixed(4).replaceAll(RegExp(r'0+$'), '');
  }

  Widget _hasilCard({
    required IconData icon,
    required String label,
    required String rumus,
    required double nilai,
    required String satuan,
  }) {
    return Card(
      color: Colors.blue[50],
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54)),
                  Text(rumus,
                      style: const TextStyle(
                          fontSize: 12, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
            Text(
              '${_format(nilai)} $satuan',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
          ],
        ),
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
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text(
          'Luas & Volume Piramida',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            /// ICON
            const Icon(
              Icons.architecture,
              size: 60,
              color: Colors.blue,
            ),

            const SizedBox(height: 10),

            const Center(
              child: Text(
                'Piramida Persegi',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// CARD INPUT
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      'Masukkan Ukuran Piramida',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: _alasController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                      ],
                      decoration: InputDecoration(
                        labelText: 'Panjang Alas (s)',
                        hintText: 'Contoh: 6',
                        prefixIcon: const Icon(Icons.square_outlined),
                        suffixText: 'cm',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    TextField(
                      controller: _tinggiController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                      ],
                      decoration: InputDecoration(
                        labelText: 'Tinggi Piramida (t)',
                        hintText: 'Contoh: 4',
                        prefixIcon: const Icon(Icons.height),
                        suffixText: 'cm',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    if (_errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _errorMessage!,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ],

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _reset,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reset'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: _hitung,
                            icon: const Icon(Icons.calculate),
                            label: const Text('Hitung'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            if (_luasAlas != null) ...[
              const SizedBox(height: 25),

              const Text(
                "Hasil Perhitungan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              _hasilCard(
                icon: Icons.grid_4x4,
                label: 'Luas Alas',
                rumus: 'L.alas = s²',
                nilai: _luasAlas!,
                satuan: 'cm²',
              ),

              _hasilCard(
                icon: Icons.dashboard_outlined,
                label: 'Luas Permukaan',
                rumus: 'L.perm = s² + 2s√((s/2)² + t²)',
                nilai: _luasPermukaan!,
                satuan: 'cm²',
              ),

              _hasilCard(
                icon: Icons.change_history,
                label: 'Volume',
                rumus: 'V = ⅓ × s² × t',
                nilai: _volume!,
                satuan: 'cm³',
              ),
            ],

            const SizedBox(height: 16),

            /// RUMUS
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
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade100),
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