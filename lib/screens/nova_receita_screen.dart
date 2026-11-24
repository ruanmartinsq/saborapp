import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/receita.dart';
import '../state/minhas_receitas_provider.dart';

class NovaReceitaScreen extends StatefulWidget {
  const NovaReceitaScreen({super.key});

  @override
  State<NovaReceitaScreen> createState() => _NovaReceitaScreenState();
}

class _NovaReceitaScreenState extends State<NovaReceitaScreen> {
  static const _categorias = [
    'Prato principal',
    'Sobremesa',
    'Lanche',
    'Bebida',
  ];

  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _tempoCtrl = TextEditingController();
  final _ingredientesCtrl = TextEditingController();
  final _preparoCtrl = TextEditingController();

  String? _categoria;
  Dificuldade _dificuldade = Dificuldade.facil;
  double _porcoes = 4;
  bool _vegetariana = false;

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _tempoCtrl.dispose();
    _ingredientesCtrl.dispose();
    _preparoCtrl.dispose();
    super.dispose();
  }

  List<String> _linhas(String texto) {
    return texto
        .split('\n')
        .map((linha) => linha.trim())
        .where((linha) => linha.isNotEmpty)
        .toList();
  }

  String? _validarNome(String? valor) {
    final nome = (valor ?? '').trim();
    if (nome.isEmpty) return 'Informe o nome da receita';
    if (nome.length < 3) return 'Use pelo menos 3 caracteres';
    return null;
  }

  String? _validarTempo(String? valor) {
    final tempo = int.tryParse((valor ?? '').trim());
    if (tempo == null) return 'Informe o tempo em minutos';
    if (tempo < 1 || tempo > 600) return 'Use um valor entre 1 e 600';
    return null;
  }

  String? _validarIngredientes(String? valor) {
    if (_linhas(valor ?? '').length < 2) {
      return 'Informe pelo menos 2 ingredientes (um por linha)';
    }
    return null;
  }

  String? _validarPreparo(String? valor) {
    final texto = (valor ?? '').trim();
    if (texto.isEmpty) return 'Descreva o modo de preparo';
    if (texto.length < 20) return 'Use pelo menos 20 caracteres';
    return null;
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final receita = Receita(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nome: _nomeCtrl.text.trim(),
      categoria: _categoria!,
      origem: 'Minha receita',
      tempoMinutos: int.parse(_tempoCtrl.text.trim()),
      dificuldade: _dificuldade,
      ingredientes: _linhas(_ingredientesCtrl.text),
      modoPreparo: _preparoCtrl.text.trim(),
      porcoes: _porcoes.round(),
      vegetariana: _vegetariana,
    );

    context.read<MinhasReceitasProvider>().adicionar(receita);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Receita salva!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova receita')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nome
              TextFormField(
                controller: _nomeCtrl,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: _validarNome,
              ),
              const SizedBox(height: 16),

              // Tempo
              TextFormField(
                controller: _tempoCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Tempo (min)',
                  border: OutlineInputBorder(),
                ),
                validator: _validarTempo,
              ),
              const SizedBox(height: 16),

              // Categoria
              DropdownButtonFormField<String>(
                initialValue: _categoria,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
                items: _categorias
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (valor) => setState(() => _categoria = valor),
                validator: (valor) =>
                    valor == null ? 'Escolha uma categoria' : null,
              ),
              const SizedBox(height: 20),

              // Dificuldade
              const Text('Dificuldade'),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<Dificuldade>(
                  segments: Dificuldade.values
                      .map(
                        (d) => ButtonSegment<Dificuldade>(
                          value: d,
                          label: Text(d.rotulo),
                        ),
                      )
                      .toList(),
                  selected: {_dificuldade},
                  onSelectionChanged: (selecao) =>
                      setState(() => _dificuldade = selecao.first),
                ),
              ),
              const SizedBox(height: 20),

              // Porções
              Text('Porções: ${_porcoes.round()}'),
              Slider(
                value: _porcoes,
                min: 1,
                max: 12,
                divisions: 11,
                label: '${_porcoes.round()}',
                onChanged: (valor) => setState(() => _porcoes = valor),
              ),

              // Vegetariana
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Vegetariana'),
                value: _vegetariana,
                onChanged: (valor) => setState(() => _vegetariana = valor),
              ),
              const SizedBox(height: 8),

              // Ingredientes
              TextFormField(
                controller: _ingredientesCtrl,
                keyboardType: TextInputType.multiline,
                minLines: 4,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Ingredientes',
                  hintText: 'Um ingrediente por linha',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: _validarIngredientes,
              ),
              const SizedBox(height: 16),

              // Modo de preparo
              TextFormField(
                controller: _preparoCtrl,
                keyboardType: TextInputType.multiline,
                minLines: 4,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Modo de preparo',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: _validarPreparo,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _salvar,
                  icon: const Icon(Icons.check),
                  label: const Text('Salvar receita'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
