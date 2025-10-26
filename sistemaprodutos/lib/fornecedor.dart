import 'dart:convert';
import 'entidade_base.dart';
import 'package:mysql1/mysql1.dart';

class Fornecedor extends EntidadeBase {
  String _nome;
  String _cnpj;
  String _telefone;
  String _email;
  String _endereco;

  Fornecedor(
      {int? id,
      required String nome,
      required String cnpj,
      required String telefone,
      required String email,
      required String endereco,
      DateTime? dataCriacao})
      : _nome = nome,
        _cnpj = cnpj,
        _telefone = telefone,
        _email = email,
        _endereco = endereco,
        super(id: id, dataCriacao: dataCriacao);

  // Getters - Encapsulamento
  String get nome => _nome;
  String get cnpj => _cnpj;
  String get telefone => _telefone;
  String get email => _email;
  String get endereco => _endereco;

  // Setters com validação - Encapsulamento
  set nome(String novoNome) {
    if (novoNome.length < 2) {
      throw ArgumentError('Nome deve ter pelo menos 2 caracteres');
    }
    _nome = novoNome;
  }

  set cnpj(String novoCnpj) {
    if (novoCnpj.length != 18) {
      throw ArgumentError('CNPJ deve ter 18 caracteres');
    }
    _cnpj = novoCnpj;
  }

  set telefone(String novoTelefone) {
    _telefone = novoTelefone;
  }

  set email(String novoEmail) {
    if (!novoEmail.contains('@')) {
      throw ArgumentError('Email deve conter @');
    }
    _email = novoEmail;
  }

  set endereco(String novoEndereco) {
    _endereco = novoEndereco;
  }

  // Implementação do método abstrato - Polimorfismo
  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': _nome,
      'cnpj': _cnpj,
      'telefone': _telefone,
      'email': _email,
      'endereco': _endereco,
      'data_criacao': dataCriacao.toString()
    };
  }

  // Sobrescrita de método - Polimorfismo
  @override
  String get infoBasica {
    return '${super.infoBasica} | ${_nome} | ${_cnpj}';
  }

  // Método estático para criar objeto a partir de map - CORRIGIDO
  static Fornecedor fromMap(Map<String, dynamic> map) {
    // Converter campos que podem ser Blob
    String endereco = '';
    if (map['endereco'] != null) {
      if (map['endereco'] is Blob) {
        endereco = utf8.decode((map['endereco'] as Blob).toBytes());
      } else {
        endereco = map['endereco'].toString();
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

    return Fornecedor(
        id: map['id'] as int?,
        nome: map['nome'].toString(),
        cnpj: map['cnpj']?.toString() ?? '',
        telefone: map['telefone']?.toString() ?? '',
        email: map['email']?.toString() ?? '',
        endereco: endereco,
        dataCriacao: dataCriacao);
  }
}
