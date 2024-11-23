import 'package:sqflite/sqflite.dart'; // SQLite para Flutter
import 'package:path/path.dart';
import 'package:logger/logger.dart'; // Para logs e depuração

final logger = Logger();

class DBHelper {
  static const String _dbName = 'app_database.db'; // Nome do banco.
  static const int _dbVersion = 1;
  static const String _tableName = 'contacts';

  // Singleton do banco de dados
  static Database? _database;

  // Retorna a instância única do banco
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  // Metodo para inicializar o banco de dados
  static Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    // Abre ou cria o banco de dados
    final db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        // Criação da tabela.
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            telefone TEXT NOT NULL,
            email TEXT NOT NULL
          )
        ''');
        logger.d("Tabela $_tableName criada com sucesso!"); // Log.
      },
    );

    return db;
  }

  // Metodo para inserir dados
  static Future<int> insert(String nome, String telefone, String email) async {
    try {
      final db = await database; // Usa a instância Singleton

      if (nome.isEmpty || telefone.isEmpty || email.isEmpty) {
        throw Exception("Erro: Todos os campos são obrigatórios!");
      }

      final id = await db.insert(_tableName, {
        'nome': nome,
        'telefone': telefone,
        'email': email,
      });

      logger.d("Contato inserido com ID: $id");
      return id;
    } catch (e) {
      logger.e("Erro ao inserir dados: $e");
      return -1;
    }
  }

  // Metodo para buscar todos os contatos
  static Future<List<Map<String, dynamic>>> getAllContacts() async {
    try {
      final db = await database; // Usa a instância Singleton
      final contacts = await db.query(_tableName); // Busca todos os contatos
      logger.d("Contatos recuperados: $contacts");

      if (contacts.isEmpty) {
        logger.d("Nenhum contato encontrado.");
      }

      return contacts;
    } catch (e) {
      logger.e("Erro ao buscar contatos: $e");
      return [];
    }
  }

  // Metodo para atualizar um contato
  static Future<int> updateContact(int id, String nome, String telefone, String email) async {
    try {
      final db = await database; // Usa a instância Singleton

      if (nome.isEmpty || telefone.isEmpty || email.isEmpty) {
        logger.d("Erro: Dados incompletos!");
        return -1;
      }

      final rows = await db.update(
        _tableName,
        {
          'nome': nome,
          'telefone': telefone,
          'email': email,
        },
        where: 'id = ?',
        whereArgs: [id],
      );

      logger.d("Contato atualizado: $rows registros afetados.");
      return rows;
    } catch (e) {
      logger.e("Erro ao atualizar contato: $e");
      return -1;
    }
  }

  // Metodo para deletar um contato
  static Future<int> deleteContact(int id) async {
    try {
      final db = await database; // Usa a instância Singleton

      final rows = await db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );

      logger.d("Contato deletado: $rows registros afetados.");
      return rows;
    } catch (e) {
      logger.e("Erro ao deletar contato: $e");
      return -1;
    }
  }
}
