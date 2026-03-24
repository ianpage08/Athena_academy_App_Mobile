import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/app_constants/colors.dart';

/// Botão de ação assíncrona premium para o Athena Academy.
///
/// Arquitetura e Segurança:
/// - Gerencia o próprio estado de loading, mantendo a tela pai limpa.
/// - Implementa proteção de ciclo de vida (`mounted`) para evitar crashes
///   caso a tela seja fechada enquanto a ação ainda está processando.
/// - Utiliza o bloco `finally` para garantir que o botão sempre saia do
///   estado de loading, mesmo se a API falhar.
class SaveButton extends StatefulWidget {
  final Future<void> Function() onSave;

  /// Textos customizáveis para aumentar a reutilização no app
  final String label;
  final String loadingLabel;
  final IconData icon;

  const SaveButton({
    super.key,
    required this.onSave,
    this.label = 'Salvar',
    this.loadingLabel = 'Salvando...',
    this.icon = Icons.save_rounded, // Ícone com bordas arredondadas (moderno)
  });

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  bool _isLoading = false;

  /// Método isolado para gerenciar a lógica do clique com segurança
  Future<void> _handlePress() async {
    // Previne múltiplos cliques enquanto já está salvando
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      await widget.onSave();
    } catch (e) {
      // Aqui você loga o erro, mas não retorna imediatamente
      debugPrint('Erro na execução do SaveButton: $e');
    } finally {
      
      // Se o onSave() fez a tela fechar (Navigator.pop), o widget é destruído.
      // Chamar setState num widget destruído causa um erro fatal (Crash).
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    
    
    final onPrimaryColor =
        theme.colorScheme.onPrimary; // Cor feita para contrastar com o primary

    return SizedBox(
      width: double.infinity,
      height:
          54, 
      child: ElevatedButton.icon(
        
        // Aqui fazemos apenas pequenos ajustes locais para esse botão específico.
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightButtonPrimary,
          foregroundColor: onPrimaryColor,
          elevation: 0, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14), 
          ),
        ),
        onPressed: _isLoading ? null : _handlePress,
        icon: _isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  
                  color: onPrimaryColor.withValues(alpha: 0.7),
                  strokeWidth: 2.5,
                ),
              )
            : Icon(widget.icon, size: 22),
        label: Text(
          _isLoading ? widget.loadingLabel : widget.label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600, 
            letterSpacing:
                0.5, 
          ),
        ),
      ),
    );
  }
}
