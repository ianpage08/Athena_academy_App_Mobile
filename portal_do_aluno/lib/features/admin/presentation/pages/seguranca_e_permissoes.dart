import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';

class SegurancaEPermissoes extends StatefulWidget {
  const SegurancaEPermissoes({super.key});

  @override
  State<SegurancaEPermissoes> createState() => _SegurancaEPermissoesState();
}

class _SegurancaEPermissoesState extends State<SegurancaEPermissoes> {
  // 👉 MELHORIA ARQUITETURAL: Em um cenário real, esses dados viriam de um Controller/Provider
  final Map<String, dynamic> _dadosSeguranca = {
    'usuariosAtivos': 368,
    'professores': 25,
    'alunos': 265,
    'administradores': 3,
    'ultimoLoginSuspeito': 'user@escola.com há 10 horas',
    'tentativasLogin': 12,
    'sessaoesAtivas': 45,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Segurança e Permissões'),
      body: Container(
        // 👉 MUDANÇA 1: Fundo com gradiente sutil para profundidade
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.primary.withValues(alpha: 0.03),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection('Visão Geral de Acesso'),
              const SizedBox(height: 16),
              _buildMainStatusCard(theme),

              const SizedBox(height: 32),
              _buildHeaderSection('Distribuição de Perfis'),
              const SizedBox(height: 16),
              _buildPerfisGrid(),

              const SizedBox(height: 32),
              _buildHeaderSection('Alertas Críticos'),
              const SizedBox(height: 16),
              _buildAlertaSeguranca(theme),

              const SizedBox(height: 32),
              _buildHeaderSection('Gerenciamento'),
              const SizedBox(height: 16),
              _buildSessoesAtivas(theme),
              const SizedBox(height: 12),
              _buildAcoesRapidas(theme),
            ],
          ),
        ),
      ),
    );
  }

  // 👉 REUTILIZAÇÃO: Helper para títulos de seção padronizados
  Widget _buildHeaderSection(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.5,
        color: Colors.grey,
      ),
    );
  }

  // 👉 MUDANÇA 2: Card de Status Principal (Design Moderno)
  Widget _buildMainStatusCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildAnimatedIcon(Icons.shield_rounded, Colors.green),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_dadosSeguranca['usuariosAtivos']}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Usuários ativos agora',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                CircleAvatar(radius: 4, backgroundColor: Colors.green),
                SizedBox(width: 6),
                Text(
                  'SISTEMA SEGURO',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 👉 MUDANÇA 3: Grid de Perfis (Melhor aproveitamento de espaço)
  Widget _buildPerfisGrid() {
    return Row(
      children: [
        _buildSmallProfileCard(
          'Admins',
          _dadosSeguranca['administradores'],
          Icons.security,
          Colors.indigo,
        ),
        const SizedBox(width: 12),
        _buildSmallProfileCard(
          'Profs',
          _dadosSeguranca['professores'],
          Icons.school,
          Colors.blue,
        ),
        const SizedBox(width: 12),
        _buildSmallProfileCard(
          'Alunos',
          _dadosSeguranca['alunos'],
          Icons.person,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildSmallProfileCard(
    String label,
    dynamic value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              '$value',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // 👉 MUDANÇA 4: Alertas com Hierarquia de Cores
  Widget _buildAlertaSeguranca(ThemeData theme) {
    return Column(
      children: [
        _buildItemAlerta(
          Icons.gpp_maybe_rounded,
          'Login suspeito: ${_dadosSeguranca['ultimoLoginSuspeito']}',
          Colors.orange,
        ),
        const SizedBox(height: 12),
        _buildItemAlerta(
          Icons.report_problem_rounded,
          '${_dadosSeguranca['tentativasLogin']} tentativas de invasão bloqueadas',
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildSessoesAtivas(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: _buildAnimatedIcon(Icons.devices_other_rounded, Colors.purple),
        title: const Text(
          'Dispositivos Conectados',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${_dadosSeguranca['sessaoesAtivas']} sessões em andamento',
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: theme.hintColor,
        ),
        onTap: () => _toast('Verificando sessões...'),
      ),
    );
  }

  // 👉 MUDANÇA 5: Ações Rápidas (Botões mais profissionais e menos gritantes)
  Widget _buildAcoesRapidas(ThemeData theme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                onPressed: () => _toast('Iniciando Backup...'),
                icon: Icons.cloud_upload_rounded,
                label: 'Backup Global',
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                onPressed: () => _toast('Relatório Gerado'),
                icon: Icons.analytics_rounded,
                label: 'Log de Auditoria',
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          onPressed: () => _toast('Sessões encerradas'),
          icon: Icons.phonelink_erase_rounded,
          label: 'Encerrar Todas as Sessões de Usuários',
          color: Colors.redAccent,
          isFullWidth: true,
        ),
      ],
    );
  }

  // 👉 COMPONENTE REUTILIZÁVEL: Botão Customizado
  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
    bool isFullWidth = false,
  }) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 26),
    );
  }

  Widget _buildItemAlerta(IconData ico, String mensagem, Color cor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(ico, color: cor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              mensagem,
              style: TextStyle(
                color: cor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
