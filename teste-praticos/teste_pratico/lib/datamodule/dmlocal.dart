import 'package:sqflite/sqflite.dart';

import 'other.dart';

abstract class AbstractModel {
  Database _db;

  String get dbname;

  int get dbversion;

  Future<Database> init() async {
    if (this._db == null) {
      var databasePath = await getDatabasesPath();
      String path = databasePath + dbname;

      this._db = await openDatabase(path, version: dbversion,
          onCreate: (Database db, int _version) async {
        dbCreate.forEach((String sql) {
          db.execute(sql);
        });
      });
    }
    return this._db;
  }

  Future<Database> getdb() async {
    return await this.init();
  }

  Future<List<Map>> buscaPessoas();
  Future<Map> getPessoas(dynamic where);

  Future<int> insert(Map<String, dynamic> values);

  Future<bool> update(Map<String, dynamic> values, dynamic where);

  Future<bool> delete(dynamic codigo);

  void close() async {
    if (this._db != null) {
      await this._db.close();
      this._db = null;
    }
  }
}
