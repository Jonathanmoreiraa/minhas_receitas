import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:minhas_receitas/data/models/receita.dart';
import 'package:minhas_receitas/presentation/widgets/custom_paragraph.dart';
import 'package:minhas_receitas/presentation/widgets/custom_subtitle.dart';
import 'package:minhas_receitas/presentation/widgets/custom_title.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({super.key});

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}
class _ViewScreenState extends State<ViewScreen> {
  bool state = false;

  @override
  Widget build(BuildContext context) {
    final receita = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Receita;
    
    final List<dynamic> originalDelta = jsonDecode(receita.modoPreparoJson);
    final List<dynamic> greenDelta = originalDelta.map((op) {
      if (op is Map<String, dynamic> && op.containsKey('insert')) {
        final insert = op['insert'];
        final attributes = Map<String, dynamic>.from(op['attributes'] ?? {});
        attributes['color'] = '#7e634c';
        return {
          'insert': insert,
          'attributes': attributes,
        };
      }
      return op;
    }).toList();
    
    final QuillController controller = QuillController(
      document: Document.fromJson(greenDelta),
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: true
    );

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
                          CustomTitle(text: receita.nome),
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
                      ...receita.ingredientes.map((ingrediente) => CustomParagraph(text: '\u2022 $ingrediente')),
                      SizedBox(height: 16),
                      CustomSubtitle(text: 'Modo de preparo'),
                      QuillEditor.basic(
                        controller: controller,
                      ),
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