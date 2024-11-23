import 'package:flutter/material.dart'; // Importa o pacote de Material Design do Flutter, que fornece componentes e widgets para criar interfaces com o usuário.
import 'package:flutter_piapp/telas/ContactListScreen.dart';

import 'db/DatabaseManager.dart'; // Importa a tela de lista de contatos que provavelmente será a tela principal do app.

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Necessário para chamadas assíncronas antes do runApp.
  await DBHelper.database; // Inicializa o banco de dados.
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove a faixa de debug
      title: 'SQLite Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TelaInicial(),
    );
  }
}
