import 'produto.dart';

// Herança: ProdutoImportado herda de Produto
class ProdutoImportado extends Produto {
  String _paisOrigem;
  double _taxaImportacao;
  String _codigoNCM;

  ProdutoImportado({
    int? id,
    required String nome,
    required String descricao,
    required double preco,
    required int quantidadeEstoque,
    required String categoria,
    required String paisOrigem,
    required double taxaImportacao,
    required String codigoNCM,
    bool ativo = true,
    DateTime? dataCriacao,
  }) : _paisOrigem = paisOrigem,
       _taxaImportacao = taxaImportacao,
       _codigoNCM = codigoNCM,
       super(
         id: id,
         nome: nome,
         descricao: descricao,
         preco: preco,
         quantidadeEstoque: quantidadeEstoque,
         categoria: categoria,
         ativo: ativo,
         dataCriacao: dataCriacao,
       );

  // Getters e Setters específicos
  String get paisOrigem => _paisOrigem;
  double get taxaImportacao => _taxaImportacao;
  String get codigoNCM => _codigoNCM;

  set paisOrigem(String novoPais) {
    if (novoPais.length < 2) {
      throw ArgumentError('País de origem deve ter pelo menos 2 caracteres');
    }
    _paisOrigem = novoPais;
  }

  set taxaImportacao(double novaTaxa) {
    if (novaTaxa < 0) {
      throw ArgumentError('Taxa de importação não pode ser negativa');
    }
    _taxaImportacao = novaTaxa;
  }

  set codigoNCM(String novoCodigo) {
    if (novoCodigo.length != 8) {
      throw ArgumentError('Código NCM deve ter 8 dígitos');
    }
    _codigoNCM = novoCodigo;
  }

  // Sobrescrita do getter preco para incluir taxa de importação - Polimorfismo
  @override
  double get preco => super.preco * (1 + _taxaImportacao / 100);

  // Método específico para produto importado
  double get precoSemTaxa => super.preco;

  // Sobrescrita do método toMap - Polimorfismo
  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'pais_origem': _paisOrigem,
      'taxa_importacao': _taxaImportacao,
      'codigo_ncm': _codigoNCM,
      'tipo': 'importado',
    });
    return map;
  }

  // Sobrescrita do método infoBasica - Polimorfismo
  @override
  String get infoBasica {
    return '${super.infoBasica} | Importado: $_paisOrigem | Taxa: ${_taxaImportacao}%';
  }

  // Método estático específico
  static ProdutoImportado fromMap(Map<String, dynamic> map) {
    return ProdutoImportado(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'],
      preco: double.parse(map['preco'].toString()),
      quantidadeEstoque: map['quantidade_estoque'],
      categoria: map['categoria'],
      paisOrigem: map['pais_origem'],
      taxaImportacao: double.parse(map['taxa_importacao'].toString()),
      codigoNCM: map['codigo_ncm'],
      ativo: map['ativo'] == 1,
      dataCriacao: DateTime.parse(map['data_criacao']),
    );
  }
}
