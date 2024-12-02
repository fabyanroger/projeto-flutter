import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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

  // Máscara para o campo de telefone (formato: (XX) XXXXX-XXXX)
  var telefoneMask = MaskTextInputFormatter(mask: "(##) #####-####", filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    super.initState();
    // Se houver dados de contato (para edição), preenche os campos
    if (widget.nome != null) _nomeController.text = widget.nome!;
    if (widget.telefone != null) _telefoneController.text = widget.telefone!;
    if (widget.email != null) _emailController.text = widget.email!;
  }

  void _salvar() {
    // Verifica se nome, telefone e email não estão vazios
    if (_nomeController.text.isNotEmpty && _telefoneController.text.isNotEmpty && _emailController.text.isNotEmpty) {
      // Salva as informações e retorna para a tela anterior
      Navigator.pop(context, {
        'nome': _nomeController.text,
        'telefone': _telefoneController.text,
        'email': _emailController.text,
      });

      // Exibe uma notificação de sucesso
      ScaffoldMessenger.of(context).clearSnackBars(); // Remove qualquer SnackBar anterior
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contato salvo com sucesso!'),
          backgroundColor: Colors.green, // Cor verde para sucesso
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Exibe uma notificação de erro caso algum campo não esteja preenchido
      ScaffoldMessenger.of(context).clearSnackBars(); // Remove qualquer SnackBar anterior
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nome, telefone e e-mail são obrigatórios'),
          backgroundColor: Colors.red, // Cor vermelha para erro
          duration: Duration(seconds: 2),
        ),
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
            // Campo de Telefone com máscara
            TextField(
              controller: _telefoneController,
              decoration: const InputDecoration(labelText: 'Telefone'),
              keyboardType: TextInputType.phone,
              inputFormatters: [telefoneMask], // Aplica a máscara
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
