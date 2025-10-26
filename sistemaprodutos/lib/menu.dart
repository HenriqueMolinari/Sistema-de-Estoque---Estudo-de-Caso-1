import 'dart:io';
import 'produto.dart';
import 'fornecedor.dart';
import 'produto_repositorio.dart';
import 'fornecedor_repositorio.dart';
import 'database_connection.dart';

class Menu {
  final DatabaseConnection dbConnection;
  late final ProdutoRepositorio produtoRepo;
  late final FornecedorRepositorio fornecedorRepo;

  Menu(this.dbConnection) {
    produtoRepo = ProdutoRepositorio(dbConnection);
    fornecedorRepo = FornecedorRepositorio(dbConnection);
  }

  Future<void> iniciar() async {
    while (true) {
      _exibirMenuPrincipal();
      final opcao = _lerOpcao();

      switch (opcao) {
        case 1:
          await _menuProdutos();
          break;
        case 2:
          await _menuFornecedores();
          break;
        case 3:
          print('Saindo do sistema...');
          return;
        default:
          print('Opção inválida!');
      }

      print('\nPressione Enter para continuar...');
      stdin.readLineSync();
    }
  }

  void _exibirMenuPrincipal() {
    print('\n' + '=' * 50);
    print('SISTEMA DE GESTÃO - PRODUTOS E FORNECEDORES');
    print('=' * 50);
    print('1. Menu Produtos');
    print('2. Menu Fornecedores');
    print('3. Sair');
    print('-' * 50);
    stdout.write('Escolha uma opção: ');
  }

  // MENU PRODUTOS
  Future<void> _menuProdutos() async {
    while (true) {
      print('\n' + '=' * 40);
      print('MENU PRODUTOS');
      print('=' * 40);
      print('1. Listar Todos os Produtos');
      print('2. Cadastrar Novo Produto');
      print('3. Buscar Produtos por Categoria');
      print('4. Consultar Estoque Baixo');
      print('5. Atualizar Estoque');
      print('6. Voltar ao Menu Principal');
      print('-' * 40);
      stdout.write('Escolha uma opção: ');

      final opcao = _lerOpcao();

      switch (opcao) {
        case 1:
          await _listarProdutos();
          break;
        case 2:
          await _cadastrarProduto();
          break;
        case 3:
          await _buscarProdutosPorCategoria();
          break;
        case 4:
          await _consultarEstoqueBaixo();
          break;
        case 5:
          await _atualizarEstoque();
          break;
        case 6:
          return;
        default:
          print('Opção inválida!');
      }
    }
  }

  // MENU FORNECEDORES
  Future<void> _menuFornecedores() async {
    while (true) {
      print('\n' + '=' * 40);
      print('MENU FORNECEDORES');
      print('=' * 40);
      print('1. Listar Todos os Fornecedores');
      print('2. Cadastrar Novo Fornecedor');
      print('3. Buscar Fornecedor por CNPJ');
      print('4. Buscar Fornecedor por Nome');
      print('5. Voltar ao Menu Principal');
      print('-' * 40);
      stdout.write('Escolha uma opção: ');

      final opcao = _lerOpcao();

      switch (opcao) {
        case 1:
          await _listarFornecedores();
          break;
        case 2:
          await _cadastrarFornecedor();
          break;
        case 3:
          await _buscarFornecedorPorCnpj();
          break;
        case 4:
          await _buscarFornecedorPorNome();
          break;
        case 5:
          return;
        default:
          print('Opção inválida!');
      }
    }
  }

  int _lerOpcao() {
    try {
      return int.parse(stdin.readLineSync() ?? '0');
    } catch (e) {
      return 0;
    }
  }

  // MÉTODOS PRODUTOS
  Future<void> _listarProdutos() async {
    print('\n--- TODOS OS PRODUTOS ---');
    final produtos = await produtoRepo.listarTodos();

    if (produtos.isEmpty) {
      print('Nenhum produto cadastrado.');
    } else {
      double valorTotal = 0;
      for (var produto in produtos) {
        print(produto.infoBasica);
        valorTotal += produto.valorTotalEstoque;
      }
      print('\n💰 Valor total em estoque: R\$${valorTotal.toStringAsFixed(2)}');
      print('📊 Total de produtos: ${produtos.length}');
    }
  }

  Future<void> _cadastrarProduto() async {
    print('\n--- CADASTRAR NOVO PRODUTO ---');

    try {
      stdout.write('Nome: ');
      final nome = stdin.readLineSync() ?? '';

      stdout.write('Descrição: ');
      final descricao = stdin.readLineSync() ?? '';

      stdout.write('Preço: ');
      final preco = double.parse(stdin.readLineSync() ?? '0');

      stdout.write('Quantidade em Estoque: ');
      final quantidade = int.parse(stdin.readLineSync() ?? '0');

      stdout.write('Categoria: ');
      final categoria = stdin.readLineSync() ?? '';

      final produto = Produto(
          nome: nome,
          descricao: descricao,
          preco: preco,
          quantidadeEstoque: quantidade,
          categoria: categoria);

      final id = await produtoRepo.inserir(produto);

      if (id > 0) {
        print('✅ Produto cadastrado com sucesso! ID: $id');
      } else {
        print('❌ Erro ao cadastrar produto!');
      }
    } catch (e) {
      print('❌ Erro: $e');
    }
  }

