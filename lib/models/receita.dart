enum Dificuldade { facil, media, dificil }

extension DificuldadeTexto on Dificuldade {
  String get rotulo => switch (this) {
        Dificuldade.facil => 'Fácil',
        Dificuldade.media => 'Média',
        Dificuldade.dificil => 'Difícil',
      };
}

class Receita {
  final String id;
  final String nome;
  final String categoria;
  final String origem;
  final String imagemUrl;
  final int tempoMinutos;
  final Dificuldade dificuldade;
  final List<String> ingredientes;
  final String modoPreparo;
  final int porcoes;
  final bool vegetariana;

  const Receita({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.origem,
    this.imagemUrl = '',
    required this.tempoMinutos,
    required this.dificuldade,
    required this.ingredientes,
    required this.modoPreparo,
    this.porcoes = 4,
    this.vegetariana = false,
  });

  String get tempoFormatado => tempoMinutos >= 60
      ? '${tempoMinutos ~/ 60}h ${tempoMinutos % 60}min'
      : '$tempoMinutos min';

  factory Receita.fromJson(Map<String, dynamic> json) {
    final ingredientes = <String>[];
    for (var i = 1; i <= 20; i++) {
      final ing = (json['strIngredient$i'] as String?)?.trim() ?? '';
      if (ing.isEmpty) continue;
      final medida = (json['strMeasure$i'] as String?)?.trim() ?? '';
      ingredientes.add(medida.isEmpty ? ing : '$medida $ing');
    }

    final categoria = (json['strCategory'] as String?) ?? 'Outros';
    final qtd = ingredientes.length;

    return Receita(
      id: (json['idMeal'] as String?) ?? '',
      nome: (json['strMeal'] as String?) ?? 'Sem nome',
      categoria: categoria,
      origem: (json['strArea'] as String?) ?? '-',
      imagemUrl: (json['strMealThumb'] as String?) ?? '',
      tempoMinutos: 15 + qtd * 5,
      dificuldade: qtd <= 6
          ? Dificuldade.facil
          : qtd <= 10
              ? Dificuldade.media
              : Dificuldade.dificil,
      ingredientes: ingredientes,
      modoPreparo: (json['strInstructions'] as String?)?.trim() ?? '',
      vegetariana: categoria == 'Vegetarian' || categoria == 'Vegan',
    );
  }

  Map<String, dynamic> toJson() => {
        'idMeal': id,
        'strMeal': nome,
        'strCategory': categoria,
        'strArea': origem,
        'strMealThumb': imagemUrl,
        'strInstructions': modoPreparo,
        for (var i = 0; i < ingredientes.length; i++)
          'strIngredient${i + 1}': ingredientes[i],
      };

  factory Receita.fromMap(Map<String, dynamic> map) => Receita(
        id: map['id'] as String,
        nome: map['nome'] as String,
        categoria: map['categoria'] as String,
        origem: map['origem'] as String,
        imagemUrl: (map['imagemUrl'] as String?) ?? '',
        tempoMinutos: map['tempoMinutos'] as int,
        dificuldade: Dificuldade.values.byName(map['dificuldade'] as String),
        ingredientes: List<String>.from(map['ingredientes'] as List),
        modoPreparo: map['modoPreparo'] as String,
        porcoes: (map['porcoes'] as int?) ?? 4,
        vegetariana: (map['vegetariana'] as bool?) ?? false,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'categoria': categoria,
        'origem': origem,
        'imagemUrl': imagemUrl,
        'tempoMinutos': tempoMinutos,
        'dificuldade': dificuldade.name,
        'ingredientes': ingredientes,
        'modoPreparo': modoPreparo,
        'porcoes': porcoes,
        'vegetariana': vegetariana,
      };
}
