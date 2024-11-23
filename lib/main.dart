import 'package:flutter/material.dart';
import 'package:flutter_piapp/telas/contact_list_screen.dart';
import 'db/database_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.database; // Inicializando o banco de dados.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removendo a faixa de debug
      title: 'SQLite Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TelaInicial(),
    );
  }
}
