import 'package:flutter/material.dart';

class DetalhesTela extends StatelessWidget {
  final String nome;
  final String telefone;
  final String email;

  const DetalhesTela({super.key, required this.nome, required this.telefone, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Pessoa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: $nome', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Telefone: $telefone', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('E-mail: $email', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Apenas fecha a tela
              },
              child: const Text('Fechar'),
            ),
          ],
        ),
      ),
    );
  }
}
