import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:entitlements/data/appwords.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConnectivityWrapper extends StatefulWidget {
  const ConnectivityWrapper({super.key, required this.child});
  final Widget child;

  // للوصول لحالة الاتصال من أي مكان
  static bool isOffline = false;
  static bool _offlineDialogShowing = false;

  static Future<void> showOfflineDialog(BuildContext context) async {
    if (_offlineDialogShowing) return;
    _offlineDialogShowing = true;
    try {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(getword(dialogContext, 'no_internet')),
            content: Text(getword(dialogContext, 'check_connection')),
            actions: [
              TextButton(
                onPressed: () {
                  if (!ConnectivityWrapper.isOffline) {
                    Navigator.pop(dialogContext);
                  }
                },
                child: Text(getword(dialogContext, 'retry')),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text(getword(dialogContext, 'exit_app')),
              ),
            ],
          );
        },
      );
    } finally {
      _offlineDialogShowing = false;
    }
  }

  static void hideOfflineDialog(BuildContext context) {
    if (_offlineDialogShowing) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper>
    with WidgetsBindingObserver {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkInitialConnectivity();
    _subscription = Connectivity().onConnectivityChanged.listen((results) async {
      await _updateConnectivityStatus(results);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkInitialConnectivity();
    }
  }

  Future<void> _checkInitialConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    await _updateConnectivityStatus(results);
  }

  Future<void> _updateConnectivityStatus(List<ConnectivityResult> results) async {
    if (_checking) return;
    _checking = true;
    try {
      final hasNetwork = results.any((r) => r != ConnectivityResult.none);
      bool offline = true;
      if (hasNetwork) {
        offline = !(await _hasInternet());
      }
      if (!mounted) return;
      if (offline != ConnectivityWrapper.isOffline) {
        setState(() => ConnectivityWrapper.isOffline = offline);
      }
      if (offline) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          ConnectivityWrapper.showOfflineDialog(context);
        });
      } else {
        ConnectivityWrapper.hideOfflineDialog(context);
      }
    } finally {
      _checking = false;
    }
  }

  Future<bool> _hasInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ConnectivityWrapper.isOffline && !ConnectivityWrapper._offlineDialogShowing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ConnectivityWrapper.showOfflineDialog(context);
      });
    }
    return widget.child;
  }
}
