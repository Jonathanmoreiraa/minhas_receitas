import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minhas_receitas/presentation/widgets/custom_button.dart';
import 'package:minhas_receitas/presentation/widgets/custom_paragraph.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget svg = SvgPicture.asset(
      'chef.svg',
      semanticsLabel: 'Chef',
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            svg,
            const SizedBox(height: 40),
            const SizedBox(
              width: 260,
              height: 50,
              child: CustomParagraph(text: 'Você ainda não possui nenhuma receita', textAlign: TextAlign.center)
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
          ],
        ),
      ),
    );
  }
}