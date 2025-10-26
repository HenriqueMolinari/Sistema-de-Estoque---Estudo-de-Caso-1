import 'produto.dart';
import 'repositorio_base.dart';
import 'database_connection.dart';

class ProdutoRepositorio extends RepositorioBase<Produto> {
  ProdutoRepositorio(DatabaseConnection dbConnection)
      : super(dbConnection, 'produtos');

  @override
  Produto criarDesdeMap(Map<String, dynamic> map) {
    return Produto.fromMap(map);
  }

  @override
  Map<String, dynamic> paraMap(Produto produto) {
    return produto.toMap();
  }

  // Métodos específicos para produtos
  Future<List<Produto>> buscarPorCategoria(String categoria) async {
    final query =
        'SELECT * FROM produtos WHERE categoria LIKE ? ORDER BY preco DESC';

    try {
      final resultados =
          await dbConnection.connection!.query(query, ['%$categoria%']);
      return resultados.map((row) => criarDesdeMap(row.fields)).toList();
    } catch (e) {
      print('❌ Erro ao buscar por categoria: $e');
      return [];
    }
  }

  Future<List<Produto>> buscarEstoqueBaixo(int limite) async {
    final query =
        'SELECT * FROM produtos WHERE quantidade_estoque <= ? AND ativo = true ORDER BY quantidade_estoque ASC';

    try {
      final resultados = await dbConnection.connection!.query(query, [limite]);
      return resultados.map((row) => criarDesdeMap(row.fields)).toList();
    } catch (e) {
      print('❌ Erro ao buscar estoque baixo: $e');
      return [];
    }
  }

  Future<bool> atualizarEstoque(int id, int novaQuantidade) async {
    final query = 'UPDATE produtos SET quantidade_estoque = ? WHERE id = ?';

    try {
      final resultado =
          await dbConnection.connection!.query(query, [novaQuantidade, id]);
      return resultado.affectedRows! > 0;
    } catch (e) {
      print('❌ Erro ao atualizar estoque: $e');
      return false;
    }
  }
}
