import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      // home: BlocProvider(),
    );
  }
}
