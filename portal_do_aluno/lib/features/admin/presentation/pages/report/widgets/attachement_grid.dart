import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/widgets/full_screen.dart';

class AttachementGrid extends StatelessWidget {
  final List<String> attachments;
  

  const AttachementGrid({super.key, required this.attachments, });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: attachments.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final url = attachments[index];

        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _openImage(context, url),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    url,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey.withValues(alpha: 0.10),
                        child: const Center(
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) {
                      return Container(
                        color: Colors.grey.withValues(alpha: 0.12),
                        child: Center(
                          child: Icon(
                            Icons.broken_image_rounded,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.open_in_full_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  void _openImage(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FullscreenImagePage(url: url)),
    );
  }
}
