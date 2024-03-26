import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:soilcheck/providers/auth_provider.dart';
import 'package:soilcheck/providers/checklist_provider.dart';
import 'package:soilcheck/providers/cliente_provider.dart';
import 'package:soilcheck/providers/fazenda_provider.dart';
import 'package:soilcheck/providers/pivo_provider.dart';
import 'package:soilcheck/providers/template_provider.dart';
import 'package:soilcheck/providers/user_provider.dart';
import 'package:soilcheck/views/homepage.dart';
import 'package:soilcheck/views/login_view.dart';
import 'package:soilcheck/views/fazenda/fazenda_list.dart';
import 'package:soilcheck/views/cliente/cliente_list.dart';
import 'package:soilcheck/views/pivo/pivo_list.dart';
import 'package:soilcheck/providers/navigation_provider.dart';

void main() async {
  await dotenv.load();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => ChecklistProvider()),
      ChangeNotifierProvider(create: (_) => ClienteProvider()),
      ChangeNotifierProvider(create: (_) => FazendaProvider()),
      ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ChangeNotifierProvider(create: (_) => PivoProvider()),
      ChangeNotifierProvider(create: (_) => TemplateProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
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
        '/fazenda': (context) => const FazendasMain(),
        '/cliente': (context) => const ClientesMain(),
        '/pivo': (context) => const PivosMain(),
      },
    );
  }
}
