import 'package:flutter/material.dart';
import 'package:flutter_piapp/telas/contact_details_screen.dart';
import 'package:flutter_piapp/telas/add_contact_screen.dart';
import 'package:flutter_piapp/telas/edit_contact_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_piapp/db/database_manager.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  List<Map<String, String>> _usuarios = []; // Lista de contatos carregados do banco

  @override
  void initState() { // Inicializa o estado do widget ao ser carregado
    super.initState();
    _loadUsuarios(); // Carrega os contatos do banco de dados
  }

  // Função para carregar os contatos do banco de dados
  void _loadUsuarios() async {
    final List<Map<String, dynamic>> usuariosDb = await DBHelper.getAllContacts(); // Busca contatos do banco
    setState(() {
      _usuarios = usuariosDb
          .map((usuario) => {
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
      _loadUsuarios();
    }
  }

  // Função para remover um contato
  void _removerUsuario(int index) async {
    final usuario = _usuarios[index];
    final id = int.parse(usuario['id']!);
    await DBHelper.deleteContact(id); // Remove o contato do banco
    _loadUsuarios();
  }

  // Função para editar um contato
  void _editarUsuario(int index, String nome, String telefone, String email) async {
    final usuario = _usuarios[index];
    final id = int.parse(usuario['id']!);
    await DBHelper.updateContact(id, nome, telefone, email); // Atualiza o contato no banco
    _loadUsuarios();
  }

  @override
  Widget build(BuildContext context) { // Define a interface de usuário
    return Scaffold(
      appBar: AppBar( // Barra superior da aplicação
        title: Row(
          children: [
            SvgPicture.asset( // Exibindo a logo em SVG
              'assets/images/puc-goias.svg',
              height: 32, // Definindo a altura do logo
            ),
            const SizedBox(width: 10), // Espaço entre o logo e o texto
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
      body: _usuarios.isEmpty // Verifica se há contatos
          ? const Center(child: Text('Nenhuma pessoa adicionada.')) // Mensagem quando a lista está vazia
          : ListView.builder(
        itemCount: _usuarios.length, // Número de itens na lista
        itemBuilder: (context, index) { // Constrói cada item
          final usuario = _usuarios[index]; // Contato atual
          return ListTile(
            title: Text(usuario['nome']!), // Nome do contato
            onTap: () async { // Ação ao tocar no item
              if (!mounted) return; // Verifica se o widget está montado

              // Mostra opções ao usuário
              final action = await showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('O que você gostaria de fazer?'), // Título do diálogo
                    actions: <Widget>[
                      TextButton( // Botão para visualizar detalhes
                        onPressed: () {
                          Navigator.pop(context, 'Detalhes'); // Fecha o diálogo com "Detalhes"
                        },
                        child: const Text('Visualizar Detalhes'),
                      ),
                      TextButton( // Botão para editar
                        onPressed: () {
                          Navigator.pop(context, 'Editar'); // Fecha o diálogo com "Editar"
                        },
                        child: const Text('Editar'),
                      ),
                      TextButton( // Botão para excluir
                        onPressed: () {
                          Navigator.pop(context, 'Excluir'); // Fecha o diálogo com "Excluir"
                        },
                        child: const Text('Excluir'),
                      ),
                    ],
                  );
                },
              );

              if (action == 'Detalhes') { // Caso o usuário escolha "Detalhes"
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
              } else if (action == 'Editar') { // Caso escolha "Editar"
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

                if (editedUser != null) { // Se houver alterações, atualiza o contato
                  _editarUsuario(index, editedUser['nome'], editedUser['telefone'], editedUser['email']);
                }
              } else if (action == 'Excluir') { // Caso escolha "Excluir"
                _removerUsuario(index); // Remove o contato
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton( // Botão flutuante para adicionar contatos
        onPressed: () async {
          if (!mounted) return; // Verifica se o widget está montado

          final novoUsuario = await Navigator.push( // Navega para a tela de adicionar contato
            context,
            MaterialPageRoute(
              builder: (context) => const AdicionarTela(),
            ),
          );

          if (!mounted) return;

          if (novoUsuario != null) { // Caso receba um novo contato, adiciona
            _adicionarUsuario(
              novoUsuario['nome'],
              novoUsuario['telefone'],
              novoUsuario['email'],
            );
          }
        },
        child: const Icon(Icons.add), // Ícone do botão
      ),
    );
  }
}
