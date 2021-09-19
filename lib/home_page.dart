import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'class/lista_class.dart';
import 'listagem_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _edNome = TextEditingController();
  var _edParcelas = TextEditingController();
  var _edTaxaDeJuros = TextEditingController();
  var _edValorDoEmprestimo = TextEditingController();
  String _resultado = "";
  double resultadoFinal = 0;
  double valorMensalEprestimo = 0;
  final _formKey = GlobalKey<FormState>(); //key para validação
  String _confirmacao = "";
  final fieldText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //definição do estilo dos botões

    return Scaffold(
        appBar: AppBar(
          title: Text("Simulador de Empréstimo"),
        ),
        body: _body(context),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Add your onPressed code here!
            print("Salvar simulação de emprestimo!");
            _addSimulacao(context);
            setState(() {
              _confirmacao = "Simulação Salva!";
            });
          },
          label: const Text('Salvar Simulação'),
          icon: const Icon(Icons.thumb_up),
          backgroundColor: Colors.blue,
        ));
  }

  Column _body(context) {
    return Column(
      children: <Widget>[
        _imagem(),
        _form(),
        //_listagem(context),
      ],
    );
  }

  Column _imagem() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Image.asset(
          'images/calculadora.jpg',
          height: 170,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Entre com seus dados!",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        )
      ],
    );
  }

  final ButtonStyle style = ElevatedButton.styleFrom(
      primary: Colors.green[900],
      padding: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 10,
      ),
      textStyle: const TextStyle(
        fontSize: 20,
      ));

  Container _form() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Form(
        // padding: EdgeInsets.all(16),
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, entre com seu nome';
                }
                return null;
              },
              controller: _edNome,
              keyboardType: TextInputType.name,
              style: const TextStyle(
                fontSize: 20,
              ),
              decoration: const InputDecoration(
                  icon: Icon(Icons.person_add), labelText: "Nome"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 70,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite Nº de parcelas';
                      }
                      return null;
                    },
                    controller: _edParcelas,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                        icon: Icon(Icons.calculate),
                        labelText: "Nº de Parcelas"),
                  ),
                ),
                Expanded(
                  flex: 70,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite Taxa de Juros';
                      }
                      return null;
                    },
                    controller: _edTaxaDeJuros,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                        icon: Icon(Icons
                            .show_chart), // material icon named "query stats sharp".   trending up rounded
                        labelText: "Taxa de Juros"),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Digite o valor do empréstimo';
                }
                return null;
              },
              controller: _edValorDoEmprestimo,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 20,
              ),
              decoration: const InputDecoration(
                icon: Icon(Icons.vertical_split),
                labelText: 'Valor do Emprestimo',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: style,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        //print("Calcular");
                        double parcelas = double.parse(_edParcelas.text);
                        double taxaDeJuros = double.parse(_edTaxaDeJuros.text);
                        double valorDoEmprestimo =
                            double.parse(_edValorDoEmprestimo.text);

                        //Juros simples
                        //M = P (1+* i * t)
                        resultadoFinal = valorDoEmprestimo *
                            (1 + (taxaDeJuros / 100) * parcelas);

                        valorMensalEprestimo = resultadoFinal / parcelas;  

                        setState(() {
                          _resultado =
                              "${_edNome.text} o total do empréstimo é: ${NumberFormat.simpleCurrency(locale: "pt_BR").format(resultadoFinal)}\nPagando ${NumberFormat.simpleCurrency(locale: "pt_BR").format(valorMensalEprestimo)} por $parcelas meses";
                        });
                      }
                    },
                    child: const Text("Calcular"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: style,
                    onPressed: () {
                      print("Listar Simulações");

                      mostrarSimulacoes(context);
                    },
                    child: const Text("Listar"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: style,
                    onPressed: () {
                      print("Nova Sim");
                      setState(() {
                        _resultado = "";
                        _confirmacao = "";
                        _edNome.clear();
                        _edParcelas.clear();
                        _edTaxaDeJuros.clear();
                        _edValorDoEmprestimo.clear();
                      });
                    },
                    child: const Text("Nova "),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              _resultado,
              style: TextStyle(
                // color: Colors.green,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              _confirmacao,
              style: TextStyle(
                color: Colors.green[900],
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //SALVANDO DADOS
  List _simulacoes = [];

  void _addSimulacao(BuildContext context) {
    double valorDoEmprestimo = double.parse(_edValorDoEmprestimo.text);

    String simulacao =
        "Nome: ${_edNome.text}\nEmpréstimo: ${NumberFormat.simpleCurrency(locale: "pt_BR").format(valorDoEmprestimo)}\nTaxa de Juros: ${_edTaxaDeJuros.text}%  -  Nº de Parcelas: ${_edParcelas.text}\nValor da Parcela: ${NumberFormat.simpleCurrency(locale: "pt_BR").format(valorMensalEprestimo)}\nValor total: ${NumberFormat.simpleCurrency(locale: "pt_BR").format(resultadoFinal)}";
    var novaSim = new Map();
    novaSim["simulacao"] = simulacao;
    novaSim["ok"] = false;
    setState(() {
      _simulacoes.add(novaSim);
    });
  }

  // LISTANDO DADOS

  Expanded _listagem(context) {
    return Expanded(
      child: ListView.builder(
        itemCount: _simulacoes.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(_simulacoes[index]["simulacao"]),
            value: _simulacoes[index]["ok"],
            onChanged: (bool? value) {
              setState(() {
                _simulacoes[index]["ok"] = value;
              });
              // _saveData();
            },
          );
        },
      ),
    );
  }

  void clearText() {
    fieldText.clear();
  }

  void reset() {
    _formKey.currentState!.reset();
  }

  //chamada para outra página contendo a lista de simulações
  void mostrarSimulacoes(BuildContext context) {
    Navigator.push(
      context, //paramentro que deve ser passodo por todos o métodos
      MaterialPageRoute(
        builder: (context) => ListagemSimulacoes(
          totalSims: _simulacoes,
        ),
      ),
    );
  }
}
