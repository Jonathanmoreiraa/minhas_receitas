import '../models/receita.dart';
import '../database/db_helper.dart';

class ReceitaRepository {
  Future<void> insertReceita(Receita receita) async {
    final db = await DBHelper.database;
    await db.insert('receitas', receita.toMap());
  }

  Future<List<Receita>> getReceitas() async {
    final db = await DBHelper.database;
    final result = await db.query('receitas');
    return result.map((map) => Receita.fromMap(map)).toList();
  }

  Future<List<Receita>> getReceita(String receita) async {
    final db = await DBHelper.database;
    final result = await db.query(
      'receitas',
      where: 'nome LIKE ?',
      whereArgs: ["%$receita%"],
    );
    return result.map((map) => Receita.fromMap(map)).toList();
  }

  Future<Receita?> getReceitaById(int id) async {
    final db = await DBHelper.database;
    final result = await db.query(
      'receitas',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Receita.fromMap(result.first);
    }
    return null;
  }

  Future<void> updateReceita(Receita receita) async {
    final db = await DBHelper.database;
    await db.update(
      'receitas',
      receita.toMap(),
      where: 'id = ?',
      whereArgs: [receita.id],
    );
  }

  Future<void> deleteReceita(int id) async {
    final db = await DBHelper.database;
    await db.delete(
      'receitas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
