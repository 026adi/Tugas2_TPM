import 'package:flutter/material.dart';

class BilanganPage extends StatefulWidget {
  const BilanganPage({super.key});

  @override
  State<BilanganPage> createState() => _BilanganPageState();
}

class _BilanganPageState extends State<BilanganPage> {
  final TextEditingController _angkaController = TextEditingController();

  String _hasilGanjilGenap = '';
  String _hasilPrima = '';

  bool isPrima(int n) {
    if (n <= 1) return false;

    for (int i = 2; i * i <= n; i++) {
      if (n % i == 0) {
        return false;
      }
    }

    return true;
  }

  void _cekBilangan() {
    int? angka = int.tryParse(_angkaController.text);

    if (angka != null) {
      setState(() {
        _hasilGanjilGenap = (angka % 2 == 0) ? 'Genap' : 'Ganjil';

        _hasilPrima =
            isPrima(angka) ? 'Bilangan Prima' : 'Bukan Bilangan Prima';
      });
    } else {
      setState(() {
        _hasilGanjilGenap = 'Input tidak valid';
        _hasilPrima = '-';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text(
          'Cek Bilangan',
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

                    TextField(
                      controller: _angkaController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,

                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),

                      decoration: InputDecoration(
                        labelText: 'Masukkan Sebuah Angka',

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
                        onPressed: _cekBilangan,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        child: const Text(
                          'Cek Angka',
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
            if (_hasilGanjilGenap.isNotEmpty)
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
                        'Hasil Pengecekan',
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

                      /// GANJIL GENAP
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          const Text(
                            'Jenis Bilangan:',
                            style: TextStyle(fontSize: 16),
                          ),

                          Text(
                            _hasilGanjilGenap,

                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,

                              color: _hasilGanjilGenap == 'Input tidak valid'
                                  ? Colors.red
                                  : Colors.blue[900],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// PRIMA
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          const Text(
                            'Status Prima:',
                            style: TextStyle(fontSize: 16),
                          ),

                          Text(
                            _hasilPrima,

                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,

                              color: _hasilPrima == 'Bilangan Prima'
                                  ? Colors.green[700]
                                  : Colors.orange[800],
                            ),
                          ),
                        ],
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