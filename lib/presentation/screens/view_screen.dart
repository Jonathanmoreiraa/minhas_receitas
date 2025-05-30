import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:minhas_receitas/data/models/receita.dart';
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
  bool state = false;
  final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> _exportToPdf() async {
    try {
      final Uint8List? imageBytes = await _screenshotController.capture();

      if (imageBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao capturar a tela')),
        );
        return;
      }

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(pw.MemoryImage(imageBytes), fit: pw.BoxFit.contain),
            );
          },
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
        backgroundColor: const Color.fromARGB(100, 0, 0, 0),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.white,),
            tooltip: 'Exportar como PDF',
            onPressed: _exportToPdf,
          ),
        ],
      ),
      body: Screenshot(
        controller: _screenshotController,
        child: Stack(
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
                              icon: const Icon(Icons.edit),
                              color: const Color.fromARGB(255, 126, 99, 76),
                              onPressed: () => setState(() {
                                state = !state;
                              }),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        const CustomSubtitle(text: 'Ingredientes'),
                        const SizedBox(height: 8),
                        ...receita.ingredientes
                            .map((ingrediente) => CustomParagraph(text: '\u2022 $ingrediente')),
                        const SizedBox(height: 16),
                        const CustomSubtitle(text: 'Modo de preparo'),
                        QuillEditor.basic(
                          controller: controller,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}