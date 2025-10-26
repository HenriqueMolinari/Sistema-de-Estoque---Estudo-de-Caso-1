// Classe abstrata - Abstração
abstract class EntidadeBase {
  int? id;
  DateTime dataCriacao;

  EntidadeBase({this.id, DateTime? dataCriacao})
      : dataCriacao = dataCriacao ?? DateTime.now();

  // Método abstrato - deve ser implementado pelas classes filhas
  Map<String, dynamic> toMap();

  // Método concreto com implementação padrão
  String get infoBasica => 'ID: $id | Criado em: ${dataCriacao.toString()}';
}
