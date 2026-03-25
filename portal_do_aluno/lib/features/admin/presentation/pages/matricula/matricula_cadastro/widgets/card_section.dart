import 'package:flutter/material.dart';

class CardSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const CardSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(
        bottom: 24,
      ), 
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(
          24,
        ), 
        border: Border.all(
          
          color: theme.colorScheme.primary.withValues(
            alpha: isDark ? 0.1 : 0.05,
          ),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER DA SEÇÃO
            _buildHeader(theme),

            // CONTEÚDO (Children)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                
                children: _buildChildrenWithSpacing(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- MÉTODOS DE CONSTRUÇÃO ---

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.03),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildChildrenWithSpacing() {
    if (children.isEmpty) return [];

    
    return List.generate(children.length, (index) {
      return Padding(
        padding: EdgeInsets.only(bottom: index == children.length - 1 ? 0 : 16),
        child: children[index],
      );
    });
  }
}
