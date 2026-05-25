import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:schoolmanagementsystem/services/notification_helper.dart';

import 'bloc/taxi_booking_bloc.dart';
import 'controllers/web_socket_handler.dart';
import 'data/newtwork/my_http_overrides.dart';
import 'data/newtwork/network_api_services.dart';
import 'loginModules/res/appColors.dart';
import 'routes/MyNavigationObserver.dart';
import 'routes/routes.dart';
import 'routes/routesname.dart';
import 'widgets/custom_notification_card.dart';

/// -------------------- GLOBALS --------------------
final FlutterLocalNotificationsPlugin _local =
    FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const _kChannelId = 'high_importance_channel_v2';
const _kChannelName = 'High Importance Notifications';
const _kChannelDesc = 'Local notifications';

const AndroidNotificationChannel _channel = AndroidNotificationChannel(
  _kChannelId,
  _kChannelName,
  description: _kChannelDesc,
  importance: Importance.max,
);

/// -------------------- APP LIFECYCLE --------------------
class AppLifecycleObserver extends WidgetsBindingObserver {
  static bool isForeground = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    isForeground = state == AppLifecycleState.resumed;
  }
}

/// -------------------- LOCAL NOTIFICATION INIT --------------------
Future<void> _ensureLocalInit() async {
  const initSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  );

  await _local.initialize(
    initSettings,
    onDidReceiveNotificationResponse: _onActionTapFg,
    onDidReceiveBackgroundNotificationResponse: _onActionTapBg,
  );

  await _local
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(_channel);
}

/// -------------------- SYSTEM NOTIFICATION --------------------
Future<void> _showSystemNotification({
  required String? title,
  required String? body,
  required Map<String, dynamic> data,
}) async {
  final expandedBody = '''
$body
Ride ID: ${data['rideId'] ?? '-'}
Status: Active
------------------------------
''';

  final bigText = BigTextStyleInformation(
    expandedBody,
    contentTitle: title ?? 'Message',
  );

  final androidDetails = AndroidNotificationDetails(
    _kChannelId,
    _kChannelName,
    channelDescription: _kChannelDesc,
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    ongoing: true,
    autoCancel: false,
    styleInformation: bigText,
  );
  await _local.show(
    9001,
    title ?? 'Message',
    body ?? '',
    NotificationDetails(android: androidDetails),
    payload: jsonEncode(data),
  );
}

/// -------------------- IN-APP OVERLAY --------------------
void showInAppNotificationSafe({
  required String title,
  required String message,
  Duration duration = const Duration(seconds: 12),
}) {
  final overlay = navigatorKey.currentState?.overlay;
  if (overlay == null) return;

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (_) => Positioned(
      top: MediaQuery.of(navigatorKey.currentContext!).padding.top + 12,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: CustomNotificationCard(
          title: title,
          message: message,
          color: AppColors.primary,
          onDismiss: () => entry.remove(),
          type: NotificationType.info,
        ),
      ),
    ),
  );

  overlay.insert(entry);

  Future.delayed(duration, () {
    if (entry.mounted) entry.remove();
  });
}

/// -------------------- NOTIFICATION ACTION HANDLERS --------------------
void _handleAction(NotificationResponse r, {required bool isBg}) {
  final data = (r.payload?.isNotEmpty ?? false)
      ? jsonDecode(r.payload!) as Map<String, dynamic>
      : {};

  if (!isBg && navigatorKey.currentContext != null) {
    Navigator.pushNamed(
      navigatorKey.currentContext!,
      RoutesName.homeScreen,
      arguments: data,
    );
  }
}

void _onActionTapFg(NotificationResponse r) => _handleAction(r, isBg: false);

@pragma('vm:entry-point')
void _onActionTapBg(NotificationResponse r) => _handleAction(r, isBg: true);

/// -------------------- BACKGROUND HANDLER --------------------
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final title =
      (message.data['title'] ?? message.notification?.title)?.toString();
  final body = (message.data['body'] ?? message.notification?.body)?.toString();

  // ❌ NO Flutter UI here
/*  await _showSystemNotification(
    title: title,
    body: body,
    data: message.data,
  );*/
  await NotificationHelper.showCustomNotification(
      title ?? 'Notification', body ?? '');
}

/// -------------------- MAIN --------------------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance.addObserver(AppLifecycleObserver());
  HttpOverrides.global = MyHttpOverrides();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await _ensureLocalInit();
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  /// FOREGROUND
  FirebaseMessaging.onMessage.listen((m) {
    final title = (m.data['title'] ?? m.notification?.title)?.toString() ??
        'Notification';
    final body = (m.data['body'] ?? m.notification?.body)?.toString() ?? '';

    showInAppNotificationSafe(
      title: title,
      message: body,
    );
  });

  /// BACKGROUND → OPENED
  FirebaseMessaging.onMessageOpenedApp.listen((m) {
    final title = (m.data['title'] ?? m.notification?.title)?.toString() ??
        'Notification';
    final body = (m.data['body'] ?? m.notification?.body)?.toString() ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showInAppNotificationSafe(
        title: title,
        message: body,
      );
    });
  });

  final wsService = PassengerWebSocket();
  final apiService = NetworkApiService();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TaxiBookingBloc(
            webSocketService: wsService,
            apiService: apiService,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );

  /// KILLED → COLD START
  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    final title =
        (initialMessage.data['title'] ?? initialMessage.notification?.title)
                ?.toString() ??
            'Notification';

    final body =
        (initialMessage.data['body'] ?? initialMessage.notification?.body)
                ?.toString() ??
            '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showInAppNotificationSafe(
        title: title,
        message: body,
      );
    });
  }
}

/// -------------------- APP --------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'UPCHAR SARTHI',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [MyNavigatorObserver()],
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        primaryColor: AppColors.primary,
        primarySwatch: AppColors.darkBlueMaterialColor,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: AppColors.black,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
          iconTheme: IconThemeData(color: AppColors.white),
        ),
      ),
      initialRoute: RoutesName.splashScreen,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
