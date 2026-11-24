enum Dificuldade {
  facil,
  media,
  dificil,
}

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
}
