import 'package:entitlements/data/appwords.dart';
import 'package:entitlements/homepage.dart';
import 'package:entitlements/mywidgets/myappbar.dart';
import 'package:entitlements/mywidgets/mycolors.dart';
import 'package:entitlements/mywidgets/mytextfield.dart';
import 'package:entitlements/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController emailAddress = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController fullName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const Color shadowDark = Color(0xFF0D0E0F);
    const Color shadowLight = Color(0xFF272A2D);

    return Scaffold(
      appBar: Myappbar(title: "sign_up"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 5),
              Text(
                'SAVE YOUR DEBTS',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: MyColors.darkYellow,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),

              // Inputs
              MyTextField(
                label: 'Full Name',
                iconpre: Icons.person_rounded,
                hintText: 'Johnathan Doe',
                controller: fullName,
              ),
              MyTextField(
                label: 'Email Address',
                iconpre: Icons.email_outlined,
                hintText: 'name@domain.com',
                controller: emailAddress,
              ),
              MyTextField(
                label: 'Secret Key',
                iconpre: Icons.lock_rounded,
                iconsuf: Icons.visibility_off_rounded,
                hintText: '••••••••••••',
                isPassword: true,
                controller: password,
              ),

              const SizedBox(height: 40),

              // Action Button
              GestureDetector(
                onTap: () async {
                  try {
                    await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: emailAddress.text,
                      password: password.text,
                    );
                    if (!context.mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Homepage()),
                    );
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.message ?? 'Sign-up failed')),
                    );
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 60,
                  decoration: BoxDecoration(
                    color: MyColors.lightBlack,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: MyColors.darkYellow,
                        blurRadius: 20,
                      ),
                      BoxShadow(
                        color: shadowDark,
                        offset: const Offset(6, 6),
                        blurRadius: 12,
                      ),
                      BoxShadow(
                        color: shadowLight,
                        offset: const Offset(-6, -6),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'CREATE ACCOUNT',
                      style: const TextStyle(
                        color: MyColors.darkYellow,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
              const Text(
                'OR REGISTER WITH',
                style: TextStyle(
                  color: MyColors.darkYellow,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 25),

              // Social Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialBtn(Icons.g_mobiledata_outlined),
                  const SizedBox(width: 24),
                  _buildSocialBtn(Icons.apple_rounded),
                  const SizedBox(width: 24),
                  _buildSocialBtn(Icons.code_rounded),
                ],
              ),

              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(color: MyColors.lightBlack, fontSize: 14),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignInScreen()),
                      );
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: MyColors.darkYellow,
                        fontSize: 14,
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
    );
  }

  Widget _buildSocialBtn(IconData icon) {
    const Color shadowDark = Color(0xFF0D0E0F);
    const Color shadowLight = Color(0xFF272A2D);

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: MyColors.lightBlack,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(color: shadowDark, offset: Offset(8, 8), blurRadius: 16),
          BoxShadow(color: shadowLight, offset: Offset(-8, -8), blurRadius: 16),
        ],
      ),
      child: Icon(icon, color: Colors.white60, size: 28),
    );
  }
}
