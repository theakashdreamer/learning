import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// Override the HTTP client for SSL configuration
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    // Allows untrusted certificates (use cautiously, avoid in production)
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return client;
  }
}