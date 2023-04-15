import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rai_rub_rai_jai/data_model/date.dart';

import '../pages/all_main_page.dart';

import './provider/account_provider.dart';
import 'package:flutter/material.dart';

import 'data_model/edit_pass_argu.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider<User>(
      create: (context) {
        return User();
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        routes: {
          '/': (context) => SafeArea(child: LogInPage()),
          '/home': (context) => const SafeArea(child: HomePage()),
          '/edit': (context) => const SafeArea(child: EditPage()),
          '/setting': (context) => const SafeArea(child: SettingPage()),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/addData') {
            final screenArguments = settings.arguments as Date;
            return MaterialPageRoute(
              builder: (context) =>
                  SafeArea(child: AddEditPage(initDate: screenArguments)),
            );
          }
          if (settings.name == '/editData') {
            final screenArguments = settings.arguments as EditPassArgu;
            return MaterialPageRoute(
              builder: (context) => SafeArea(
                  child: AddEditPage(
                      initDate: screenArguments.date,
                      initIndex: screenArguments.index)),
            );
          }
          if (settings.name == '/edit_quick') {
            final screenArguments = settings.arguments as bool;
            return MaterialPageRoute(
              builder: (context) =>
                  SafeArea(child: QuickEditPage(isIncome: screenArguments)),
            );
          }
          if (settings.name == '/edit_month') {
            final screenArguments = settings.arguments as Date;
            return MaterialPageRoute(
              builder: (context) => SafeArea(
                  child:
                      EditSelectDataMonth(monthYearSelected: screenArguments)),
            );
          }
          return null;
        },
      ),
    );
  }
}
