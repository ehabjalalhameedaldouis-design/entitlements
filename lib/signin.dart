import 'package:entitlements/data/appwords.dart';
import 'package:entitlements/homepage.dart';
import 'package:entitlements/mywidgets/myappbar.dart';
import 'package:entitlements/mywidgets/mycolors.dart';
import 'package:entitlements/mywidgets/mytextfield.dart';
import 'package:entitlements/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final TextEditingController emailAddress = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const Color shadowDark = Color(0xFF0D0E0F);
    const Color shadowLight = Color(0xFF272A2D);

    return Scaffold(
      appBar: Myappbar(title: "sign_in"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 5),
              Text(
                'YOUR DEBTS IN ONE PLACE',
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
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailAddress.text.trim(),
                      password: password.text.trim(),
                    );
                    if (!context.mounted) return;
                    // Navigate to homepage on successful sign-in
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Homepage()),
                    );
                  } on FirebaseAuthException catch (e) {
                    // Show error message on sign-in failure
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.message ?? 'Sign-in failed')),
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
                      BoxShadow(color: MyColors.darkYellow, blurRadius: 20),
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
                      'sign_in'.toUpperCase(),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'DON\'T HAVE AN ACCOUNT? ',
                    style: TextStyle(color: MyColors.lightBlack, fontSize: 14),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: Text(
                      'Sign Up',
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
}
