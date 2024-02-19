import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:soilcheck/views/login_view.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MultiProvider(
    providers: [
      //ChangeNotifierProvider(create: (_) => AuthController()),
      //ChangeNotifierProvider(create: (_) => ModelosController()),
      //ChangeNotifierProvider(create: (_) => ChecksController())
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
        //'/home': (context) => const HomeView(),
        //'/modelos': (context) => ModeloTesteView(),
        //'/checks': (context) => const Check()
      },
    );
  }
}
