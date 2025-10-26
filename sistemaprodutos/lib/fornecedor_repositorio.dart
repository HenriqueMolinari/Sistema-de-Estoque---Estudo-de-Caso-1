import 'fornecedor.dart';
import 'repositorio_base.dart';
import 'database_connection.dart';

class FornecedorRepositorio extends RepositorioBase<Fornecedor> {
  FornecedorRepositorio(DatabaseConnection dbConnection)
      : super(dbConnection, 'fornecedores');

  @override
  Fornecedor criarDesdeMap(Map<String, dynamic> map) {
    return Fornecedor.fromMap(map);
  }

  @override
  Map<String, dynamic> paraMap(Fornecedor fornecedor) {
    return fornecedor.toMap();
  }

  // Métodos específicos para fornecedores
  Future<Fornecedor?> buscarPorCnpj(String cnpj) async {
    final query = 'SELECT * FROM fornecedores WHERE cnpj = ?';

    try {
      final resultados = await dbConnection.connection!.query(query, [cnpj]);
      if (resultados.isNotEmpty) {
        return criarDesdeMap(resultados.first.fields);
      }
      return null;
    } catch (e) {
      print('❌ Erro ao buscar por CNPJ: $e');
      return null;
    }
  }

  Future<List<Fornecedor>> buscarPorNome(String nome) async {
    final query =
        'SELECT * FROM fornecedores WHERE nome LIKE ? ORDER BY nome ASC';

    try {
      final resultados =
          await dbConnection.connection!.query(query, ['%$nome%']);
      return resultados.map((row) => criarDesdeMap(row.fields)).toList();
    } catch (e) {
      print('❌ Erro ao buscar por nome: $e');
      return [];
    }
  }
}
