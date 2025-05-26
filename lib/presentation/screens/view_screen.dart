import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:minhas_receitas/presentation/widgets/custom_paragraph.dart';
import 'package:minhas_receitas/presentation/widgets/custom_subtitle.dart';
import 'package:minhas_receitas/presentation/widgets/custom_textarea.dart';
import 'package:minhas_receitas/presentation/widgets/custom_title.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({super.key});

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}
class _ViewScreenState extends State<ViewScreen> {
  final QuillController _controller = QuillController.basic();
  bool state = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(28, 0, 0, 0),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Compartilhar receita',
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Compartilhou')));
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Image.network(
                      'https://picsum.photos/500/300?image=63',
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTitle(text: "Torta de frango"),
                          IconButton(
                            icon: Icon(Icons.edit), 
                            color: Color.fromARGB(255, 126, 99, 76),
                            onPressed: () => {
                              state = !state,
                            },
                          )
                        ],
                      ),
                      SizedBox(height: 16),
                      CustomSubtitle(text: 'Ingredientes'),
                      SizedBox(height: 8),
                      CustomParagraph(text: "Primeiro ingrediente"),
                      CustomParagraph(text: "Primeiro ingrediente"),
                      CustomParagraph(text: "Primeiro ingrediente"),
                      SizedBox(height: 16),
                      CustomSubtitle(text: 'Modo de preparo'),
                      SizedBox(height: 8),
                      CustomParagraph(text: "Em um recipiente, peneire a farinha, o sal e misture a manteiga com os dedos até formar uma farofa. Junte o ovo batido na mistura, utilizando uma espátula até obter uma massa firme e lisa, dando o ponto com a água fria e, se necessário, utilize 1 ou 2 colheres a mais. Leve à geladeira embrulhada em plástico-filme por no mínimo 30 minutos."),
                      SizedBox(height: 16),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}