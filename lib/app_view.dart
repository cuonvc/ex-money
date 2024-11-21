import 'package:ex_money/screens/auth/views/auth_selection.dart';
import 'package:ex_money/screens/auth/views/sign_in.dart';
import 'package:ex_money/screens/auth/views/sign_up.dart';
import 'package:ex_money/screens/main/views/category/category_list.dart';
import 'package:ex_money/screens/main/views/expense_detail/expense_detail.dart';
import 'package:ex_money/screens/main/views/home/home_screen.dart';
import 'package:ex_money/screens/main/views/main_screen.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
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
      home: MainScreen(),
      routes: {
        '/auth/selection': (context) => const AuthSelection(),
        NavigatePath.signInPath: (context) => const SignIn(),
        NavigatePath.signUpPath: (context) => const SignUp(),
        NavigatePath.homePath: (context) => const MainScreen(),
        NavigatePath.expenseDetailPath: (context) => const ExpenseDetail(),
        NavigatePath.categoryListPath: (context) => CategoryList()
      },
    );
  }
}
