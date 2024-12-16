import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/generated/l10n.dart';
import 'package:flutter_application_1/screens/ProfilePage_screen.dart';
import 'package:flutter_application_1/screens/post_screen.dart';
import 'package:flutter_application_1/screens/send_screen.dart';
import 'package:flutter_application_1/screens/signin_screen.dart';
import 'package:flutter_application_1/screens/signup_screen.dart';

// Import screens
import 'screens/pagewa_screen.dart';

import 'screens/welcome_screen.dart';

import 'screens/filtar_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // التوطين
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: const Locale('ar'), // لتعيين اللغة الافتراضية
      title: "App Events",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: FirebaseAuth.instance.currentUser != null
          ? PagewaScreen.screenRoute
          : WelcomeScreen.screenRoute,
         //home: FiltarScreen(),
      routes: {
        WelcomeScreen.screenRoute: (context) => const WelcomeScreen(),
        RegistrationScreen.screenRoute: (context) => const RegistrationScreen(),
        SignInScreen.screenRoute: (context) => const SignInScreen(),
        PagewaScreen.screenRoute: (context) => const PagewaScreen(),
        MessagingPage.screenRoute: (context) {
          final User? currentUser = FirebaseAuth.instance.currentUser;
          return MessagingPage(currentUserId: currentUser?.uid ?? ''); // Pass currentUserId
        },
        ProfilePage.screenRoute: (context) => const ProfilePage(),
        CreatePostPage.screenRoute: (context) => CreatePostPage(),
       // FiltarScreen.screenRoute: (context) => FiltarScreen(),
      },
    );
  }
}
