import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minhas_receitas/data/models/receita.dart';
import 'package:minhas_receitas/data/repositories/receita_repository.dart';
import 'package:minhas_receitas/presentation/widgets/custom_button.dart';
import 'package:minhas_receitas/presentation/widgets/custom_input.dart';
import 'package:minhas_receitas/presentation/widgets/custom_paragraph.dart';
import 'package:minhas_receitas/presentation/widgets/custom_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  final ReceitaRepository _repository = ReceitaRepository();
  final TextEditingController _receitasController = TextEditingController(); 
  List<Receita> _receitas = [];
  List<Receita> _receitasBanco = [];
  var filtroVazio = false;

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
      filtroVazio = false;
      _receitas = receitas;
      _receitasController.text = "";
    });
  }

  Future<void> _filtrarReceita() async {
    final receita = await _repository.getReceita(_receitasController.text.trim());
    setState(() {
      if (receita.isNotEmpty) {
        _receitas = receita;
      }else{
        filtroVazio = true;
        _receitas = [];
      }
    });
  }

  Future<void> _removerReceita(id) async {
    await _repository.deleteReceita(id);
    setState(() {
      _receitas = [];
      _carregarReceitas();
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
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text("Minhas Receitas"),
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 126, 99, 76),
        ),
        actions: [
          if (_receitas.isNotEmpty || filtroVazio) 
            Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 16, 0), 
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 210, 161),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                  )
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text('Filtrar receitas'),
                      content: CustomInput(
                        placeholder: "Informe o nome da receita",
                        controller: _receitasController,
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            _carregarReceitas();
                          },
                          child: Text('Limpar filtro', style: TextStyle(color: Color.fromARGB(255, 126, 99, 76))),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancelar', style: TextStyle(color: Color.fromARGB(255, 126, 99, 76))),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            _filtrarReceita();
                          },
                          child: Text('Filtrar', style: TextStyle(color: Color.fromARGB(255, 126, 99, 76))),
                        ),
                      ],
                    ),
                  );
                },
                child: Icon(Icons.filter_list)
              ),
            ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (_receitas.isNotEmpty) {
            return ListView(
              padding: EdgeInsets.only(bottom: 24),
              children: [
                GestureDetector(
                  onTap: () async {
                    await Navigator.pushNamed(context, '/add');
                    _carregarReceitas();
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: double.infinity,
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
                            color: Color.fromARGB(178, 157, 139, 76),
                            size: 32,
                          ),
                          SizedBox(width: 8),
                          CustomParagraph(text: "Nova receita"),
                        ],
                      ),
                    ),
                  ),
                ),
                ..._receitas.map((receita) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/view', arguments: receita);
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
                      child: Container(
                        height: 80,
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
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                              child: Image.network(
                                'https://picsum.photos/500/300?image=63',
                                fit: BoxFit.cover,
                                width: 117,
                                height: 80,
                              ),
                            ),
                            Expanded(
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                                      child: CustomParagraph(text: receita.nome),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size(0, 0),
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: Text('Apagar receita'),
                                              content: Text('Deseja deletar sua receita "${receita.nome}"?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: Text('Não', style: TextStyle(color: Color.fromARGB(255, 126, 99, 76))),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    await _removerReceita(receita.id);
                                                  },
                                                  child: Text('Sim', style: TextStyle(color: Color.fromARGB(255, 126, 99, 76))),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.close,
                                          color: Color.fromARGB(178, 157, 139, 76),
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            );
          } else if (filtroVazio) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    child: CustomParagraph(
                      text: 'Nenhuma receita encontrada para o filtro informado!',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 40),
                  CustomButton(
                    label: 'Remover filtro',
                    onPressed: () {
                      _carregarReceitas();
                    },
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 SizedBox(height: 50),
                  SvgPicture.asset('assets/chef.svg', semanticsLabel: 'Chef'),
                 SizedBox(height: 40),
                 SizedBox(
                    width: 260,
                    height: 50,
                    child: CustomParagraph(
                      text: 'Você ainda não possui nenhuma receita',
                      textAlign: TextAlign.center,
                    ),
                  ),
                 SizedBox(height: 40),
                  CustomButton(
                    label: 'Nova receita',
                    onPressed: () async {
                      await Navigator.pushNamed(context, '/add');
                      _carregarReceitas();
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),  
    );
  }
}