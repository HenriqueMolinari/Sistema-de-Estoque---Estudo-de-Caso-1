/*

Autor: Henrique de O. Molinari

RA: 25001176

Cole no terminal:  dart run .\bin\main.dart

*/

import 'package:sistemaprodutos/database_config.dart';
import 'package:sistemaprodutos/database_connection.dart';
import 'package:sistemaprodutos/menu.dart';

void main() async {
  print('🚀 Iniciando Sistema de Gestão de Produtos e Fornecedores...');

  final config = DatabaseConfig(
    host: 'localhost',
    port: 3306,
    user: 'root',
    password: '@#Hrk15072006',
    dbName: 'sistema_gestao',
  );

  final db = DatabaseConnection(config);
  bool conectado = await db.connect();

  if (conectado) {
    final menu = Menu(db);
    await menu.iniciar();
    await db.close();
  } else {
    print('❌ Encerrando a aplicação por erro de conexão');
  }
}
