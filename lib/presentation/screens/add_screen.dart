import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:minhas_receitas/data/database/db_helper.dart';
import 'package:minhas_receitas/data/models/receita.dart';
import 'package:minhas_receitas/data/repositories/receita_repository.dart';
import 'package:minhas_receitas/presentation/widgets/custom_button.dart';
import 'package:minhas_receitas/presentation/widgets/custom_input.dart';
import 'package:minhas_receitas/presentation/widgets/custom_short_button.dart';
import 'package:minhas_receitas/presentation/widgets/custom_textarea.dart';
import 'package:minhas_receitas/presentation/widgets/custom_title.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final QuillController _modoPreparoController = QuillController.basic();
  List<TextEditingController> _ingredientesControllers = [];
  final ReceitaRepository _repository = ReceitaRepository();

  @override
  void initState() {
    super.initState();
    _ingredientesControllers.add(TextEditingController());
  }

  void _salvarReceita() async {
    final nome = _nomeController.text.trim();
    final modoPreparo = jsonEncode(_modoPreparoController.document.toDelta().toJson());
    final ingredientes = _ingredientesControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (nome.isEmpty || ingredientes.isEmpty || modoPreparo.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preencha todos os campos')),
        );
      }
      return;
    }

    final receita = Receita(
      nome: nome,
      ingredientes: ingredientes,
      modoPreparoJson: modoPreparo,
    );

    await _repository.insertReceita(receita);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Receita salva com sucesso!')),
      );
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: const Color(0xFFFFF4E8),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            const CustomTitle(
              text: 'Cadastrar nova receita',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CustomInput(
              controller: _nomeController,
              placeholder: "Nome da receita",
            ),
            const SizedBox(height: 16),
            Column(
              children: List.generate(_ingredientesControllers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: CustomInput(
                          controller: _ingredientesControllers[index],
                          placeholder: 'Ingrediente',
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (index == _ingredientesControllers.length - 1)
                        Expanded(
                          flex: 1,
                          child: CustomShortButton(
                            onPressed: () {
                              setState(() {
                                _ingredientesControllers.add(TextEditingController());
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 400,
              child: CustomRichTextEditor(controller: _modoPreparoController),
            ),
            const SizedBox(height: 16),
            CustomButton(
              onPressed: _salvarReceita,
              label: "Salvar Receita",
            ),
          ],
        ),
      ),
    );
  }
}
