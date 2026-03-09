import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entitlements/data/appwords.dart';
import 'package:entitlements/myclients.dart';
import 'package:entitlements/persondetailes.dart';
import 'package:entitlements/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:entitlements/mywidgets/mycolors.dart';
import 'package:image_picker/image_picker.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'users_accounts',
  );
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  final ImagePicker _picker = ImagePicker();
  Uint8List? _profileImageBytes;
  int _tabIndex = 2;

  Future<void> _pickProfileImage() async {
    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedImage == null) return;
      final Uint8List bytes = await pickedImage.readAsBytes();
      if (!mounted) return;
      setState(() {
        _profileImageBytes = bytes;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(getword(context, 'failed_pick_image'))),
      );
    }
  }

  void _goToTab(int index) {
    setState(() {
      _tabIndex = index;
    });
  }

  void _openAddTransactionSelector() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _AddTransactionClientSelector(
          uid: uid,
          users: users,
        ),
      ),
    );
  }

  void _showLatestNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(getword(context, 'no_new_notifications') )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = <Widget>[
      const Setting(),
      const MyClients(),
      _DashboardBody(
        stream: users.doc(uid).collection('My_Clients').snapshots(),
        uid: uid,
        profileImageBytes: _profileImageBytes,
        onTapProfileImage: _pickProfileImage,
        onShowNotifications: _showLatestNotifications,
        onOpenClients: () => _goToTab(1),
        onOpenAddTransaction: _openAddTransactionSelector,
      ),
      _AnalysisPlaceholder(onClose: () => _goToTab(2)),
    ];

    return Scaffold(
      body: IndexedStack(index: _tabIndex, children: tabs),
      bottomNavigationBar: _HomeBottomBar(
        currentIndex: _tabIndex,
        onTap: _goToTab,
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({
    required this.stream,
    required this.uid,
    required this.profileImageBytes,
    required this.onTapProfileImage,
    required this.onShowNotifications,
    required this.onOpenClients,
    required this.onOpenAddTransaction,
  });

  final Stream<QuerySnapshot<Object?>> stream;
  final String uid;
  final Uint8List? profileImageBytes;
  final VoidCallback onTapProfileImage;
  final VoidCallback onShowNotifications;
  final VoidCallback onOpenClients;
  final VoidCallback onOpenAddTransaction;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Object?>>(
      stream: stream,
      builder: (context, snapshot) {
        final docs = snapshot.hasData
            ? snapshot.data!.docs
            : <QueryDocumentSnapshot<Object?>>[];

        return SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xF0052217),
                  Color(0xE60A2F21),
                  Color(0xE00E3827),
                ],
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 120),
              children: [
                _GreetingHeader(
                  profileImageBytes: profileImageBytes,
                  onTapProfileImage: onTapProfileImage,
                  onShowNotifications: onShowNotifications,
                ),
                const SizedBox(height: 14),
                _HeroBalanceCard(docs: docs),
                const SizedBox(height: 12),
                _QuickActionsRow(
                  onOpenClients: onOpenClients,
                  onOpenAddTransaction: onOpenAddTransaction,
                ),
                const SizedBox(height: 12),
                _RecentTransactionsCard(
                  uid: uid,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader({
    required this.profileImageBytes,
    required this.onTapProfileImage,
    required this.onShowNotifications,
  });

  final Uint8List? profileImageBytes;
  final VoidCallback onTapProfileImage;
  final VoidCallback onShowNotifications;

  String _greeting(BuildContext context) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return getword(context, 'good_morning');
    }
    return getword(context, 'good_evening');
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = (user?.displayName ?? '').trim();
    final fallbackName = user?.email ?? 'User';
    final name = displayName.isNotEmpty ? displayName : fallbackName;

    ImageProvider<Object>? imageProvider;
    if (profileImageBytes != null) {
      imageProvider = MemoryImage(profileImageBytes!);
    } else if ((user?.photoURL ?? '').isNotEmpty) {
      imageProvider = NetworkImage(user!.photoURL!);
    }

    return Row(
      children: [
        InkWell(
          onTap: onTapProfileImage,
          borderRadius: BorderRadius.circular(22),
          child: CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFFCBFFE4),
            backgroundImage: imageProvider,
            child: imageProvider == null
                ? const Icon(Icons.person, color: MyColors.lightBlack)
                : null,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greeting(context),
                style: TextStyle(
                  color: MyColors.title.withValues(alpha: 0.85),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onShowNotifications,
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: MyColors.darkYellow,
          ),
        ),
      ],
    );
  }
}

class _HeroBalanceCard extends StatelessWidget {
  const _HeroBalanceCard({required this.docs});
  final List<QueryDocumentSnapshot<Object?>> docs;

