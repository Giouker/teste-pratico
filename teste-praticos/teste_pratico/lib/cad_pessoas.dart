import 'package:flutter/material.dart';
import 'package:teste_pratico/app/abstract_pessoas.dart';
import 'package:teste_pratico/main.dart';
import 'package:intl/intl.dart';

class CadPessoas extends StatefulWidget {
  String editNome = '';
  String editSexo = '';
  String editData = '';
  int idade = 0;
  int codigo = 0;
  CadPessoas(
      this.editNome, this.editSexo, this.idade, this.codigo, this.editData);

  @override
  _CadPessoasState createState() => _CadPessoasState();
}

class _CadPessoasState extends State<CadPessoas> {
  TextEditingController nome = TextEditingController();
  TextEditingController idade = TextEditingController();
  TextEditingController date = TextEditingController();
  var _sexos = ['Masculino', 'Feminino', 'Indiferente'];
  var _sexoSelecionado = 'Masculino';
  final df = new DateFormat('dd/MM/yyyy');
  double idadeFormatada;
  var upper;
  DateTime data = DateTime.now();
  final GlobalKey<FormState> _keyNome = GlobalKey<FormState>();
  final GlobalKey<FormState> _keyData = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    //valida se for um update recebe os dados do respectivo registro
    //nos campos da tela de cadastro
    if (widget.codigo != 0) {
      if (nome.text != '') {
      } else {
        nome.text = widget.editNome;
      }

      date.text = widget.editData;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ListPessoas()));
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Cadastro de Pessoas'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _keyNome,
                    child: TextFormField(
                        onFieldSubmitted: (_) {
                          //deixa todas as letras do nome em maiúsculo
                          nome.text = nome.text.toUpperCase();
                        },
                        validator: (value) =>
                            value.isEmpty ? 'Campo requerido' : null,
                        controller: nome,
                        maxLength: 70,
                        decoration: InputDecoration(
                            hintText: 'Nome Completo',
                            hintStyle: TextStyle(color: Colors.grey.shade700))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _keyData,
                    child: TextFormField(
                      validator: (value) =>
                          value.isEmpty ? 'Campo requerido' : null,
                      readOnly: true,
                      onTap: () {
                        date.text = '';
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        ).then((date) {
                          setState(() {
                            //converte a data de aniversario em anos para gerar a idade da pessoa
                            data = date;
                            idade.text = df
                                .format(DateTime.fromMillisecondsSinceEpoch(
                                    data.millisecondsSinceEpoch))
                                .toString();
                            var anos = DateTime.now().difference(data).inDays;
                            idadeFormatada = (anos / 365).truncateToDouble();
                          });
                        });
                      },
                      controller: idade.text != '' ? idade : date,
                      maxLength: 10,
                      decoration: InputDecoration(
                          hintText: 'Data de Nascimento',
                          hintStyle: TextStyle(color: Colors.grey.shade700)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: DropdownButtonFormField<String>(
                    items: _sexos.map((String stringSexo) {
                      return DropdownMenuItem<String>(
                          value: stringSexo,
                          child: Text(
                            stringSexo,
                            style: TextStyle(color: Colors.grey.shade700),
                          ));
                    }).toList(),
                    onChanged: (String sexoSelec) {
                      _dropItem(sexoSelec);
                      setState(() {
                        this._sexoSelecionado = sexoSelec;
                      });
                    },
                    value: widget.editSexo != ''
                        ? widget.editSexo
                        : _sexoSelecionado,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(15)),
                            child: FlatButton(
                                onPressed: () async {
                                  Pessoas listaP = Pessoas();
                                  //valida os campos preenchidos
                                  if (!_keyNome.currentState.validate() ||
                                      !_keyData.currentState.validate()) {
                                  } else {
                                    //verifica se algum campo foi alterado caso não tenha sido
                                    //apenas fecha a tela
                                    if (widget.editNome == nome.text &&
                                        idadeFormatada == null &&
                                        widget.editSexo == _sexoSelecionado) {
                                      Navigator.pop(context);
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ListPessoas()));
                                    } else {
                                      //verifica se é um novo registro ou esta editando um registro ja
                                      //existente
                                      if (widget.codigo != 0) {
                                        await listaP.update({
                                          'nome': nome.text,
                                          'sexo': _sexoSelecionado,
                                          'idade': idadeFormatada != null
                                              ? idadeFormatada.toInt()
                                              : widget.idade,
                                          'data': idade.text != ''
                                              ? idade.text
                                              : widget.editData,
                                        }, widget.codigo);
                                      } else {
                                        await listaP.insert({
                                          'nome': nome.text,
                                          'sexo': _sexoSelecionado,
                                          'idade': idadeFormatada != null
                                              ? idadeFormatada.toInt()
                                              : widget.idade,
                                          'data': idade.text,
                                        });
                                      }
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ListPessoas()));
                                    }
                                  }
                                },
                                child: Text(
                                  'Confirmar',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ))),
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15)),
                            child: FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ListPessoas()));
                                },
                                child: Text(
                                  'Cancelar',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ))),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _dropItem(String sexo) {
    setState(() {
      this._sexoSelecionado = sexo;
    });
  }
}