  Future<void> _buscarProdutosPorCategoria() async {
    print('\n--- BUSCAR PRODUTOS POR CATEGORIA ---');
    stdout.write('Digite a categoria: ');
    final categoria = stdin.readLineSync() ?? '';

    final produtos = await produtoRepo.buscarPorCategoria(categoria);

    if (produtos.isEmpty) {
      print('Nenhum produto encontrado na categoria "$categoria".');
    } else {
      print('Produtos na categoria "$categoria":');
      for (var produto in produtos) {
        print(produto.infoBasica);
      }
    }
  }

  Future<void> _consultarEstoqueBaixo() async {
    print('\n--- PRODUTOS COM ESTOQUE BAIXO ---');
    stdout.write('Digite o limite de estoque: ');
    final limite = int.parse(stdin.readLineSync() ?? '5');

    final produtos = await produtoRepo.buscarEstoqueBaixo(limite);

    if (produtos.isEmpty) {
      print('Nenhum produto com estoque abaixo de $limite.');
    } else {
      print('Produtos com estoque abaixo de $limite:');
      for (var produto in produtos) {
        print('${produto.infoBasica} | 🔴 Estoque crítico!');
      }
    }
  }

  Future<void> _atualizarEstoque() async {
    print('\n--- ATUALIZAR ESTOQUE ---');
    stdout.write('ID do produto: ');
    final id = int.parse(stdin.readLineSync() ?? '0');

    stdout.write('Nova quantidade: ');
    final quantidade = int.parse(stdin.readLineSync() ?? '0');

    final sucesso = await produtoRepo.atualizarEstoque(id, quantidade);

    if (sucesso) {
      print('✅ Estoque atualizado com sucesso!');
    } else {
      print('❌ Erro ao atualizar estoque!');
    }
  }

  // MÉTODOS FORNECEDORES
  Future<void> _listarFornecedores() async {
    print('\n--- TODOS OS FORNECEDORES ---');
    final fornecedores = await fornecedorRepo.listarTodos();

    if (fornecedores.isEmpty) {
      print('Nenhum fornecedor cadastrado.');
    } else {
      for (var fornecedor in fornecedores) {
        print(fornecedor.infoBasica);
        print('   📞 ${fornecedor.telefone} | 📧 ${fornecedor.email}');
        print('   📍 ${fornecedor.endereco}');
        print('   ---');
      }
      print('📊 Total de fornecedores: ${fornecedores.length}');
    }
  }

  Future<void> _cadastrarFornecedor() async {
    print('\n--- CADASTRAR NOVO FORNECEDOR ---');

    try {
      stdout.write('Nome: ');
      final nome = stdin.readLineSync() ?? '';

      stdout.write('CNPJ: ');
      final cnpj = stdin.readLineSync() ?? '';

      stdout.write('Telefone: ');
      final telefone = stdin.readLineSync() ?? '';

      stdout.write('Email: ');
      final email = stdin.readLineSync() ?? '';

      stdout.write('Endereço: ');
      final endereco = stdin.readLineSync() ?? '';

      final fornecedor = Fornecedor(
          nome: nome,
          cnpj: cnpj,
          telefone: telefone,
          email: email,
          endereco: endereco);

      final id = await fornecedorRepo.inserir(fornecedor);

      if (id > 0) {
        print('✅ Fornecedor cadastrado com sucesso! ID: $id');
      } else {
        print('❌ Erro ao cadastrar fornecedor!');
      }
    } catch (e) {
      print('❌ Erro: $e');
    }
  }

  Future<void> _buscarFornecedorPorCnpj() async {
    print('\n--- BUSCAR FORNECEDOR POR CNPJ ---');
    stdout.write('Digite o CNPJ: ');
    final cnpj = stdin.readLineSync() ?? '';

    final fornecedor = await fornecedorRepo.buscarPorCnpj(cnpj);

    if (fornecedor != null) {
      print('✅ Fornecedor encontrado:');
      print(fornecedor.infoBasica);
      print('   📞 ${fornecedor.telefone}');
      print('   📧 ${fornecedor.email}');
      print('   📍 ${fornecedor.endereco}');
    } else {
      print('❌ Fornecedor não encontrado!');
    }
  }

  Future<void> _buscarFornecedorPorNome() async {
    print('\n--- BUSCAR FORNECEDOR POR NOME ---');
    stdout.write('Digite o nome: ');
    final nome = stdin.readLineSync() ?? '';

    final fornecedores = await fornecedorRepo.buscarPorNome(nome);

    if (fornecedores.isEmpty) {
      print('Nenhum fornecedor encontrado com "$nome".');
    } else {
      print('Fornecedores encontrados:');
      for (var fornecedor in fornecedores) {
        print(fornecedor.infoBasica);
      }
    }
  }
}
