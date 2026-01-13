import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class FormHeaderComunicado extends StatelessWidget {
  const FormHeaderComunicado({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.campaign,
            color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          'Novo Comunicado',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
