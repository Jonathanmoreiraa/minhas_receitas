import 'package:flutter/material.dart';
import 'package:minhas_receitas/presentation/screens/add_screen.dart';
import 'package:minhas_receitas/presentation/screens/home_screen.dart';
import 'package:minhas_receitas/presentation/screens/view_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minhas Receitas',
      localizationsDelegates: const [
        FlutterQuillLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), 
        Locale('pt'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFFFF4E8), 
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const HomeScreen(),
        "/add": (context) => const AddScreen(),
        "/view": (context) => const ViewScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() {
  runApp(const MyApp());
}