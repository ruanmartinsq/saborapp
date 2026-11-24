import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/receita.dart';
import '../data/receita_repository.dart';

enum EstadoBusca { carregando, sucesso, erro }

class ReceitasProvider extends ChangeNotifier {
  static const termoInicial = 'a';

  final ReceitaRepository _repositorio;

  ReceitasProvider(this._repositorio);

  List<Receita> _receitas = [];
  EstadoBusca _estado = EstadoBusca.carregando;
  String? _erro;
  Timer? _debounce;
  int _requisicao = 0;

  List<Receita> get receitas => _receitas;
  EstadoBusca get estado => _estado;
  String? get erro => _erro;

  void buscarComDebounce(String termo) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => buscar(termo),
    );
  }

  Future<void> buscar(String termo) async {
    _debounce?.cancel();

    final termoEfetivo = termo.trim().isEmpty ? termoInicial : termo.trim();
    final id = ++_requisicao;

    _estado = EstadoBusca.carregando;
    _erro = null;
    notifyListeners();

    try {
      final resultado = await _repositorio.buscar(termoEfetivo);
      if (id != _requisicao) return;
      _receitas = resultado;
      _estado = EstadoBusca.sucesso;
    } catch (e) {
      if (id != _requisicao) return;
      _erro = 'Não foi possível carregar as receitas.\n'
          'Verifique sua conexão e tente novamente.';
      _estado = EstadoBusca.erro;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
