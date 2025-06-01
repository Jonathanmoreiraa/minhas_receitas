import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:minhas_receitas/data/models/receita.dart';
import 'package:minhas_receitas/data/repositories/receita_repository.dart';
import 'package:minhas_receitas/presentation/widgets/custom_paragraph.dart';
import 'package:minhas_receitas/presentation/widgets/custom_subtitle.dart';
import 'package:minhas_receitas/presentation/widgets/custom_title.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/widgets.dart' as pw;

class ViewScreen extends StatefulWidget {
  const ViewScreen({super.key});

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  final ReceitaRepository _repository = ReceitaRepository();

  Future<void> _exportToPdf(Receita receita) async {
    try {
      final Uint8List? imageBytes = await _screenshotController.capture();
      final List<pw.Widget> ingredientes = receita.ingredientes.map(
        (ingrediente) => pw.Bullet(text: ingrediente),
      ).toList();
      
      final List<dynamic> modoPreparoJson = jsonDecode(receita.modoPreparoJson);
      final String textoModoPreparo = modoPreparoJson
          .whereType<Map<String, dynamic>>()
          .map((e) => e['insert'] ?? '')
          .join()
          .toString();

      if (imageBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao capturar a tela')),
        );
        return;
      }

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) => [
            pw.SizedBox(height: 16),
            pw.Text(receita.nome, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 16),
            pw.Text('Ingredientes', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            ...ingredientes,
            pw.SizedBox(height: 16),
            pw.Text('Modo de Preparo', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.Text(textoModoPreparo.trim()),
          ],
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao gerar PDF: $e')),
      );
    }
  }

  Future<Receita> getReceita() async {
    final receita = ModalRoute.of(context)?.settings.arguments as Receita;
    final receitaBanco = await _repository.getReceita(receita.id.toString());
    return receitaBanco.isNotEmpty ? receitaBanco[0] : receita;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(100, 0, 0, 0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
            tooltip: 'Exportar como PDF',
            onPressed: () async {
              final receita = await getReceita();
              _exportToPdf(receita);
            },
          ),
        ],
      ),
      body: FutureBuilder<Receita>(
        future: getReceita(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Receita não encontrada'));
          }

          final receita = snapshot.data!;
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
            readOnly: true,
          );

          return Screenshot(
            controller: _screenshotController,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.file(
                    File(receita.imagemCapaPath ?? ""),
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: 300,
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
                              icon: const Icon(Icons.edit),
                              color: const Color.fromARGB(255, 126, 99, 76),
                              onPressed: () => Navigator.pushNamed(context, '/edit', arguments: receita),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const CustomSubtitle(text: 'Ingredientes'),
                        const SizedBox(height: 8),
                        ...receita.ingredientes.map(
                          (ingrediente) => CustomParagraph(text: '\u2022 $ingrediente'),
                        ),
                        const SizedBox(height: 16),
                        const CustomSubtitle(text: 'Modo de preparo'),
                        QuillEditor.basic(controller: controller),
                        const SizedBox(height: 16),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
