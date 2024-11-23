import 'package:flutter/material.dart';

class AdicionarTela extends StatefulWidget {
  final String? nome;
  final String? telefone;
  final String? email;

  const AdicionarTela({super.key, this.nome, this.telefone, this.email});

  @override
  State<AdicionarTela> createState() => _AdicionarTelaState();
}

class _AdicionarTelaState extends State<AdicionarTela> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Se houver dados de contato (para edição), preenche os campos
    if (widget.nome != null) _nomeController.text = widget.nome!;
    if (widget.telefone != null) _telefoneController.text = widget.telefone!;
    if (widget.email != null) _emailController.text = widget.email!;
  }

  void _salvar() {
    // Verifica se nome e telefone não estão vazios
    if (_nomeController.text.isNotEmpty && _telefoneController.text.isNotEmpty && _emailController.text.isNotEmpty) {
      Navigator.pop(context, {
        'nome': _nomeController.text,
        'telefone': _telefoneController.text,
        'email': _emailController.text,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nome, telefone e e-mail são obrigatórios')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar'),
      ),
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
              keyboardType: TextInputType.emailAddress,
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
