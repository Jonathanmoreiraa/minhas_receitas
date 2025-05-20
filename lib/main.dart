import 'package:flutter/material.dart';
import 'package:minhas_receitas/presentation/screens/add_screen.dart';
import 'package:minhas_receitas/presentation/screens/home_screen.dart';
import 'package:minhas_receitas/presentation/screens/view_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minhas Receitas',
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