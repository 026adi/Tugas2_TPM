import 'package:flutter/material.dart';
import 'package:teori_kelompok/screen/login_page.dart';
import 'package:teori_kelompok/screen/bangun.dart';
import 'package:teori_kelompok/screen/penjumlahan.dart';
import 'package:teori_kelompok/screen/bilangan_page.dart';
import 'package:teori_kelompok/screen/deret.dart';
import 'package:teori_kelompok/screen/stopwatch.dart';
import 'package:teori_kelompok/screen/profile.dart'; // <- import baru

class HomePage extends StatelessWidget {
  final String namaUser;

  const HomePage({super.key, required this.namaUser});

  Widget menuCard(
      BuildContext context, String title, IconData icon, Widget page) {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue.shade100,
              child: Icon(icon, size: 30, color: Colors.blue),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 8),
            Text('Konfirmasi Logout'),
          ],
        ),
        content: const Text('Apakah kamu yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: Column(
        children: [

          /// HEADER DASHBOARD
          Container(
            height: 200,
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade800,
                  Colors.blue.shade400,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),

            child: Column(
              children: [

                /// LOGO + LOGOUT
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Image.asset(
                      "assets/upn.png",
                      width: 45,
                    ),

                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: () => _logout(context),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                /// TEXT WELCOME
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Halo, $namaUser!",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        "Selamat datang di aplikasi kami",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          /// MENU GRID
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,

                children: [

                  menuCard(
                    context,
                    "Luas & Volume Piramida",
                    Icons.architecture,
                    const BangunPage(),
                  ),

                  menuCard(
                    context,
                    "Penjumlahan & Pengurangan",
                    Icons.calculate,
                    const PenjumlahanScreen(),
                  ),

                  menuCard(
                    context,
                    "Cek Bilangan Prima",
                    Icons.tag,
                    BilanganPage(),
                  ),

                  menuCard(
                    context,
                    "Jumlah Total Digit",
                    Icons.add_chart,
                    const DeretScreen(),
                  ),

                  menuCard(
                    context,
                    "Stopwatch",
                    Icons.timer,
                    const StopwatchPage(),
                  ),

                  menuCard(
                    context,
                    "Anggota Kelompok",
                    Icons.group,
                    const ProfilePage(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}