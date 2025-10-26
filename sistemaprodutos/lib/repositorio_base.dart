import 'entidade_base.dart';
import 'database_connection.dart';

// Classe abstrata para repositórios - Abstração
abstract class RepositorioBase<T extends EntidadeBase> {
  final DatabaseConnection dbConnection;
  final String tabela;

  RepositorioBase(this.dbConnection, this.tabela);

  // Métodos abstratos que devem ser implementados
  T criarDesdeMap(Map<String, dynamic> map);
  Map<String, dynamic> paraMap(T entidade);

  // Métodos concretos com implementação padrão
  Future<int> inserir(T entidade) async {
    final map = paraMap(entidade);
    map.remove('id'); // Remove ID para auto incremento

    final campos = map.keys.join(', ');
    final valores = List.filled(map.length, '?').join(', ');

    final query = 'INSERT INTO $tabela ($campos) VALUES ($valores)';

    try {
      final resultado =
          await dbConnection.connection!.query(query, map.values.toList());
      return resultado.insertId!;
    } catch (e) {
      print('❌ Erro ao inserir: $e');
      return -1;
    }
  }

  Future<List<T>> listarTodos() async {
    final query = 'SELECT * FROM $tabela ORDER BY id DESC';

    try {
      final resultados = await dbConnection.connection!.query(query);
      return resultados.map((row) => criarDesdeMap(row.fields)).toList();
    } catch (e) {
      print('❌ Erro ao listar: $e');
      return [];
    }
  }

  Future<T?> buscarPorId(int id) async {
    final query = 'SELECT * FROM $tabela WHERE id = ?';

    try {
      final resultados = await dbConnection.connection!.query(query, [id]);
      if (resultados.isNotEmpty) {
        return criarDesdeMap(resultados.first.fields);
      }
      return null;
    } catch (e) {
      print('❌ Erro ao buscar por ID: $e');
      return null;
    }
  }

  Future<bool> atualizar(T entidade) async {
    if (entidade.id == null) return false;

    final map = paraMap(entidade);
    map.remove('id');

    final sets = map.keys.map((key) => '$key = ?').join(', ');
    final valores = [...map.values, entidade.id];

    final query = 'UPDATE $tabela SET $sets WHERE id = ?';

    try {
      final resultado = await dbConnection.connection!.query(query, valores);
      return resultado.affectedRows! > 0;
    } catch (e) {
      print('❌ Erro ao atualizar: $e');
      return false;
    }
  }
}
