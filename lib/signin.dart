import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entitlements/homepage.dart';
import 'package:entitlements/mywidgets/myappbar.dart';
import 'package:entitlements/mywidgets/mycolors.dart';
import 'package:entitlements/mywidgets/mytextfield.dart';
import 'package:entitlements/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailAddress = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount account = await GoogleSignIn.instance
          .authenticate();

      final GoogleSignInAuthentication authentication = account.authentication;
      final GoogleSignInClientAuthorization? clientAuth = await account
          .authorizationClient
          .authorizationForScopes(<String>['email', 'profile', 'openid']);

      final String? idToken = authentication.idToken;
      final String? accessToken = clientAuth?.accessToken;

      if (idToken == null && accessToken == null) {
        if (!context.mounted) return null;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to obtain authentication tokens.'),
          ),
        );
        return null;
      }

      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      if (!context.mounted) return null;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
      return null;
    }
  }

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

              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () async {
                    if (emailAddress.text.trim().isEmpty) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter your email address.'),
                        ),
                      );
                      return;
                    }
                    try {
                      await FirebaseAuth.instance.sendPasswordResetEmail(
                        email: emailAddress.text.trim(),
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to send password reset email.'),
                        ),
                      );
                      return;
                    }
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Password reset email sent.Please check your inbox and spam folder.\n If you don\'t receive the email within a few minutes, ckeck your email address and try again.',
                        ),
                      ),
                    );
                  },

                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: MyColors.lightBlack, fontSize: 12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () async {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailAddress.text.trim(),
                      password: password.text.trim(),
                    );
                    if (!context.mounted) return;
                    await FirebaseAuth.instance.currentUser?.reload();
                    final user = FirebaseAuth.instance.currentUser;

                    if (user != null && user.emailVerified) {
                      await FirebaseFirestore.instance
                          .collection('users_accounts')
                          .doc(user.uid)
                          .set({
                            'email': user.email,
                            'last_sign_in': DateTime.now(),
                          }, SetOptions(merge: true));

                      if (!context.mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Homepage()),
                      );
                    } else {
                      await FirebaseAuth.instance.signOut();
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please verify your email before signing in. Verification email sent.',
                          ),
                        ),
                      );
                      await user?.sendEmailVerification();
                    }
                  } on FirebaseAuthException catch (e) {
                    if (!context.mounted) return;
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
                  _buildSocialBtn(
                    context,
                    Icons.g_mobiledata_outlined,
                    child: const Icon(
                      Icons.g_mobiledata_outlined,
                      color: MyColors.darkYellow,
                      size: 28,
                    ),
                    ontap: () async {
                      try {
                        final cred = await signInWithGoogle(context);
                        if (cred == null) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Google sign-in cancelled'),
                            ),
                          );
                          return;
                        }
                        if (cred.user != null) {
                          await FirebaseFirestore.instance
                              .collection('users_accounts')
                              .doc(cred.user!.uid)
                              .set({
                                'email': cred.user!.email,
                                'last_sign_in': DateTime.now(),
                              }, SetOptions(merge: true));
                        }
                        if (!context.mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Homepage()),
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    },
                  ),
                  const SizedBox(width: 24),
                  _buildSocialBtn(context, Icons.apple_rounded),
                  const SizedBox(width: 24),
                  _buildSocialBtn(context, Icons.code_rounded),
                ],
              ),
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

  Widget _buildSocialBtn(
    BuildContext context,
    IconData icon, {
    VoidCallback? ontap,
    Widget? child,
  }) {
    const Color shadowDark = Color(0xFF0D0E0F);
    const Color shadowLight = Color(0xFF272A2D);

    return InkWell(
      onTap: ontap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: MyColors.lightBlack,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(color: shadowDark, offset: Offset(8, 8), blurRadius: 16),
            BoxShadow(
              color: shadowLight,
              offset: Offset(-8, -8),
              blurRadius: 16,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
