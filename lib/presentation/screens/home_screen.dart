import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minhas_receitas/presentation/widgets/custom_button.dart';
import 'package:minhas_receitas/presentation/widgets/custom_paragraph.dart';
import 'package:minhas_receitas/presentation/widgets/custom_textarea.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final QuillController _controller = QuillController.basic();

  @override
  Widget build(BuildContext context) {
    final Widget svg = SvgPicture.asset(
      'chef.svg',
      semanticsLabel: 'Chef',
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    svg,
                    const SizedBox(height: 40),
                    const SizedBox(
                      width: 260,
                      height: 50,
                      child: CustomParagraph(
                        text: 'Você ainda não possui nenhuma receita',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 40),
                    CustomButton(
                      label: 'Nova receita',
                      onPressed: () {
                        Navigator.pushNamed(context, '/add');
                      },
                    ),
                    const SizedBox(height: 40),
                    CustomButton(
                      label: 'Ver receita',
                      onPressed: () {
                        Navigator.pushNamed(context, '/view');
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 300,
                      child: CustomRichTextEditor(controller: _controller),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      label: 'Ver conteúdo digitado',
                      onPressed: () {
                        final texto = _controller.document.toPlainText();
                        print('Conteúdo do editor:\n$texto');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
