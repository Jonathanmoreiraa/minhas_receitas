class Receita {
  int? id;
  String nome;
  List<String> ingredientes;
  String modoPreparoJson;
  String? imagemCapaPath;

  Receita({
    this.id,
    required this.nome,
    required this.ingredientes,
    required this.modoPreparoJson,
    this.imagemCapaPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'ingredientes': ingredientes.join(';'),
      'modoPreparoJson': modoPreparoJson,
      'imagemCapaPath': imagemCapaPath,
    };
  }

  factory Receita.fromMap(Map<String, dynamic> map) {
    return Receita(
      id: map['id'],
      nome: map['nome'],
      ingredientes: (map['ingredientes'] as String).split(';'),
      modoPreparoJson: map['modoPreparoJson'],
      imagemCapaPath: map['imagemCapaPath'],
    );
  }
}
