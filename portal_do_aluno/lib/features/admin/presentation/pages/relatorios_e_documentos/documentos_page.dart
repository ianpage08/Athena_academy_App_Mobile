import 'package:flutter/material.dart';

// 👉 MODELO DE DADOS: Extraído para facilitar a manutenção e escalabilidade.
// Em um projeto real, isso poderia vir de um arquivo de constantes ou controller.
class ItemRelatorio {
  final String titulo;
  final String descricao;
  final IconData icone;
  final Color cor;

  const ItemRelatorio({
    required this.titulo,
    required this.descricao,
    required this.icone,
    this.cor = Colors.blue,
  });
}

class RelatoriosPage extends StatelessWidget {
  const RelatoriosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 👉 LISTA DE DADOS: Agora tipada e mais organizada.
    final List<ItemRelatorio> relatorios = [
      const ItemRelatorio(
        titulo: 'Alunos por Turma',
        descricao: 'Listagem e enturmação',
        icone: Icons.groups_rounded,
        cor: Colors.blueAccent,
      ),
      const ItemRelatorio(
        titulo: 'Frequência',
        descricao: 'Controle de assiduidade',
        icone: Icons.event_available_rounded,
        cor: Colors.teal,
      ),
      const ItemRelatorio(
        titulo: 'Notas',
        descricao: 'Desempenho acadêmico',
        icone: Icons.auto_graph_rounded,
        cor: Colors.orange,
      ),
      const ItemRelatorio(
        titulo: 'Financeiro',
        descricao: 'Mensalidades e fluxos',
        icone: Icons.account_balance_wallet_rounded,
        cor: Colors.greenAccent,
      ),
      const ItemRelatorio(
        titulo: 'Professores',
        descricao: 'Carga horária e dados',
        icone: Icons.history_edu_rounded,
        cor: Colors.indigo,
      ),
      const ItemRelatorio(
        titulo: 'Contrato',
        descricao: 'Gerar termo de matrícula',
        icone: Icons.assignment_rounded,
        cor: Colors.blueGrey,
      ),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // 👉 MUDANÇA: AppBar com tipografia de 'Display' para visual moderno
      appBar: AppBar(
        title: const Text(
          'Centro de Relatórios',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.5),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(24),
        // 👉 MELHORIA: BouncingScrollPhysics para sensação tátil premium
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 0.85, // Ajustado para acomodar descrição sutil
        ),
        itemCount: relatorios.length,
        itemBuilder: (context, index) {
          final item = relatorios[index];
          return _CardRelatorio(item: item);
        },
      ),
    );
  }
}

// 👉 COMPONENTE PRIVADO: Encapsulamento da UI para facilitar evolução
class _CardRelatorio extends StatelessWidget {
  final ItemRelatorio item;

  const _CardRelatorio({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(28),
        // 👉 DESIGN: Sombras muito leves para profundidade sem poluição
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () => _handleTap(context),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 👉 ICONE: Container estilizado (Neomorfismo sutil)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: item.cor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icone, color: item.cor, size: 32),
                ),
                const SizedBox(height: 16),
                // 👉 TÍTULO: Hierarquia clara
                Text(
                  item.titulo,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                // 👉 DESCRIÇÃO: Guia o usuário sem pesar no visual
                Text(
                  item.descricao,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text('Iniciando geração: ${item.titulo}'),
      ),
    );
  }
}