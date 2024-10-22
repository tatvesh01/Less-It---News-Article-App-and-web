import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Common/notification_service.dart';
import 'Ui/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyC4t1ORC7B6XUwv-9r4dl8aF06iH7bQXVk",
          authDomain: "lessit-new.firebaseapp.com",
          projectId: "lessit-new",
          storageBucket: "lessit-new.appspot.com",
          messagingSenderId: "926701010198",
          appId: "1:926701010198:web:f600f6cd0856a4ae602437",
          measurementId: "G-BDSN61DCW7"
      ),
    );
  }else{
    await Firebase.initializeApp();
  }

  NotificationService().initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    subscribe();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Less It',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

void subscribe(){
  if(!kIsWeb){
    FirebaseMessaging message = FirebaseMessaging.instance;
    message.subscribeToTopic("notification");
  }
}
