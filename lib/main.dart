import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:soilcheck/providers/auth_provider.dart';
import 'package:soilcheck/providers/checklist_provider.dart';
import 'package:soilcheck/providers/template_provider.dart';
import 'package:soilcheck/providers/user_provider.dart';
import 'package:soilcheck/views/homepage.dart';
import 'package:soilcheck/views/login_view.dart';
import 'package:soilcheck/providers/navigation_provider.dart';

void main() async {
  await dotenv.load();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => TemplateProvider()),
      ChangeNotifierProvider(create: (_) => ChecklistProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SoilCheck',
      theme: Theme.of(context).copyWith(
     
        primaryColor: const Color(0xff528c4f),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xff528c4f),
        ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                backgroundColor: const Color(0xff528c4f),
                disabledBackgroundColor: const Color(0x88528c4f),
                disabledForegroundColor: Colors.white,
                foregroundColor: Colors.white)),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: TextButton.styleFrom(
                backgroundColor: const Color(0xff528c4f),
                disabledBackgroundColor: const Color(0x88528c4f),
                disabledForegroundColor: Colors.white,
                foregroundColor: Colors.white)),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginView(),
        '/home': (context) => HomeScreen(),
        //'/modelos': (context) => ModeloTesteView(),
        //'/checks': (context) => const Check()
      },
    );
  }
}
