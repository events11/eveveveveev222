import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_application_1/generated/l10n.dart';

class LanguageScreen extends StatefulWidget {
  static const String screenRoute = 'LanguageScreen';

  const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  Locale _currentLocale = const Locale('en'); // اللغة الافتراضية

  void _changeLanguage() {
    setState(() {
      _currentLocale = _currentLocale.languageCode == 'en'
          ? const Locale('ar')
          : const Locale('en');
      S.load(_currentLocale); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _currentLocale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(
        
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _changeLanguage, 
                child: Text(
                  S.of(context).changeLanguageButton, // زر مترجم
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
