import 'package:entitlements/homepage.dart';
import 'package:entitlements/data/appwords.dart';
import 'package:entitlements/mywidgets/myappbar.dart';
import 'package:entitlements/mywidgets/mycolors.dart';
import 'package:entitlements/mywidgets/mytextfield.dart';
import 'package:entitlements/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailAddress = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController fullName = TextEditingController();

  @override
  void dispose() {
    emailAddress.dispose();
    password.dispose();
    fullName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    const Color shadowDark = Color(0xFF0D0E0F);
    const Color shadowLight = Color(0xFF272A2D);

    return Scaffold(
      appBar: Myappbar(widget: Text(
          getword(context,"sign_up"),
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 5),
              Text(
                getword(context, 'signup_tagline'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: MyColors.darkYellow,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),

              MyTextField(
                label: getword(context, 'full_name'),
                iconpre: Icons.person_rounded,
                hintText: getword(context, 'Enter_Your_Name'),
                controller: fullName,
              ),
              MyTextField(
                label: getword(context, 'email_address'),
                iconpre: Icons.email_outlined,
                hintText: getword(context, 'Enter_Your_Email'),
                controller: emailAddress,
              ),
              MyTextField(
                label: getword(context, 'secret_key'),
                iconpre: Icons.lock_rounded,
                iconsuf: Icons.visibility_off_rounded,
                hintText: getword(context, 'Enter_Your_Password'),
                isPassword: true,
                controller: password,
              ),

              const SizedBox(height: 40),

              GestureDetector(
                onTap: () async {
                  final String fullNameValue = fullName.text.trim();
                  final String emailValue = emailAddress.text.trim();
                  final String passwordValue = password.text.trim();
                  if (fullNameValue.isEmpty) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(getword(context, 'please_enter_full_name')),
                      ),
                    );
                    return;
                  }
                  if (emailValue.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(getword(context, 'please_enter_email'))),
                    );
                    return;
                  }
                  if (!emailValue.contains('@')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(getword(context, 'please_enter_valid_email')),
                      ),
                    );
                    return;
                  }
                  if (passwordValue.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(getword(context, 'please_enter_password')),
                      ),
                    );
                    return;
                  }
                  if (passwordValue.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(getword(context, 'password_too_short')),
                      ),
                    );
                    return;
                  }
                  try {
                    final creds = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                          email: emailValue,
                          password: passwordValue,
                        );
                    if (!context.mounted) return;

                    final user =
                        FirebaseAuth.instance.currentUser ?? creds.user;

                    if (user != null) {
                      await user.updateDisplayName(fullNameValue);
                      await FirebaseFirestore.instance
                          .collection('users_accounts')
                          .doc(user.uid)
                          .set({
                            'email': user.email,
                            'full_name': fullNameValue,
                            'created_at': FieldValue.serverTimestamp(),
                            'last_sign_in': FieldValue.serverTimestamp(),
                          }, SetOptions(merge: true));
                    }

                    if (user != null && !user.emailVerified) {
                      await user.sendEmailVerification();
                      await user.reload();
                    }

                    final reloadedUser = FirebaseAuth.instance.currentUser;

                    if (reloadedUser != null && reloadedUser.emailVerified) {
                      if (!context.mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Homepage()),
                      );
                    } else {
                      await FirebaseAuth.instance.signOut();
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(getword(context, 'verify_before_signin'))),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SignInScreen()),
                      );
                    }
                  } on FirebaseAuthException catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          e.message ?? getword(context, 'sign_up_failed'),
                        ),
                      ),
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
                      getword(context, 'create_account').toUpperCase(),
                      style: TextStyle(
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

              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getword(context, 'already_have_account'),
                    style: const TextStyle(color: MyColors.lightBlack, fontSize: 14),
                    textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SignInScreen(),
                      ));
                    },
                    child: Text(
                      getword(context, 'sign_in'),
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
