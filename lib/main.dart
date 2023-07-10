import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:globe/auth/auth_gate.dart';
import 'package:globe/firebase_options.dart';
import 'package:globe/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:globe/auth/auth.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => Auth(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        bottomSheetTheme: const BottomSheetThemeData(
          shape: Border.symmetric(
            vertical: BorderSide.none,
            horizontal: BorderSide.none,
          ),
          backgroundColor: Color(0xFF1C1B1F),
          elevation: 0,
        ),
      ),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: const AuthGate(),
    );
  }
}
