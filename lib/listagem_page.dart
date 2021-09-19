import 'package:flutter/material.dart';

import 'home_page.dart';

class ListagemSimulacoes extends StatefulWidget {
  // In the constructor, require a Todo.
  const ListagemSimulacoes({Key? key, required this.totalSims})
      : super(key: key);

  // Declare a field that holds the Todo.
  final List totalSims;

  @override
  _ListagemSimulacoesState createState() => _ListagemSimulacoesState();
}

class _ListagemSimulacoesState extends State<ListagemSimulacoes> {
  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text("Listando Simulações"),
      ),
      body: _body(context),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: _showMaterialDialog,
          tooltip: 'Remover todos os itens da lista',
          child: const Icon(Icons.delete_sweep)),
    );
  }

  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Exclusão da Lista'),
            content: Text('Confirma a exclusão de todos os itens da lista?'),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.totalSims.clear();
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Sim')),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Não!'),
              )
            ],
          );
        });
  }

  Column _body(context) {
    return Column(
      children: <Widget>[
        _listagem(context),
      ],
    );
  }

  Expanded _listagem(context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.totalSims.length,
        itemBuilder: (context, index) {
          // return ListTile(
          //   leading: Icon(Icons.ac_unit_sharp),
          //   title: Text(totalSims[index]["simulacao"]),
          // );
          return Card(
            child: ListTile(
              leading: Icon(Icons.attach_money),
              title: Text(widget.totalSims[index]["simulacao"]),
            ),);
        },
      ),
    );
  }
}




//         {
//           return CheckboxListTile(
//             title: Text(totalSims[index]["simulacao"]),

//             value: totalSims[index]["ok"],

//             onChanged: (bool? value) {
//               setState(() {
//                 totalSims[index]["ok"] = value;
//               });
//               // _saveData();
//             },
//           );
//         },