import 'package:sqflite/sqflite.dart';
import 'package:teste_pratico/datamodule/dmlocal.dart';
import 'package:teste_pratico/datamodule/other.dart';

class Pessoas extends AbstractModel {
  static Pessoas _this;

  factory Pessoas() {
    if (_this == null) {
      _this = Pessoas.getInstance();
    }
    return _this;
  }

  Pessoas.getInstance() : super();

  @override
  Future<bool> delete(codigo) async {
    Database db = await this.getdb();
    int del =
        await db.delete('pessoas', where: 'pk_codigo = ?', whereArgs: [codigo]);

    return (del != 0);
  }

  @override
  Future<Map> getPessoas(dynamic where) async {
    Database db = await this.getdb();
    List<Map> pessoa = await db.query('pessoas',
        where: 'pk_codigo = ?', whereArgs: [where], limit: 1);

    Map result = Map();
    if (pessoa.isNotEmpty) {
      result = pessoa.first;
    }
    return result;
  }

  @override
  Future<int> insert(Map<String, dynamic> values) async {
    Database db = await this.getdb();
    int newCodigo = await db.insert('pessoas', values);
    return newCodigo;
  }

  @override
  Future<List<Map>> buscaPessoas() async {
    Database db = await this.getdb();
    var l = await db.rawQuery('Select * from pessoas order by pk_codigo DESC');

    if (l != null) {
      return l;
    } else {
      throw Exception('Erro ao buscar dados do banco');
    }
  }

  @override
  Future<bool> update(Map<String, dynamic> values, where) async {
    Database db = await this.getdb();
    int rows = await db
        .update('pessoas', values, where: 'pk_codigo  =? ', whereArgs: [where]);

    return (rows != 0);
  }

  @override
  String get dbname => dbNome;

  @override
  int get dbversion => dbVersion;
}
