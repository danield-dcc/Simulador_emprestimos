import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simulador_emprestimo/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulador de Empréstimo',
      home: HomePage(),
    );
  }
}