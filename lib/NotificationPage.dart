
import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String? _deviceToken;
  bool _permissionGranted = false;
  String? _serverMessage;
  static const String _baseUrl = "http://epass.technosysservicesdemos.com/";
  static const String _registerPath = "Token/Register";
  static const String _verifyPath   = "Auth/VerifyToken";
  StreamSubscription<RemoteMessage>? _fgSub;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _fgSub?.cancel();
    // remove any visible banner when leaving the page
    final m = ScaffoldMessenger.maybeOf(context);
    m?.hideCurrentMaterialBanner();
    super.dispose();
  }

  Future<void> _init() async {
    final settings = await _messaging.requestPermission(alert: true, badge: true, sound: true);
    if (!mounted) return;

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      setState(() => _permissionGranted = true);

      _deviceToken = await _messaging.getToken();
      setState(() {}); // refresh token text

      if (_deviceToken != null) {
        await _registerToken(_deviceToken!);
        await _verifyTokenViaFirebaseAuth(_deviceToken!, "technosysservice78@gmail.com", "User@#1234");
      }

      //Page-scoped foreground listener: show an in-app banner with Accept/Reject
      _bindForegroundOnThisPage();
    } else {
      setState(() => _permissionGranted = false);
    }
  }

  void _bindForegroundOnThisPage() {
    _fgSub?.cancel();
    _fgSub = FirebaseMessaging.onMessage.listen((RemoteMessage m) {
      if (!mounted) return;
      //_showInAppBanner(m);
      _showInAppDialog(m);
    });
  }



  // If you prefer a modal dialog instead of banner, call this:
  Future<void> _showInAppDialog(RemoteMessage m) async {
    final title = (m.notification?.title ?? m.data['title'] as String?) ?? "New Notification";
    final body  = (m.notification?.body  ?? m.data['body']  as String?) ?? "You have a new message";
    final data  = m.data;

    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(onPressed: () { Navigator.pop(ctx); _onReject(data); }, child: const Text('Reject')),
          TextButton(onPressed: () { Navigator.pop(ctx); _onAccept(data); }, child: const Text('Accept')),
        ],
      ),
    );
  }

  // ---------- Your backend calls for actions ----------
  Future<void> _onAccept(Map<String, dynamic> data) async {
    await _callActionApi('accept', data);
  }

  Future<void> _onReject(Map<String, dynamic> data) async {
    await _callActionApi('reject', data);
  }

  Future<void> _callActionApi(String action, Map<String, dynamic> data) async {
    try {
      final uri = Uri.parse("$_baseUrl/api/Notification/$action"); // adjust path
      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'payload': data}),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$action → ${res.statusCode}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$action error: $e')),
      );
    }
  }

  // ---------- Registration helpers ----------
  Future<void> _registerToken(String token) async {
    final url = Uri.parse("$_baseUrl$_registerPath");
    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"Token": token}),
      );
      setState(() => _serverMessage = res.statusCode == 200 ? "Token registered" : "Register failed: ${res.statusCode}");
    } catch (e) {
      setState(() => _serverMessage = "Register error: $e");
    }
  }

  Future<void> _verifyTokenViaFirebaseAuth(String token, String email, String password) async {
    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      final idToken = await cred.user?.getIdToken();
      if (idToken != null) {
        final url = Uri.parse("$_baseUrl$_verifyPath");
        final res = await http.post(url, headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        });
        setState(() => _serverMessage = "Verify: ${res.statusCode}");
      }
    } catch (e) {
      setState(() => _serverMessage = "Verify error: $e");
    }
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notification Page")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_permissionGranted ? "✅ Notifications enabled" : "❌ Notifications denied"),
            const SizedBox(height: 16),
            const Text("Device Token:"),
            const SizedBox(height: 8),
            if (_deviceToken != null)
              SelectableText(_deviceToken!, style: const TextStyle(fontSize: 12, color: Colors.blue))
            else
              const Text("Fetching token..."),
            const SizedBox(height: 24),
            if (_serverMessage != null) ...[
              const Text("Server Response:"),
              const SizedBox(height: 8),
              Text(_serverMessage!, textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}

