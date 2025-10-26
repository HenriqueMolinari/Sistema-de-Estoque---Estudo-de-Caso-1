import 'dart:convert';
import 'entidade_base.dart';
import 'package:mysql1/mysql1.dart';

class Produto extends EntidadeBase {
  String _nome;
  String _descricao;
  double _preco;
  int _quantidadeEstoque;
  String _categoria;
  bool _ativo;

  Produto(
      {int? id,
      required String nome,
      required String descricao,
      required double preco,
      required int quantidadeEstoque,
      required String categoria,
      bool ativo = true,
      DateTime? dataCriacao})
      : _nome = nome,
        _descricao = descricao,
        _preco = preco,
        _quantidadeEstoque = quantidadeEstoque,
        _categoria = categoria,
        _ativo = ativo,
        super(id: id, dataCriacao: dataCriacao);

  // Getters - Encapsulamento
  String get nome => _nome;
  String get descricao => _descricao;
  double get preco => _preco;
  int get quantidadeEstoque => _quantidadeEstoque;
  String get categoria => _categoria;
  bool get ativo => _ativo;

  // Setters com validação - Encapsulamento
  set nome(String novoNome) {
    if (novoNome.length < 2) {
      throw ArgumentError('Nome deve ter pelo menos 2 caracteres');
    }
    _nome = novoNome;
  }

  set descricao(String novaDescricao) {
    _descricao = novaDescricao;
  }

  set preco(double novoPreco) {
    if (novoPreco < 0) {
      throw ArgumentError('Preço não pode ser negativo');
    }
    _preco = novoPreco;
  }

  set quantidadeEstoque(int novaQuantidade) {
    if (novaQuantidade < 0) {
      throw ArgumentError('Quantidade em estoque não pode ser negativa');
    }
    _quantidadeEstoque = novaQuantidade;
  }

  set categoria(String novaCategoria) {
    if (novaCategoria.isEmpty) {
      throw ArgumentError('Categoria não pode ser vazia');
    }
    _categoria = novaCategoria;
  }

  set ativo(bool novoStatus) {
    _ativo = novoStatus;
  }

  // Método de negócio
  double get valorTotalEstoque => _preco * _quantidadeEstoque;

  bool get temEstoque => _quantidadeEstoque > 0;

  // Implementação do método abstrato - Polimorfismo
  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': _nome,
      'descricao': _descricao,
      'preco': _preco,
      'quantidade_estoque': _quantidadeEstoque,
      'categoria': _categoria,
      'ativo': _ativo,
      'data_criacao': dataCriacao.toString()
    };
  }

  // Sobrescrita de método - Polimorfismo
  @override
  String get infoBasica {
    return '${super.infoBasica} | ${_nome} | R\$${_preco.toStringAsFixed(2)} | Estoque: $_quantidadeEstoque';
  }

  // Método estático para criar objeto a partir de map - CORRIGIDO
  static Produto fromMap(Map<String, dynamic> map) {
    // Converter Blob para String se necessário
    String descricao = '';
    if (map['descricao'] != null) {
      if (map['descricao'] is Blob) {
        descricao = utf8.decode((map['descricao'] as Blob).toBytes());
      } else {
        descricao = map['descricao'].toString();
      }
    }

    // Converter outros campos
    double preco = 0.0;
    if (map['preco'] != null) {
      if (map['preco'] is String) {
        preco = double.parse(map['preco']);
      } else if (map['preco'] is int) {
        preco = (map['preco'] as int).toDouble();
      } else {
        preco = map['preco'].toDouble();
      }
    }

    int quantidadeEstoque = 0;
    if (map['quantidade_estoque'] != null) {
      if (map['quantidade_estoque'] is String) {
        quantidadeEstoque = int.parse(map['quantidade_estoque']);
      } else {
        quantidadeEstoque = map['quantidade_estoque'] as int;
      }
    }

    bool ativo = true;
    if (map['ativo'] != null) {
      if (map['ativo'] is int) {
        ativo = map['ativo'] == 1;
      } else if (map['ativo'] is String) {
        ativo = map['ativo'] == '1';
      } else {
        ativo = map['ativo'] as bool;
      }
    }

    DateTime? dataCriacao;
    if (map['data_criacao'] != null) {
      if (map['data_criacao'] is DateTime) {
        dataCriacao = map['data_criacao'] as DateTime;
      } else {
        dataCriacao = DateTime.parse(map['data_criacao'].toString());
      }
    }

    return Produto(
        id: map['id'] as int?,
        nome: map['nome'].toString(),
        descricao: descricao,
        preco: preco,
        quantidadeEstoque: quantidadeEstoque,
        categoria: map['categoria'].toString(),
        ativo: ativo,
        dataCriacao: dataCriacao);
  }
}