  @override
  Widget build(BuildContext context) {
    double total = 0;
    int receivablesCount = 0;
    int payablesCount = 0;
    for (final person in docs) {
      final amount = (person['total_amount'] as num).toDouble();
      total += amount;
      if (amount > 0) receivablesCount++;
      if (amount < 0) payablesCount++;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xCC3DA778), Color(0xB32C8D64)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getword(context, 'allmoney'),
            style: const TextStyle(
              color: Color(0xFFE9FFF3),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            total.toStringAsFixed(2),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _StatChip(
                icon: Icons.arrow_upward,
                text: '${getword(context, 'receivables')}: $receivablesCount',
                color: const Color(0xFFCAFFE2),
              ),
              const SizedBox(width: 8),
              _StatChip(
                icon: Icons.arrow_downward,
                text: '${getword(context, 'payables')}: $payablesCount',
                color: const Color(0xFFFFD3D3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow({
    required this.onOpenClients,
    required this.onOpenAddTransaction,
  });

  final VoidCallback onOpenClients;
  final VoidCallback onOpenAddTransaction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            label: getword(context, 'add_a_new_person'),
            icon: Icons.person_add_alt_1,
            onTap: onOpenClients,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionCard(
            label: getword(context, 'add_a_new_transaction'),
            icon: Icons.receipt_long_rounded,
            onTap: onOpenAddTransaction,
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 82,
        decoration: BoxDecoration(
          color: const Color(0x991F6E4F),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFCEFFE5)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFE9FFF3),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentTransactionsCard extends StatelessWidget {
  const _RecentTransactionsCard({
    required this.uid,
  });

  final String uid;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0x991F6E4F),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users_accounts')
            .doc(uid)
            .collection('recent_transactions')
            .orderBy('time', descending: true)
            .limit(6)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                getword(context, 'no_transactions_yet'),
                style: const TextStyle(color: Color(0xFFE9FFF3)),
              ),
            );
          }

          final currentUserTransactions = snapshot.data?.docs ?? const [];
          if (currentUserTransactions.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                getword(context, 'no_transactions_yet'),
                style: const TextStyle(color: Color(0xFFE9FFF3)),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.receipt_long,
                    color: Color(0xFFCEFFE5),
                  ),
                  title: Text(
                    getword(context, 'recent_transactions'),
                    style: const TextStyle(
                      color: Color(0xFFE9FFF3),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...currentUserTransactions.map((txDoc) {
                  final tx = txDoc.data();
                  final bool isDebt = tx['isdebt'] == true;
                  final double amount = (tx['amount'] as num?)?.toDouble() ?? 0;
                  final Timestamp? ts = tx['time'] as Timestamp?;
                  final DateTime? time = ts?.toDate();
                  final String description =
                      (tx['description'] ?? '').toString();

                  final Color color = isDebt
                      ? const Color(0xFFFFD6D6)
                      : const Color(0xFFCEFFE5);
                  final String dateText = time == null
                      ? ''
                      : '${time.day}/${time.month}/${time.year}';

                  return ListTile(
                    dense: true,
                    leading: Icon(
                      isDebt ? Icons.arrow_downward : Icons.arrow_upward,
                      color: color,
                    ),
                    title: Text(
                      description,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      dateText,
                      style: TextStyle(color: color.withValues(alpha: 0.8)),
                    ),
                    trailing: Text(
                      '${isDebt ? '-' : '+'}${amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: color, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeBottomBar extends StatelessWidget {
  const _HomeBottomBar({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xE60A2A1E),
        border: Border(
          top: BorderSide(
            color: Color(0x991F6E4F),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.only(bottom: 8, top: 6),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BottomItem(
              label: getword(context, 'settings'),
              icon: Icons.settings,
              selected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _BottomItem(
              label: getword(context, 'clients'),
              icon: Icons.groups_rounded,
              selected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            _BottomItem(
              label: getword(context, 'entitlements'),
              icon: Icons.home_rounded,
              selected: currentIndex == 2,
              onTap: () => onTap(2),
            ),
            _BottomItem(
              label: 'التحليل',
              icon: Icons.auto_graph_rounded,
              selected: currentIndex == 3,
              onTap: () => onTap(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  const _BottomItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.selected = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final Color color = selected
        ? const Color(0xFF19E26A)
        : const Color(0xFFB6E8CF);

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddTransactionClientSelector extends StatelessWidget {
  const _AddTransactionClientSelector({
    required this.uid,
    required this.users,
  });

  final String uid;
  final CollectionReference users;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: AppBar(
        backgroundColor: MyColors.background,
        title: Text(
          getword(context, 'add_a_new_transaction'),
          style: const TextStyle(color: MyColors.title),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Object?>>(
        stream: users
            .doc(uid)
            .collection('My_Clients')
            .orderBy('full_name')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                getword(context, 'no_clients_found'),
                style: const TextStyle(color: MyColors.title),
              ),
            );
          }

          final clients = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: clients.length,
            itemBuilder: (context, index) {
              final client = clients[index];
              return Card(
                color: const Color(0xFF1F6E4F),
                child: ListTile(
                  leading: const Icon(Icons.person, color: Color(0xFFCEFFE5)),
                  title: Text(
                    client['full_name'].toString(),
                    style: const TextStyle(color: Color(0xFFE9FFF3)),
                  ),
                  subtitle: Text(
                    '${client['total_amount']}',
                    style: const TextStyle(color: Color(0xFFB6E8CF)),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Persondetailes(
                          person: users
                              .doc(uid)
                              .collection('My_Clients')
                              .doc(client.id),
                          name: client['full_name'].toString(),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _AnalysisPlaceholder extends StatelessWidget {
  const _AnalysisPlaceholder({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: const Color(0x991F6E4F),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.auto_graph_rounded,
                size: 42,
                color: MyColors.darkYellow,
              ),
              const SizedBox(height: 10),
              const Text(
                'قسم التحليل قيد التطوير',
                style: TextStyle(
                  color: Color(0xFFE9FFF3),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: onClose,
                child: const Text('العودة للرئيسية'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
