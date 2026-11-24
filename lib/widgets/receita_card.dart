import 'package:flutter/material.dart';
import '../models/receita.dart';

class ReceitaCard extends StatelessWidget {
  final Receita receita;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ReceitaCard({
    super.key,
    required this.receita,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap?.call();
      },
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Imagem da receita
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: receita.imagemUrl.isNotEmpty
                  ? Image.network(
                      receita.imagemUrl,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return CircleAvatar(
                          radius: 36,
                          child: Text(
                            receita.nome.isNotEmpty
                                ? receita.nome[0].toUpperCase()
                                : '?',
                          ),
                        );
                      },
                    )
                  : CircleAvatar(
                      radius: 36,
                      child: Text(
                        receita.nome.isNotEmpty
                            ? receita.nome[0].toUpperCase()
                            : '?',
                      ),
                    ),
            ),

            const SizedBox(width: 12),

            // Informações da receita
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    receita.nome,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '${receita.categoria} · ${receita.origem}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Tempo e dificuldade
                  Row(
                    children: [
                      const Icon(
                        Icons.timer,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        receita.tempoFormatado,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.signal_cellular_alt,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        receita.dificuldade.rotulo,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
