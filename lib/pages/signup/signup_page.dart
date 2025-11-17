import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/pages/signin/signin_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image/lobby.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 30,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Column(
                        children: [
                          Image.asset("assets/image/logosmk.jpg", height: 100),
                          SizedBox(height: 10),

                          Text(
                            "SIGN UP",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),

                          SizedBox(height: 20),

                          // NAMA
                          TextField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 20,
                              ),
                              hintText: "Nama",
                              prefixIcon: Icon(Icons.person),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),

                          SizedBox(height: 15),

                          // EMAIL
                          TextField(
                            decoration: InputDecoration(
                              hintText: "Email",
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 20,
                              ),
                              prefixIcon: Icon(Icons.email),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),

                          SizedBox(height: 15),

                          // PASSWORD
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Password",
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 20,
                              ),
                              prefixIcon: Icon(Icons.visibility),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),

                          SizedBox(height: 15),

                          // confirm password
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Confirm Password",
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 20,
                              ),
                              prefixIcon: Icon(Icons.visibility_outlined),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),

                          SizedBox(height: 15),

                          // ROLE DROPDOWN
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              hintText: "Role",
                              prefixIcon: Icon(Icons.badge),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            items: ["Kepala Sekolah", "TU", "Lainnya"]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {},
                          ),

                          SizedBox(height: 20),

                          // BUTTON
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade300,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                "SIGN UP",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          SizedBox(height: 15),

                          // LINK TO LOGIN
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Do you have an account? "),
                              TextButton(
                                onPressed: () {
                                  // Navigasi ke halaman Sign Up
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SigninPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Sign In",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
