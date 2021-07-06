String dbNome = 'database.db';

int dbVersion = 1;

List<String> dbCreate = [
  """CREATE TABLE pessoas(
    pk_codigo INTEGER PRIMARY KEY,
    nome TEXT,
    idade INTEGER,
    sexo TEXT,
    data TEXT
  )""",
];
