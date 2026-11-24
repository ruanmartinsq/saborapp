import 'package:flutter/material.dart';
import '../data/receitas_mock.dart';
import '../models/receita.dart';
import '../widgets/receita_card.dart';
import 'detalhe_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _termo = '';
  bool _emGrade = false;

  Future<void> _abrirDetalhes(Receita receita) async {
    final favoritou = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => DetalheScreen(receita: receita),
      ),
    );

    if (!context.mounted) return;

    if (favoritou == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${receita.nome} adicionada aos favoritos ❤',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final receitas = filtrarPorNome(receitasMock, _termo);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SaborApp'),
        actions: [
          IconButton(
            icon: Icon(
              _emGrade ? Icons.view_list : Icons.grid_view,
            ),
            onPressed: () {
              setState(() {
                _emGrade = !_emGrade;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (valor) {
                setState(() {
                  _termo = valor;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Buscar receita',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: receitas.isEmpty
                ? const Center(
                    child: Text('Nenhuma receita encontrada'),
                  )
                : _emGrade
                    ? _buildGrade(receitas)
                    : _buildLista(receitas),
          ),
        ],
      ),
    );
  }

  // Modo lista
  Widget _buildLista(List<Receita> receitas) {
    return ListView.builder(
      itemCount: receitas.length,
      itemBuilder: (context, index) {
        final receita = receitas[index];

        return ReceitaCard(
          receita: receita,
          onTap: () => _abrirDetalhes(receita),
          onLongPress: () => _mostrarResumo(receita),
        );
      },
    );
  }

  // Modo grade
  Widget _buildGrade(List<Receita> receitas) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: receitas.length,
      itemBuilder: (context, index) {
        final receita = receitas[index];

        return GestureDetector(
          onTap: () => _abrirDetalhes(receita),
          onLongPress: () => _mostrarResumo(receita),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: receita.imagemUrl.isNotEmpty
                      ? Image.network(
                          receita.imagemUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.restaurant, size: 40),
                        )
                      : const Icon(Icons.restaurant, size: 40),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                receita.nome,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(receita.categoria),
            ],
          ),
        );
      },
    );
  }

  // Resumo rápido
  void _mostrarResumo(Receita receita) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Resumo rápido'),
          content: Text(
            'Tempo: ${receita.tempoFormatado}\n'
            'Porções: ${receita.porcoes}\n'
            'Ingredientes: ${receita.ingredientes.length}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
