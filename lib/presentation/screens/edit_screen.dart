import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:minhas_receitas/data/models/receita.dart';
import 'package:minhas_receitas/data/repositories/receita_repository.dart';
import 'package:minhas_receitas/presentation/widgets/custom_button.dart';
import 'package:minhas_receitas/presentation/widgets/custom_input.dart';
import 'package:minhas_receitas/presentation/widgets/custom_short_button.dart';
import 'package:minhas_receitas/presentation/widgets/custom_textarea.dart';
import 'package:minhas_receitas/presentation/widgets/custom_title.dart';
import 'package:minhas_receitas/presentation/widgets/custom_paragraph.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:dotted_border/dotted_border.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController _nomeController = TextEditingController();
  TextEditingController novoIngredienteController = TextEditingController();
  final QuillController _modoPreparoController = QuillController.basic();
  List<TextEditingController> _ingredientesControllers = [];
  final ReceitaRepository _repository = ReceitaRepository();
  File? _imagemCapa;
  final ImagePicker _picker = ImagePicker();
  Receita? receita;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      receita = ModalRoute.of(context)?.settings.arguments as Receita;
      _nomeController.text = receita?.nome ?? "";

      final ingredientes = receita?.ingredientes ?? [];
      _ingredientesControllers = ingredientes.map((i) => TextEditingController(text: i.trim())).toList();
      if (_ingredientesControllers.isEmpty) {
        _ingredientesControllers.add(TextEditingController());
      }

      final modoPreparoDelta = receita?.modoPreparoJson;
      if (modoPreparoDelta != null) {
        final decoded = jsonDecode(modoPreparoDelta);
        _modoPreparoController.document = Document.fromJson(decoded);
      }

      if (receita?.imagemCapaPath != null && File(receita!.imagemCapaPath!).existsSync()) {
        _imagemCapa = File(receita!.imagemCapaPath!);
      }

      setState(() {});
    });
  }

  void _salvarReceita() async {
    final nome = _nomeController.text.trim();
    final modoPreparo = jsonEncode(
      _modoPreparoController.document.toDelta().toJson(),
    );
    final ingredientes =
        _ingredientesControllers
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

    final receitaEditada = Receita(
      id: receita?.id,
      nome: nome,
      ingredientes: ingredientes,
      modoPreparoJson: modoPreparo,
      imagemCapaPath: _imagemCapa?.path,
    );

    await _repository.updateReceita(receitaEditada);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Receita atualizada com sucesso!',
            style: TextStyle(
              color: Color.fromARGB(255, 105, 105, 105),
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color.fromARGB(255, 161, 255, 177),
        ),
      );
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  Future<void> _selecionarImagem() async {
    final XFile? imagemSelecionada = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 600,
      maxWidth: 800,
    );

    if (imagemSelecionada != null) {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String nomeArquivo = path.basename(imagemSelecionada.path);
      final File imagemSalva = await File(imagemSelecionada.path).copy('${appDir.path}/$nomeArquivo');

      setState(() {
        _imagemCapa = imagemSalva;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: CustomTitle(
          text: 'Editar receita',
          textAlign: TextAlign.end,
        ),
      ),
      body: receita == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
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
                          Expanded(
                            flex: 1,
                            child: CustomShortButton(
                              onPressed: () {
                                setState(() {
                                  _ingredientesControllers.removeAt(index);
                                });
                              },
                              icon: "remove",
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: CustomInput(
                        controller: novoIngredienteController,
                        placeholder: 'Ingrediente',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: CustomShortButton(
                        onPressed: () {
                          setState(() {
                            _ingredientesControllers.add(TextEditingController(text: novoIngredienteController.text.trim()));
                            novoIngredienteController.text = "";
                          });
                        },
                        icon: "",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 400,
                  child: CustomRichTextEditor(controller: _modoPreparoController),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: _selecionarImagem,
                  child: SizedBox(
                    width: double.infinity,
                    child: DottedBorder(
                      options: RectDottedBorderOptions(
                        dashPattern: [10, 5],
                        strokeWidth: 2,
                        padding: EdgeInsets.all(16),
                        color: Color.fromARGB(166, 126, 99, 76),
                      ),
                      child: Builder(
                        builder: (context) {
                          if (_imagemCapa == null) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo,
                                  color: Color.fromARGB(178, 157, 139, 76),
                                  size: 32,
                                ),
                                SizedBox(width: 8),
                                CustomParagraph(text: "Enviar foto da receita pronta"),
                              ],
                            );
                          } else {
                            return Image.file(
                              _imagemCapa!,
                              height: 200,
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                CustomButton(onPressed: _salvarReceita, label: "Salvar Alterações"),
                const SizedBox(height: 24),
              ],
            ),
    );
  }
}
