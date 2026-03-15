import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entitlements/data/appwords.dart';
import 'package:entitlements/mywidgets/myappbar.dart';
import 'package:entitlements/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final User? user = FirebaseAuth.instance.currentUser;

  bool get _isGoogleUser =>
      user?.providerData.any((p) => p.providerId == 'google.com') ?? false;

  void _showGoogleMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _editName(BuildContext context) async {
    final controller = TextEditingController(text: user?.displayName ?? '');
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(getword(context, 'edit_name')),
        content: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: getword(context, 'Enter_Your_Name'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(getword(context, 'cancel')),
          ),
          TextButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isEmpty) return;
              await user?.updateDisplayName(newName);
              await FirebaseFirestore.instance
                  .collection('users_accounts')
                  .doc(user!.uid)
                  .update({'full_name': newName});
              if (!context.mounted) return;
              Navigator.pop(context);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(getword(context, 'person_updated'))),
              );
            },
            child: Text(getword(context, 'save')),
          ),
        ],
      ),
    );
  }

  Future<void> _changePassword(BuildContext context) async {
    if (_isGoogleUser) {
      _showGoogleMessage(context, getword(context, 'google_managed_password'));
      return;
    }
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(getword(context, 'change_password')),
        content: TextFormField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: getword(context, 'Enter_Your_Password'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(getword(context, 'cancel')),
          ),
          TextButton(
            onPressed: () async {
              final newPassword = controller.text.trim();
              if (newPassword.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(getword(context, 'password_too_short'))),
                );
                return;
              }
              try {
                await user?.updatePassword(newPassword);
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(getword(context, 'password_updated'))),
                );
              } on FirebaseAuthException catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.message ?? '')),
                );
              }
            },
            child: Text(getword(context, 'save')),
          ),
        ],
      ),
    );
  }

  Future<void> _changeEmail(BuildContext context) async {
    if (_isGoogleUser) {
      _showGoogleMessage(context, getword(context, 'google_managed_email'));
      return;
    }
    final controller = TextEditingController(text: user?.email ?? '');
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(getword(context, 'change_email')),
        content: TextFormField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: getword(context, 'Enter_Your_Email'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(getword(context, 'cancel')),
          ),
          TextButton(
            onPressed: () async {
              final newEmail = controller.text.trim();
              if (!newEmail.contains('@')) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(getword(context, 'please_enter_valid_email'))),
                );
                return;
              }
              try {
                await user?.verifyBeforeUpdateEmail(newEmail);
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(getword(context, 'email_verification_sent'))),
                );
              } on FirebaseAuthException catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.message ?? '')),
                );
              }
            },
            child: Text(getword(context, 'save')),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(getword(context, 'delete_account')),
        content: Text(getword(context, 'confirm_delete_account')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(getword(context, 'cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              getword(context, 'delete'),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      final uid = user!.uid;
      final firestore = FirebaseFirestore.instance;
      final userDoc = firestore.collection('users_accounts').doc(uid);

      // 1. احذف كل transactions لكل client
      final clients = await userDoc.collection('My_Clients').get();
      for (final client in clients.docs) {
        final transactions = await client.reference.collection('transactions').get();
        for (final tx in transactions.docs) {
          await tx.reference.delete();
        }
        await client.reference.delete();
      }

      // 2. احذف recent_transactions
      final recentTx = await userDoc.collection('recent_transactions').get();
      for (final tx in recentTx.docs) {
        await tx.reference.delete();
      }

      // 3. احذف document المستخدم نفسه
      await userDoc.delete();

      // 4. احذف حساب Firebase Auth
      await user?.delete();

      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? '')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final error = Theme.of(context).colorScheme.error;

    final createdAt = user?.metadata.creationTime;
    final createdAtText = createdAt != null
        ? '${createdAt.day}/${createdAt.month}/${createdAt.year}'
        : '—';
    final providerText = _isGoogleUser ? 'Google' : getword(context, 'email_address');

    return Scaffold(
      appBar: Myappbar(
        widget: Text(
          getword(context, 'my_account'),
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _InfoCard(icon: Icons.person_outline, label: getword(context, 'full_name'), value: user?.displayName ?? '—'),
          _InfoCard(icon: Icons.email_outlined, label: getword(context, 'email_address'), value: user?.email ?? '—'),
          _InfoCard(icon: Icons.login_rounded, label: getword(context, 'login_method'), value: providerText),
          _InfoCard(icon: Icons.calendar_today_outlined, label: getword(context, 'account_created_at'), value: createdAtText),
          const SizedBox(height: 20),
          _ActionButton(icon: Icons.drive_file_rename_outline, label: getword(context, 'edit_name'), onTap: () => _editName(context)),
          _ActionButton(icon: Icons.lock_outline, label: getword(context, 'change_password'), onTap: () => _changePassword(context)),
          _ActionButton(icon: Icons.alternate_email, label: getword(context, 'change_email'), onTap: () => _changeEmail(context)),
          const SizedBox(height: 20),
          _ActionButton(
            icon: Icons.logout_rounded,
            label: getword(context, 'sign_out'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SignInScreen()),
                (route) => false,
              );
            },
          ),
          const SizedBox(height: 8),
          _ActionButton(
            icon: Icons.delete_forever_rounded,
            label: getword(context, 'delete_account'),
            color: error,
            onTap: () => _deleteAccount(context),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final surface = Theme.of(context).colorScheme.surface;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: onSurface.withValues(alpha: 0.7), fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(color: onSurface, fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final surface = Theme.of(context).colorScheme.surface;
    final btnColor = color ?? primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: btnColor),
        title: Text(
          label,
          style: TextStyle(color: btnColor, fontWeight: FontWeight.w600),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: btnColor.withValues(alpha: 0.6),
        ),
        onTap: onTap,
      ),
    );
  }
}
