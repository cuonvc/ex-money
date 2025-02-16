import 'package:ex_money/screens/auth/blocs/oauth_sign_in/oauth_sign_in_bloc.dart';
import 'package:ex_money/screens/auth/views/active_account.dart';
import 'package:ex_money/screens/auth/views/auth_selection.dart';
import 'package:ex_money/screens/auth/views/sign_in.dart';
import 'package:ex_money/screens/auth/views/sign_up.dart';
import 'package:ex_money/screens/main/views/category/category_all.dart';
import 'package:ex_money/screens/main/views/category_detail/category_detail.dart';
import 'package:ex_money/screens/main/views/expense/expense_all.dart';
import 'package:ex_money/screens/main/views/expense_detail/expense_detail.dart';
import 'package:ex_money/screens/main/views/main_screen.dart';
import 'package:ex_money/screens/main/views/setting/password_change.dart';
import 'package:ex_money/screens/main/views/setting/setting.dart';
import 'package:ex_money/screens/main/views/splash_screen.dart';
import 'package:ex_money/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:repository/repository.dart';

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
      home: const SplashScreen(),
      routes: {
        '/auth/selection': (context) => BlocProvider(
            create: (context) => OAuthSignInBloc(UserRepositoryImpl()),
            child: const AuthSelection()
        ),
        NavigatePath.signInPath: (context) => const SignIn(),
        NavigatePath.signUpPath: (context) => const SignUp(),
        NavigatePath.activeAccountPath: (context) => const ActiveAccount(model: null, limitTime: 0, message: ""),
        NavigatePath.homePath: (context) => const MainScreen(),
        NavigatePath.settingPath: (context) => const Setting(),
        NavigatePath.passwordChangePath: (context) => const PasswordChange(),
        NavigatePath.expenseAll: (context) => const ExpenseAll(),
        NavigatePath.expenseDetailPath: (context) => const ExpenseDetail(detail: null,),
        NavigatePath.categoryListPath: (context) => const CategoryAll(walletId: null,),
        NavigatePath.categoryDetailPath: (context) => CategoryDetail(category: null, isCreateMode: false,)
      },
    );
  }
}
