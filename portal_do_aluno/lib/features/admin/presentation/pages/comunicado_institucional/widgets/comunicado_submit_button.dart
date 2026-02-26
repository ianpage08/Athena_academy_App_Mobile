import 'package:flutter/material.dart';

class ComunicadoSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSubmit;

  const ComunicadoSubmitButton({
    super.key,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onSubmit,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send, size: 20, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'Enviar Comunicado',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
