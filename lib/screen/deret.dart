import 'package:flutter/material.dart';

class DeretScreen extends StatefulWidget {
  const DeretScreen({super.key});

  @override
  State<DeretScreen> createState() => _DeretScreenState();
}

class _DeretScreenState extends State<DeretScreen> {
  final TextEditingController _inputController = TextEditingController();

  String _hasilRincian = "";
  String _totalJumlah = "";

  void _hitungTotal() {
    String input = _inputController.text.trim();

    if (input.isEmpty) {
      setState(() {
        _hasilRincian = "";
        _totalJumlah = "Input kosong!";
      });
      return;
    }

    // pisah berdasarkan koma
    List<String> angkaList = input.split(',');

    int total = 0;
    List<String> rincian = [];

    for (String angka in angkaList) {
      angka = angka.trim(); // hilangkan spasi

      if (angka.isEmpty || int.tryParse(angka) == null) {
        setState(() {
          _hasilRincian = "";
          _totalJumlah =
              "Format salah! Gunakan angka dipisahkan koma.\nContoh: 8,99,100";
        });
        return;
      }

      int nilai = int.parse(angka);
      total += nilai;
      rincian.add(angka);
    }

    setState(() {
      _hasilRincian = rincian.join(' + ');
      _totalJumlah = total.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text(
          'Jumlah Deret Angka',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            /// CARD INPUT
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [

                    const Icon(
                      Icons.calculate,
                      size: 60,
                      color: Colors.blue,
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Masukkan angka dipisahkan dengan koma.\nContoh: 8,99,100',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: _inputController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,

                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),

                      decoration: InputDecoration(
                        labelText: 'Masukkan Deret Angka',
                        hintText: 'Contoh: 8,99,100',

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 50,

                      child: ElevatedButton(
                        onPressed: _hitungTotal,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        child: const Text(
                          'Hitung Total',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// CARD HASIL
            if (_totalJumlah.isNotEmpty)
              Card(
                color: Colors.blue[50],
                elevation: 2,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    children: [

                      Text(
                        'Hasil Perhitungan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),

                      Divider(
                        color: Colors.blue[200],
                        thickness: 1.5,
                      ),

                      const SizedBox(height: 10),

                      if (_hasilRincian.isNotEmpty)
                        Text(
                          '$_hasilRincian\n= $_totalJumlah',
                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else
                        Text(
                          _totalJumlah,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}