import 'package:flutter/material.dart';

class ClearButton extends StatefulWidget {
  final Future<void> Function() limparconteudo;
  const ClearButton({super.key, required this.limparconteudo});

  @override
  State<ClearButton> createState() => _ClearButtonState();
}

class _ClearButtonState extends State<ClearButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: isLoading
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: color),
              )
            : const Icon(Icons.clear),
        label: Text(isLoading ? 'Limpando...' : 'Limpar'),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: isLoading
            ? null
            : () async {
                setState(() => isLoading = true);
                try {
                  await widget.limparconteudo();
                } finally {
                  if (mounted) {
                    setState(() => isLoading = false);
                  }
                }
              },
      ),
    );
  }
}
