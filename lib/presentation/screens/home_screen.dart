import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minhas_receitas/data/models/receita.dart';
import 'package:minhas_receitas/data/repositories/receita_repository.dart';
import 'package:minhas_receitas/presentation/widgets/custom_button.dart';
import 'package:minhas_receitas/presentation/widgets/custom_paragraph.dart';
import 'package:minhas_receitas/presentation/widgets/custom_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  final ReceitaRepository _repository = ReceitaRepository();
  List<Receita> _receitas = [];

  @override
  void initState() {
    super.initState();
    _carregarReceitas();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _carregarReceitas();
  }

  Future<void> _carregarReceitas() async {
    final receitas = await _repository.getReceitas();
    setState(() {
      _receitas = receitas;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget svg = SvgPicture.asset(
      'assets/chef.svg',
      semanticsLabel: 'Chef',
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Minhas Receitas"),
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 126, 99, 76),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(24, 32, 24, 0),
                  child: DottedBorder(
                    options: RectDottedBorderOptions(
                      dashPattern: [10, 5],
                      strokeWidth: 2,
                      padding: EdgeInsets.all(16),
                      color: Color.fromARGB(166, 126, 99, 76),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: Color.fromARGB(178, 157, 139,76),
                          size: 32,
                        ),
                        CustomParagraph(text: "Nova receita")
                      ],
                    )
                  ),
                ),
                Center(
                  child: Builder(
                    builder: (context) {
                      if (_receitas.isNotEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ListView.builder(
                              padding: const EdgeInsets.all(24),
                              itemCount: _receitas.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                final Receita receita = _receitas[index];

                                return Container(
                                  height: 80,
                                  margin: EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        spreadRadius: 0,
                                        blurRadius: 2,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Image.network(
                                        'https://picsum.photos/500/300?image=63',
                                        fit: BoxFit.cover,
                                      ),
                                      //TODO: ajustar
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsetsGeometry.only(left: 16),
                                            child: CustomParagraph(text: receita.nome, ),
                                          ),
                                          Icon(Icons.close)
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              }
                            ),
                          ],
                        );
                      } else {
                        return Column(
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
                              onPressed: () async {
                                await Navigator.pushNamed(context, '/add');
                                _carregarReceitas();
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
                        );
                      }
                    }
                  ),
                ),
              ],
            ),
          )
        ]
      ),
    );
  }
}