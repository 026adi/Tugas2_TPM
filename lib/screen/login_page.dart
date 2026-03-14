import 'package:flutter/material.dart';
import 'package:teori_kelompok/model/username.dart';
import 'package:teori_kelompok/screen/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  void _login() async {

    final inputNama = _namaController.text.trim();
    final inputPassword = _passwordController.text.trim();

    if (inputNama.isEmpty || inputPassword.isEmpty) {
      setState(() {
        _errorMessage = "Username dan password tidak boleh kosong";
      });
      return;
    }

    final User? matchedUser = dataUser.cast<User?>().firstWhere(
      (user) =>
          user!.nama.toLowerCase() == inputNama.toLowerCase() &&
          user.password == inputPassword,
      orElse: () => null,
    );

    if (matchedUser != null) {

      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      await Future.delayed(const Duration(milliseconds: 1200));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(namaUser: matchedUser.nama),
          ),
        );
      }

    } else {
      setState(() {
        _errorMessage = "Username atau password salah";
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        height: MediaQuery.of(context).size.height,

        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade600,
              Colors.blue.shade300,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(

          child: SingleChildScrollView(

            child: Column(
              children: [

                const SizedBox(height: 60),

                /// LOGO
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.2),
                      )
                    ],
                  ),
                  child: Image.asset(
                    "assets/upn.png",
                    width: 90,
                  ),
                ),

                const SizedBox(height: 40),

                /// CARD LOGIN
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 15,
                        color: Colors.black.withOpacity(0.15),
                      )
                    ],
                  ),

                  child: Column(
                    children: [

                      const Text(
                        "Selamat Datang",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        "Silakan masuk untuk melanjutkan",
                        style: TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 30),

                      /// USERNAME
                      TextField(
                        controller: _namaController,
                        decoration: InputDecoration(

                          hintText: "Username",

                          prefixIcon:
                              const Icon(Icons.person, color: Colors.red),

                          filled: true,
                          fillColor: const Color(0xFFF5D9D9),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// PASSWORD
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,

                        decoration: InputDecoration(
                          hintText: "Password",

                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.red),

                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),

                          filled: true,
                          fillColor: const Color(0xFFF5D9D9),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      if (_errorMessage != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        )
                      ],

                      const SizedBox(height: 24),

                      /// BUTTON LOGIN
                      SizedBox(
                        width: double.infinity,
                        height: 55,

                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.blue.shade300,
                            disabledForegroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),

                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "MASUK",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}