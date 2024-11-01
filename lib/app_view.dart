import 'package:ex_money/screens/auth/views/auth_selection.dart';
import 'package:ex_money/screens/auth/views/sign_in.dart';
import 'package:ex_money/screens/auth/views/sign_up.dart';
import 'package:ex_money/screens/main/views/home_screen.dart';
import 'package:ex_money/screens/main/views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('vi'),
        Locale('en')
      ],
      title: "Exmoney",
      // theme: ThemeData(
      //   colorScheme: ColorScheme.light(
      //     background: Colors.grey.shade100,
      //     onBackground: Colors.black,
      //     primary: const Color(0xFF1F6AFC),
      //     secondary: const Color(0xFFE064F7),
      //     tertiary: const Color(0xFFFF8D6C),
      //     outline: Colors.grey,
      //   )
      // ),
      home: AuthSelection(),
      routes: {
        '/auth/selection': (context) => AuthSelection(),
        '/auth/sign_in': (context) => SignIn(),
        '/auth/sign_up': (context) => SignUp(),
        '/home': (context) => MainScreen()
      },
    );
  }
}
