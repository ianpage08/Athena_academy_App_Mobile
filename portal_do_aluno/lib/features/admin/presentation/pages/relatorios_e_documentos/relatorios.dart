import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/teacher/data/datasources/frequencia_firestore.dart';
import 'package:portal_do_aluno/shared/widgets/firestore/firestore_collection_count.dart';

class RelatoriosGerenciais extends StatefulWidget {
  const RelatoriosGerenciais({super.key});

  @override
  State<RelatoriosGerenciais> createState() => _RelatoriosGerenciaisState();
}

class _RelatoriosGerenciaisState extends State<RelatoriosGerenciais> {
  String _periodoSelecionado = 'Mensal';
  final FrequenciaService _frequenciaService = FrequenciaService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // 👉 ALTERAÇÃO: AppBar minimalista com foco em conteúdo
      appBar: AppBar(
        title: const Text(
          'BI & Analytics', // Nome mais futurista para Relatórios
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -1),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👉 ALTERAÇÃO: Filtro de Período com visual Clean
            _buildPeriodSelector(theme),

            const SizedBox(height: 32),

            // 👉 ALTERAÇÃO: Seção de Métricas com Grid Otimizado
            _buildSectionHeader('📊 Indicadores de Performance'),
            const SizedBox(height: 16),
            _buildMetricsGrid(),

            const SizedBox(height: 32),

            // 👉 ALTERAÇÃO: Seção de Análise Visual (Gráficos)
            _buildSectionHeader('📈 Inteligência de Dados'),
            const SizedBox(height: 12),
            _buildAnalysisList(theme),

            const SizedBox(height: 32),

            // 👉 ALTERAÇÃO: Ações de Exportação com visual Premium
            _buildActionButtons(theme),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- COMPONENTES PRIVADOS (CLEAN ARCHITECTURE INTERNA) ---

  // 👉 MELHORIA: Widget de cabeçalho padronizado para seções
  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: Colors.grey,
        letterSpacing: 1.2,
      ),
    );
  }

  // 👉 ALTERAÇÃO: Seletor de período com visual moderno e sem bordas pesadas
  Widget _buildPeriodSelector(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          Icons.calendar_today_rounded,
          color: theme.primaryColor,
          size: 20,
        ),
        title: const Text(
          'Período de Análise',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        trailing: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _periodoSelecionado,
            borderRadius: BorderRadius.circular(16),
            items: [
              'Semanal',
              'Mensal',
              'Bimestral',
              'Anual',
            ].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
            onChanged: (v) => setState(() => _periodoSelecionado = v!),
          ),
        ),
      ),
    );
  }

  // 👉 ALTERAÇÃO: Grid de métricas usando o novo componente especializado
  Widget _buildMetricsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        FirestoreCollectionCount(
          collectionPath: 'matriculas',
          builder: (context, _, total) => _MetricCard(
            label: 'Alunos',
            value: total,
            icon: Icons.people_alt,
            color: Colors.blue,
          ),
        ),
        FirestoreCollectionCount(
          collectionPath: 'usuarios',
          fieldName: 'type',
          fieldValue: 'teacher',
          builder: (context, _, total) => _MetricCard(
            label: 'Docentes',
            value: total,
            icon: Icons.school,
            color: Colors.greenAccent,
          ),
        ),
        FirestoreCollectionCount(
          collectionPath: 'turmas',
          builder: (context, _, total) => _MetricCard(
            label: 'Turmas',
            value: total,
            icon: Icons.room_preferences,
            color: Colors.orange,
          ),
        ),
        FutureBuilder<int>(
          future: _frequenciaService.calcularQuantidadeDeFrequenciaPorpresenca(
            tipoPresenca: 'presente',
          ),
          builder: (context, snapshot) {
            final val = snapshot.data ?? 0;
            return _MetricCard(
              label: 'Presenças',
              value: val,
              icon: Icons.analytics,
              color: Colors.purple,
              isLoading: snapshot.connectionState == ConnectionState.waiting,
            );
          },
        ),
      ],
    );
  }

  // 👉 ALTERAÇÃO: Lista de relatórios com visual Glassmorphism sutil
  Widget _buildAnalysisList(ThemeData theme) {
    return const Column(
      children: [
        _AnalysisTile(
          icon: Icons.bar_chart_rounded,
          title: 'Desempenho por Turma',
          color: Colors.blue,
          subtitle: 'Média global de notas',
        ),
        _AnalysisTile(
          icon: Icons.pie_chart_rounded,
          title: 'Distribuição Alunos',
          color: Colors.greenAccent,
          subtitle: 'Segmentação por série',
        ),
        _AnalysisTile(
          icon: Icons.show_chart_rounded,
          title: 'Evolução Frequência',
          color: Colors.orange,
          subtitle: 'Histórico semestral',
        ),
        _AnalysisTile(
          icon: Icons.warning_amber_rounded,
          title: 'Disciplinas Críticas',
          color: Colors.red,
          subtitle: 'Médias abaixo de 6.0',
          showDownload: true,
        ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            label: 'Exportar Tudo',
            icon: Icons.ios_share_rounded,
            onPressed: () => _toast('Gerando pacote de relatórios...'),
          ),
        ),
        const SizedBox(width: 12),
        _ActionButton(
          label: 'Imprimir',
          icon: Icons.print_rounded,
          isSecondary: true,
          onPressed: () => _toast('Preparando impressão...'),
        ),
      ],
    );
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(msg),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// --- WIDGETS DE SUPORTE (ESCALABILIDADE E REUSO) ---

class _MetricCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final bool isLoading;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      value.toString(),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: color,
                        letterSpacing: -1,
                      ),
                    ),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnalysisTile extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final Color color;
  final bool showDownload;

  const _AnalysisTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.showDownload = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: showDownload
            ? IconButton(
                icon: const Icon(Icons.file_download_outlined),
                onPressed: () {},
              )
            : const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isSecondary;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSecondary ? theme.cardColor : theme.primaryColor,
        foregroundColor: isSecondary ? theme.primaryColor : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
