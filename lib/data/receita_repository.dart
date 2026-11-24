import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/receita.dart';
import 'receitas_mock.dart';

abstract class ReceitaRepository {
  Future<List<Receita>> buscar(String termo);
}

class ReceitaRepositoryHttp implements ReceitaRepository {
  final http.Client client;

  ReceitaRepositoryHttp(this.client);

  @override
  Future<List<Receita>> buscar(String termo) async {
    final url = Uri.https(
      'www.themealdb.com',
      '/api/json/v1/1/search.php',
      {'s': termo.trim()},
    );

    final resposta = await client.get(url).timeout(
          const Duration(seconds: 10),
        );

    if (resposta.statusCode != 200) {
      throw Exception('Erro ${resposta.statusCode} ao buscar receitas');
    }

    final mapa =
        jsonDecode(utf8.decode(resposta.bodyBytes)) as Map<String, dynamic>;
    final meals =
        mapa['meals'] as List<dynamic>?; // null quando nada é encontrado

    return meals
            ?.map((m) => Receita.fromJson(m as Map<String, dynamic>))
            .toList() ??
        [];
  }
}

class ReceitaRepositoryMock implements ReceitaRepository {
  @override
  Future<List<Receita>> buscar(String termo) async {
    await Future.delayed(const Duration(milliseconds: 600)); // simula a rede
    return filtrarPorNome(receitasMock, termo);
  }
}
