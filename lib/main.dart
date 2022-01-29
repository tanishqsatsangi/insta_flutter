import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/user_provider.dart';
import 'package:social_media_app/responsive/responsive.dart';
import 'package:social_media_app/screens/login_screen.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/webscreenlayout.dart';

import 'mobilescreenlayout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyACUf37D_cyIqX1OS3rr7fpwBZe1d9bdRA",
        appId: "1:1003201936696:web:b7e04890e27c3dad90d5cd",
        messagingSenderId: "1003201936696",
        projectId: "instragram-clone-2d605",
        storageBucket: "instragram-clone-2d605.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                print("Snapshot has data");
                return ResponsiveLayout(
                  const WebScreenLayout(),
                  const MobileScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return const Icon(Icons.error_outline);
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: 200,
                  child: const CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              } else {
                return LoginScreen();
              }
            }),
      ),
    );
  }
}
