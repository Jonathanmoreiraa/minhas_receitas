import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minhas_receitas/presentation/widgets/custom_button.dart';
import 'package:minhas_receitas/presentation/widgets/custom_paragraph.dart';
import 'package:minhas_receitas/presentation/widgets/custom_textarea.dart';
import 'package:minhas_receitas/presentation/widgets/custom_input.dart';

import '../../data/models/receita.dart';
import '../../data/repositories/receita_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final QuillController _controller = QuillController.basic();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _ingredienteController = TextEditingController();

  final ReceitaRepository _repository = ReceitaRepository();

  List<Receita> _receitas = [];

  @override
  void initState() {
    super.initState();
    _carregarReceitas();
  }

  Future<void> _carregarReceitas() async {
    final receitas = await _repository.getReceitas();
    setState(() {
      _receitas = receitas;
    });
  }

  void _salvarReceita() async {
    final nome = _nomeController.text.trim();
    final ingrediente = _ingredienteController.text.trim();
    final modoPreparoJson = _controller.document.toDelta().toJson();

    if (nome.isEmpty || ingrediente.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    final receita = Receita(
      nome: nome,
      ingredientes: [ingrediente],
      modoPreparoJson: modoPreparoJson.toString(),
    );

    await _repository.insertReceita(receita);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Receita salva com sucesso!')),
      );
      _nomeController.clear();
      _ingredienteController.clear();
      _controller.document = Document();
      await _carregarReceitas(); // Atualiza lista depois de salvar
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget svg = SvgPicture.asset(
      'chef.svg',
      semanticsLabel: 'Chef',
    );

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            svg,
            const SizedBox(height: 20),
            const CustomParagraph(
              text: 'Cadastrar nova receita de teste',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CustomInput(
              controller: _nomeController,
              placeholder: 'Nome da Receita',
            ),
            const SizedBox(height: 16),
            CustomInput(
              controller: _ingredienteController,
              placeholder: 'Ingrediente (um só pra teste)',
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: CustomRichTextEditor(controller: _controller),
            ),
            const SizedBox(height: 16),
            CustomButton(
              label: 'Salvar Receita',
              onPressed: _salvarReceita,
            ),
            const SizedBox(height: 30),
            const Text(
              'Receitas salvas:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Lista simples com nomes das receitas
            ..._receitas.map(
              (r) => ListTile(
                title: Text(r.nome),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
