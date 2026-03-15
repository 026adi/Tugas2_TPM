import 'package:flutter/material.dart';
import 'detail_profile.dart';

class Member {
  final String name;
  final String nim;
  final String hobby;
  final String instagram;
  final String imagePath;

  const Member({
    required this.name,
    required this.nim,
    required this.hobby,
    required this.instagram,
    required this.imagePath,
  });
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  final List<Member> members = const [
    Member(
      name: 'Imam Khusain',
      nim: '123230018',
      hobby: 'Olahraga',
      instagram: '@i.khusaiin',
      imagePath: 'assets/imam.jpg',
    ),
    Member(
      name: 'Adi Setya Nur Pradipta',
      nim: '123230026',
      hobby: 'Membaca',
      instagram: '@adi.stya_',
      imagePath: 'assets/adi.jpg',
    ),
    Member(
      name: 'Muh. Syahrial Abidin',
      nim: '123230027',
      hobby: 'Olahraga',
      instagram: '@abidinsyahrial',
      imagePath: 'assets/aril.jpg',
    ),
    Member(
      name: 'Andika Dwi Saktiawan',
      nim: '123230033',
      hobby: 'Fotografi',
      instagram: '@andika.ds',
      imagePath: 'assets/andika.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Anggota Kelompok"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),

        child: GridView.builder(
          itemCount: members.length,

          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 16,
            childAspectRatio: 1,
          ),

          itemBuilder: (context, index) {
            final member = members[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailProfilePage(member: member),
                  ),
                );
              },

              child: MemberCard(member: member),
            );
          },
        ),
      ),
    );
  }
}
class MemberCard extends StatelessWidget {
  final Member member;

  const MemberCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        // FOTO PROFIL
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.asset(
            member.imagePath,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        // LABEL NAMA
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 40,

            decoration: const BoxDecoration(
              color: Color(0xFF53CBF3),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(66, 255, 255, 255),
                  blurRadius: 4,
                  offset: Offset(0, -1),
                ),
              ],
            ),

            child: Row(
              children: [

                Container(
                  width: 14,
                  height: double.infinity,
                  color: const Color(0xFF111FA2),
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    member.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}