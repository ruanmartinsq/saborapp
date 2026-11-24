import 'package:flutter/foundation.dart';

import '../models/receita.dart';

class MinhasReceitasProvider extends ChangeNotifier {
  final List<Receita> _receitas = [];

  List<Receita> get receitas => List.unmodifiable(_receitas);
  int get total => _receitas.length;

  void adicionar(Receita receita) {
    _receitas.insert(0, receita); // a mais nova aparece primeiro
    notifyListeners();
  }
}
