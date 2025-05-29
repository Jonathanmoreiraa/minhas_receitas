import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class CustomRichTextEditor extends StatefulWidget {
  final QuillController controller;

  const CustomRichTextEditor({Key? key, required this.controller}) : super(key: key);

  @override
  State<CustomRichTextEditor> createState() => _CustomRichTextEditorState();
}

class _CustomRichTextEditorState extends State<CustomRichTextEditor> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        QuillSimpleToolbar(
          controller: widget.controller,
          config: const QuillSimpleToolbarConfig(
            showHeaderStyle: true,
            showListNumbers: true,
            showListBullets: true,
            showBoldButton: true,
            showItalicButton: true,
            showColorButton: false,
            showBackgroundColorButton: true,
            showUnderLineButton: true,
            showFontFamily: true,
            showFontSize: true,
            showIndent: true,
            showStrikeThrough: false,
            showClearFormat: false,
            showQuote: false,
            showCodeBlock: false,
            showInlineCode: false,
            showLink: false,
            showDirection: false,
            showSearchButton: false,
            showRedo: false,
            showUndo: false,
            showDividers: false,
            showAlignmentButtons: false,
            showSubscript: false,
            showSuperscript: false,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Color.fromARGB(255, 126, 99, 76)),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: QuillEditor.basic(
            controller: widget.controller,
            config: const QuillEditorConfig(
              placeholder: 'Digite a receita aqui...',
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}
