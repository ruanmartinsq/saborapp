import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/receita.dart';

class FavoritosProvider extends ChangeNotifier {
  static const _chave = 'favoritos';

  final List<Receita> _favoritas = [];

  List<Receita> get favoritas => List.unmodifiable(_favoritas);

  bool isFavorita(String id) => _favoritas.any((r) => r.id == id);

  Future<void> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    final salvas = prefs.getStringList(_chave) ?? [];

    _favoritas.clear();
    for (final item in salvas) {
      try {
        _favoritas.add(
          Receita.fromMap(jsonDecode(item) as Map<String, dynamic>),
        );
      } catch (_) {
        // Ignora registro corrompido em vez de quebrar o app.
      }
    }
    notifyListeners();
  }

  /// Favorita ou desfavorita. Retorna true se a receita ficou favoritada.
  Future<bool> alternar(Receita receita) async {
    final jaEra = isFavorita(receita.id);

    if (jaEra) {
      _favoritas.removeWhere((r) => r.id == receita.id);
    } else {
      _favoritas.insert(0, receita);
    }
    notifyListeners();

    await _salvar();
    return !jaEra;
  }

  Future<void> _salvar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _chave,
      _favoritas.map((r) => jsonEncode(r.toMap())).toList(),
    );
  }
}
