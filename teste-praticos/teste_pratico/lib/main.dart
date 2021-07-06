import 'package:flutter/material.dart';
import 'package:teste_pratico/app/abstract_pessoas.dart';

import 'cad_pessoas.dart';

void main() {
  runApp(MaterialApp(
    home: ListPessoas(),
  ));
}

class ListPessoas extends StatefulWidget {
  const ListPessoas({Key key}) : super(key: key);

  @override
  _ListPessoasState createState() => _ListPessoasState();
}

class _ListPessoasState extends State<ListPessoas> {
  String _edtiNome = '';
  String _editSexo = '';
  int _idade = 0;
  String _data = '';
  int _codPessoa = 0;
  Pessoas listaP = Pessoas();
  @override
  Widget build(BuildContext context) {
    Pessoas.getInstance();

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text('Avaliação Pratica'),
      ),
      body: FutureBuilder(
        future: listaP.buscaPessoas(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: Text('Carregando ...'),
              );
            default:
              if (snapshot.hasError) {
                print(snapshot.error);
                return Text('Erro: ${snapshot.error}');
              } else {
                List<Map> listas = snapshot.data;

                if (listas.length == 0) {
                  return ListView(
                    children: [
                      ListTile(
                        leading: Icon(Icons.people),
                        title: Text('Nenhuma pessoa cadastrada'),
                      )
                    ],
                  );
                } else {
                  return ListView.builder(
                    itemCount: listas.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Map pessoa = listas[index];
                      return FlatButton(
                        onPressed: () {
                          showAlertDialog(context);
                          _edtiNome = pessoa['nome'];
                          _editSexo = pessoa['sexo'];
                          _idade = pessoa['idade'];
                          _codPessoa = pessoa['pk_codigo'];
                          _data = pessoa['data'];
                        },
                        child: ListTile(
                          title: Text(pessoa['nome'] ?? ''),
                          subtitle: Text(pessoa['idade' ?? 0].toString()),
                        ),
                      );
                    },
                  );
                }
              }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CadPessoas(_edtiNome, _editSexo, _idade, _codPessoa, _data),
            ),
          );
        },
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget btnEditar = FlatButton(
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CadPessoas(
                    _edtiNome, _editSexo, _idade, _codPessoa, _data)));
      },
      child: Text('Editar'),
    );
    Widget btnRemover = FlatButton(
      onPressed: () {
        Navigator.pop(context);
        showAlertDialogD(context);
      },
      child: Text('Remover'),
    );
    AlertDialog alert = AlertDialog(
      title: Text('Opções'),
      content: Text('Excluir ou editar registro ?'),
      actions: [
        btnEditar,
        btnRemover,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogD(BuildContext context) {
    Widget btnNao = FlatButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text('Não'),
    );
    Widget btnSim = FlatButton(
      onPressed: () async {
        await Pessoas.getInstance().delete(_codPessoa);
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ListPessoas()));
      },
      child: Text('Sim'),
    );
    AlertDialog alert = AlertDialog(
      title: Text('Excluir'),
      content: Text('Deseja excluir esse registro ?'),
      actions: [
        btnNao,
        btnSim,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
