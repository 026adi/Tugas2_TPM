import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Widget memberCard(String nama, String nim, String hobi) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE7E3EA),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              const Text(
                "Nama : ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(nama),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              const Text(
                "NIM  : ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(nim),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              const Text(
                "Hobi : ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(hobi),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.grey.shade200,

    appBar: AppBar(
        title: const Text("Anggota Kelompok"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
    ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            memberCard(
              "Imam Khusain",
              "123230018",
              "Olahraga",
            ),

            memberCard(
              "Adi Setya Nur Pradipta",
              "123230026",
              "Olahraga",
            ),

            memberCard(
              "Muh. Syahrial Abidin",
              "123230027",
              "Olahraga",
            ),

            memberCard(
              "Andika Dwi Saktiwan",
              "123230033",
              "Olahraga",
            ),
          ],
        ),
      ),
    );
  }
}