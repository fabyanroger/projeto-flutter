import 'package:flutter/material.dart';
import 'package:lista_puc_go/telas/contact_details_screen.dart';
import 'package:lista_puc_go/telas/add_contact_screen.dart';
import 'package:lista_puc_go/telas/edit_contact_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lista_puc_go/db/database_manager.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  List<Map<String, String>> _usuarios = []; // Lista de contatos carregados do banco

  @override
  void initState() {
    super.initState();
    _loadUsuarios(); // Carrega os contatos do banco de dados
  }

  // Função para carregar os contatos do banco de dados
  void _loadUsuarios() async {
    final List<Map<String, dynamic>> usuariosDb = await DBHelper.getAllContacts(); // Busca contatos do banco
    setState(() {
      _usuarios = usuariosDb.map((usuario) => {
        'id': usuario['id'].toString(),
        'nome': usuario['nome'].toString(),
        'telefone': usuario['telefone'].toString(),
        'email': usuario['email'].toString(),
      }).toList();
    });
  }

  // Função para adicionar um novo contato
  void _adicionarUsuario(String nome, String telefone, String email) async {
    final id = await DBHelper.insert(nome, telefone, email); // Insere o contato no banco
    if (id != -1) {
      _loadUsuarios(); // Atualiza a lista de contatos

      // Exibe uma notificação para o usuário
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars(); // Limpa qualquer snack bar anterior
        ScaffoldMessenger.of(context).showSnackBar( // Exibe o SnackBar
          SnackBar(
            content: Text(
              'Contato $nome adicionado com sucesso!',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green, // Notificação na cor verde
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Função para remover um contato
  void _removerUsuario(int index) async {
    final usuario = _usuarios[index];
    final id = int.parse(usuario['id']!);
    await DBHelper.deleteContact(id); // Remove o contato do banco
    _loadUsuarios(); // Atualiza a lista de contatos

    // Exibe uma notificação com fundo vermelho
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Contato ${usuario['nome']} removido com sucesso!',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Função para editar um contato
  void _editarUsuario(int index, String nome, String telefone, String email) async {
    final usuario = _usuarios[index];
    final id = int.parse(usuario['id']!);
    await DBHelper.updateContact(id, nome, telefone, email); // Atualiza o contato no banco
    _loadUsuarios(); // Atualiza a lista de contatos

    // Exibe uma notificação com fundo verde
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Contato ${usuario['nome']} atualizado com sucesso!',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/images/puc-goias.svg',
              height: 32,
            ),
            const SizedBox(width: 10),
            const Text(
              'Lista de Pessoas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: _usuarios.isEmpty
          ? const Center(child: Text('Nenhuma pessoa adicionada.'))
          : ListView.builder(
        itemCount: _usuarios.length,
        itemBuilder: (context, index) {
          // Ordena os usuários por nome (alfabética)
          _usuarios.sort((a, b) => a['nome']!.compareTo(b['nome']!)); // Ordenação alfabética

          final usuario = _usuarios[index];
          final isEven = index % 2 == 0;

          return Container(
            color: isEven ? Colors.white : Colors.grey[100],
            child: ListTile(
              title: Text(usuario['nome']!),
              onTap: () async {
                if (!mounted) return;

                final action = await showModalBottomSheet<String>(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Contato: ${usuario['nome']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListTile(
                            leading: const Icon(Icons.info_outline, color: Colors.blue),
                            title: const Text('Visualizar Detalhes'),
                            onTap: () => Navigator.pop(context, 'Detalhes'),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.edit, color: Colors.orange),
                            title: const Text('Editar'),
                            onTap: () => Navigator.pop(context, 'Editar'),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.delete, color: Colors.red),
                            title: const Text('Excluir'),
                            onTap: () => Navigator.pop(context, 'Excluir'),
                          ),
                        ],
                      ),
                    );
                  },
                );

                // Ações baseadas na escolha do usuário
                if (action == 'Detalhes') {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetalhesTela(
                        nome: usuario['nome']!,
                        telefone: usuario['telefone']!,
                        email: usuario['email']!,
                      ),
                    ),
                  );
                } else if (action == 'Editar') {
                  final editedUser = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditarTela(
                        nome: usuario['nome']!,
                        telefone: usuario['telefone']!,
                        email: usuario['email']!,
                      ),
                    ),
                  );

                  if (editedUser != null) {
                    _editarUsuario(index, editedUser['nome'], editedUser['telefone'], editedUser['email']);
                  }
                } else if (action == 'Excluir') {
                  _removerUsuario(index);
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!mounted) return;

          final novoUsuario = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdicionarTela(),
            ),
          );

          if (novoUsuario != null) {
            _adicionarUsuario(novoUsuario['nome'], novoUsuario['telefone'], novoUsuario['email']);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
