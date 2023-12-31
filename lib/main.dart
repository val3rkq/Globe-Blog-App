import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:globe/auth/auth_gate.dart';
import 'package:globe/constants.dart';
import 'package:globe/firebase_options.dart';
import 'package:globe/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:globe/auth/auth.dart';
import 'package:flutter/services.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // this is necessary to prevent screen rotation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // init firebase
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
        bottomSheetTheme: BottomSheetThemeData(
          shape: const Border.symmetric(
            vertical: BorderSide.none,
            horizontal: BorderSide.none,
          ),
          backgroundColor: backColor2,
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
