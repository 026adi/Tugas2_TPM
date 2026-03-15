import 'package:flutter/material.dart';
import 'profile.dart';

class DetailProfilePage extends StatelessWidget {
  final Member member;

  const DetailProfilePage({super.key, required this.member});

  @override
  Widget build(BuildContext context) {

    Widget buildPhoto() {
      if (member.imagePath.isEmpty) {
        return Container(
          width: 150,
          height: 150,

          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),

          child: const Icon(
            Icons.person,
            size: 70,
            color: Colors.white,
          ),
        );
      }

      return ClipRRect(
        borderRadius: BorderRadius.circular(12),

        child: Image.asset(
          member.imagePath,
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      appBar: AppBar(
        title: const Text("Detail Anggota"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            const SizedBox(height: 10),

            buildPhoto(),

            const SizedBox(height: 12),

            Text(
              member.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: const Color(0xFFD6E3EC),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              child: Column(
                children: [

                  InfoRow(label: "NIM", value: member.nim),

                  const SizedBox(height: 10),

                  InfoRow(label: "Hobi", value: member.hobby),

                  const SizedBox(height: 10),

                  InfoRow(label: "Instagram", value: member.instagram),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const Text(":"),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}