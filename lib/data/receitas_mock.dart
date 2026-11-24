import '../models/receita.dart';

const List<Receita> receitasMock = [
  Receita(
    id: '1',
    nome: 'Pão de Queijo',
    categoria: 'Lanche',
    origem: 'Minas Gerais',
    tempoMinutos: 45,
    dificuldade: Dificuldade.facil,
    ingredientes: [
      'Polvilho doce',
      'Leite',
      'Óleo',
      'Ovos',
      'Queijo meia cura',
      'Sal',
    ],
    modoPreparo:
        'Misture o leite, o óleo e o sal. Acrescente o polvilho, os ovos e o queijo. '
        'Modele as bolinhas e asse até ficarem douradas.',
    porcoes: 20,
    vegetariana: true,
  ),
  Receita(
    id: '2',
    nome: 'Brigadeiro',
    categoria: 'Sobremesa',
    origem: 'Brasil',
    tempoMinutos: 30,
    dificuldade: Dificuldade.facil,
    ingredientes: [
      'Leite condensado',
      'Chocolate em pó',
      'Manteiga',
      'Granulado',
    ],
    modoPreparo:
        'Coloque o leite condensado, o chocolate e a manteiga em uma panela. '
        'Mexa em fogo baixo até desgrudar do fundo. Deixe esfriar, faça bolinhas '
        'e passe no granulado.',
    porcoes: 20,
    vegetariana: true,
  ),
  Receita(
    id: '3',
    nome: 'Feijoada',
    categoria: 'Almoço',
    origem: 'Brasil',
    tempoMinutos: 90,
    dificuldade: Dificuldade.dificil,
    ingredientes: [
      'Feijão preto',
      'Carne seca',
      'Linguiça calabresa',
      'Costelinha de porco',
      'Alho',
      'Cebola',
      'Folhas de louro',
    ],
    modoPreparo:
        'Deixe o feijão de molho. Cozinhe as carnes e o feijão até ficarem macios. '
        'Prepare um refogado de alho e cebola, acrescente à panela e deixe cozinhar '
        'até o caldo engrossar.',
    porcoes: 8,
    vegetariana: false,
  ),
  Receita(
    id: '4',
    nome: 'Moqueca de Peixe',
    categoria: 'Almoço',
    origem: 'Bahia',
    tempoMinutos: 90,
    dificuldade: Dificuldade.media,
    ingredientes: [
      'Filés de peixe',
      'Leite de coco',
      'Azeite de dendê',
      'Tomates',
      'Pimentão',
      'Cebola',
      'Coentro',
      'Limão',
    ],
    modoPreparo:
        'Tempere o peixe com limão e sal. Em uma panela, faça camadas de cebola, '
        'tomate, pimentão e peixe. Acrescente o leite de coco e o azeite de dendê. '
        'Cozinhe até o peixe ficar macio e finalize com coentro.',
    porcoes: 4,
    vegetariana: false,
  ),
  Receita(
    id: '5',
    nome: 'Salada de Quinoa',
    categoria: 'Salada',
    origem: 'Internacional',
    tempoMinutos: 25,
    dificuldade: Dificuldade.facil,
    ingredientes: [
      'Quinoa',
      'Tomate cereja',
      'Pepino',
      'Cenoura',
      'Limão',
      'Azeite',
      'Salsinha',
    ],
    modoPreparo:
        'Cozinhe a quinoa e deixe esfriar. Pique os vegetais e misture com a quinoa. '
        'Tempere com limão, azeite, sal e salsinha.',
    porcoes: 2,
    vegetariana: true,
  ),
  Receita(
    id: '6',
    nome: 'Suco Verde',
    categoria: 'Bebida',
    origem: 'Brasil',
    tempoMinutos: 10,
    dificuldade: Dificuldade.facil,
    ingredientes: [
      'Couve',
      'Limão',
      'Maçã',
      'Gengibre',
      'Água gelada',
    ],
    modoPreparo:
        'Lave bem os ingredientes. Corte a maçã, esprema o limão e coloque tudo '
        'no liquidificador com a couve, o gengibre e a água. Bata bem e sirva.',
    porcoes: 2,
    vegetariana: true,
  ),
];

List<Receita> filtrarPorNome(List<Receita> receitas, String termo) {
  final busca = termo.trim().toLowerCase();

  if (busca.isEmpty) {
    return receitas;
  }

  return receitas
      .where((receita) => receita.nome.toLowerCase().contains(busca))
      .toList();
}
