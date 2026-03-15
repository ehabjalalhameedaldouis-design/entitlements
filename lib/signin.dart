import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entitlements/data/appwords.dart';
import 'package:entitlements/homepage.dart';
import 'package:entitlements/mywidgets/myappbar.dart';
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

  @override
  void dispose() {
    emailAddress.dispose();
    password.dispose();
    super.dispose();
  }

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount account = await GoogleSignIn.instance
          .authenticate();
      final GoogleSignInAuthentication authentication = account.authentication;
      final GoogleSignInClientAuthorization clientAuth = await account
          .authorizationClient
          .authorizeScopes(<String>['email', 'profile', 'openid']);

      final String? idToken = authentication.idToken;
      final String? accessToken = clientAuth.accessToken;

      if (idToken == null && accessToken == null) {
        if (!context.mounted) return null;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(getword(context, 'sign_in_failed'))),
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
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final primary = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final surface = Theme.of(context).colorScheme.surface;
    final shadowDark = Colors.black.withValues(alpha: 0.6);
    final shadowLight = surface.withValues(alpha: 0.5);

    return Scaffold(
      appBar: Myappbar(
        widget: Text(
          getword(context, "sign_in"),
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 5),
              Text(
                getword(context, 'signin_tagline'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
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
              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () async {
                    if (emailAddress.text.trim().isEmpty) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(getword(context, 'please_enter_email')),
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
                        SnackBar(
                          content: Text(getword(context, 'failed_send_reset')),
                        ),
                      );
                      return;
                    }
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(getword(context, 'password_reset_sent')),
                      ),
                    );
                  },
                  child: Text(
                    getword(context, 'forgot_password'),
                    style: TextStyle(color: onSurface, fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  final email = emailAddress.text.trim();
                  final pass = password.text.trim();
                  if (email.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(getword(context, 'please_enter_email')),
                      ),
                    );
                    return;
                  }
                  if (!email.contains('@')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          getword(context, 'please_enter_valid_email'),
                        ),
                      ),
                    );
                    return;
                  }
                  if (pass.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          getword(context, 'please_enter_password'),
                        ),
                      ),
                    );
                    return;
                  }
                  try {
                    final UserCredential creds = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                          email: email,
                          password: pass,
                        );
                    if (!context.mounted) return;
                    await FirebaseAuth.instance.currentUser?.reload();
                    final user = FirebaseAuth.instance.currentUser;

                    if (user != null && user.emailVerified) {
                      final Map<String, dynamic> userData = <String, dynamic>{
                        'email': user.email,
                        'last_sign_in': FieldValue.serverTimestamp(),
                      };
                      final String displayName = user.displayName?.trim() ?? '';
                      if (displayName.isNotEmpty) {
                        userData['full_name'] = displayName;
                      }
                      if (creds.additionalUserInfo?.isNewUser ?? false) {
                        userData['created_at'] = FieldValue.serverTimestamp();
                      }
                      await FirebaseFirestore.instance
                          .collection('users_accounts')
                          .doc(user.uid)
                          .set(userData, SetOptions(merge: true));

                      if (!context.mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Homepage()),
                      );
                    } else {
                      await FirebaseAuth.instance.signOut();
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            getword(context, 'verify_before_signin'),
                          ),
                        ),
                      );
                      await user?.sendEmailVerification();
                    }
                  } on FirebaseAuthException catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          e.message ?? getword(context, 'sign_in_failed'),
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 60,
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(color: primary, blurRadius: 20),
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
                      getword(context, 'sign_in').toUpperCase(),
                      style: TextStyle(
                        color: primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () async {
                  try {
                    final cred = await signInWithGoogle(context);
                    if (cred == null) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(getword(context, 'sign_in_failed')),
                        ),
                      );
                      return;
                    }
                    if (cred.user != null) {
                      final Map<String, dynamic> googleUserData =
                          <String, dynamic>{
                            'email': cred.user!.email,
                            'last_sign_in': FieldValue.serverTimestamp(),
                          };
                      final String googleDisplayName =
                          cred.user!.displayName?.trim() ?? '';
                      if (googleDisplayName.isNotEmpty) {
                        googleUserData['full_name'] = googleDisplayName;
                      }
                      await FirebaseFirestore.instance
                          .collection('users_accounts')
                          .doc(cred.user!.uid)
                          .set(googleUserData, SetOptions(merge: true));
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
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 60,
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(color: primary, blurRadius: 20),
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
                      getword(context, 'google_sign_in'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getword(context, 'dont_have_account'),
                    style: TextStyle(color: onSurface, fontSize: 14),
                    textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: Text(
                      getword(context, 'sign_up'),
                      style: TextStyle(
                        color: primary,
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
