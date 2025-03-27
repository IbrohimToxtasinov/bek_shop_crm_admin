import 'package:bek_shop/app/app.dart';
import 'package:bek_shop/firebase_options.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://fuhmfracejnatpjmksoa.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1aG1mcmFjZWpuYXRwam1rc29hIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA1NzcxNjIsImV4cCI6MjA1NjE1MzE2Mn0.QxOvFZrYtMkRoyDpCk4FzkoEOgIGe7QChse2HkttYUc",
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      EasyLocalization(
        startLocale: const Locale('uz', 'UZ'),
        supportedLocales: const [Locale('uz', 'UZ'), Locale('ru', 'RU'), Locale('en', 'EN')],
        path: 'assets/translations',
        fallbackLocale: const Locale('uz', 'UZ'),
        saveLocale: true,
        child: App(),
      ),
    );
  });
}
