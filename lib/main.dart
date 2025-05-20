import 'package:flutter/material.dart';
// Troque 'meu_app' pelo nome definido em pubspec.yaml
import 'package:minhas_receitas/presentation/widgets/custom_button.dart';
import 'package:minhas_receitas/presentation/widgets/custom_paragraph.dart';
import 'package:minhas_receitas/presentation/widgets/custom_short_button.dart';
import 'package:minhas_receitas/presentation/widgets/custom_subtitle.dart';
import 'package:minhas_receitas/presentation/widgets/custom_title.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          children: [
            CustomTitle(text: "Título aqui"),
            CustomSubtitle(text: "Subtitulo aqui"),
            CustomParagraph(text: "Paragrafo aqui"),
            CustomButton(
              label: 'Clique aqui',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Botão pressionado!')),
                );
              },
            ),
            CustomShortButton(onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Botão pressionado!')),
                );
              }
            )

          ],
        )
        
      ),
    );
  }
}
