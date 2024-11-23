import 'package:flutter/material.dart';

class EditarTela extends StatefulWidget {
  final String nome;
  final String telefone;
  final String email;

  const EditarTela({
    super.key,
    required this.nome,
    required this.telefone,
    required this.email,
  });

  @override
  EditarTelaState createState() => EditarTelaState();
}

class EditarTelaState extends State<EditarTela> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nomeController.text = widget.nome;
    _telefoneController.text = widget.telefone;
    _emailController.text = widget.email;
  }

  void _salvar() {
    final nome = _nomeController.text;
    final telefone = _telefoneController.text;
    final email = _emailController.text;

    if (nome.isNotEmpty && telefone.isNotEmpty && email.isNotEmpty) {
      Navigator.pop(context, {'nome': nome, 'telefone': telefone, 'email': email});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Contato')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _telefoneController,
              decoration: const InputDecoration(labelText: 'Telefone'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvar,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
