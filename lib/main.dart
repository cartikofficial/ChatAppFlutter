import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:groupie/shared/constants.dart';
import 'package:groupie/Screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:groupie/Screens/login_in_screen.dart';
import 'package:groupie/services/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

AndroidNotificationChannel chanel = const AndroidNotificationChannel(
  "Very_important_Message",
  "name",
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future firebasemessagingbackground(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print("Message is :-  $message");
  }
  return Text("$message");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBDZpGsdzwBqpUhQXaTfu5nnsJXVNurbHk",
        authDomain: "chatappflutter-41418.firebaseapp.com",
        projectId: "chatappflutter-41418",
        storageBucket: "chatappflutter-41418.appspot.com",
        messagingSenderId: "329603254190",
        appId: "1:329603254190:web:0c97034ba33ee2fe122a3f",
      ),
    );
    if (kDebugMode) {
      print("Firebase-Web Initialized");
    }
  } else {
    await Firebase.initializeApp();
  }

  // FirebaseMessaging.onBackgroundMessage(
  //   (message) => firebasemessagingbackground(message),
  // );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(chanel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool issignedin = false;

  @override
  void initState() {
    super.initState();
    userlogeinstatus();
    FirebaseMessaging.onMessage.listen((RemoteMessage messages) {
      RemoteNotification? notification = messages.notification;
      AndroidNotification? androidNotification = messages.notification?.android;
      if (notification != null && androidNotification != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              chanel.id,
              chanel.name,
              // chanel.description,
              color: Colors.red,
              playSound: true,
              icon: "assets/images/Logo.png",
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage messages) {
      RemoteNotification? notification = messages.notification;
      AndroidNotification? androidNotification = messages.notification?.android;
      if (notification != null && androidNotification != null) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("${notification.title}"),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("${notification.body}"),
                  ],
                ),
              ),
            );
          },
        );
      }
    });
  }

  userlogeinstatus() async {
    await Sharedprefererncedata.getuserlogedinstatus().then((value) {
      if (value != null) {
        setState(() => issignedin = value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Groupie",
      theme: ThemeData(
        primaryColor: Constants().primarycolor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: issignedin ? const HomeScreen() : const Loginscreen(),
    );
  }
}
