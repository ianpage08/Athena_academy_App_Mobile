import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/data/models/comunicado.dart';
class Switch{
  String labelPrioridade(PrioridadeComunicado nivel) {
  switch (nivel) {
    case PrioridadeComunicado.baixa:
      return 'Baixa';
    case PrioridadeComunicado.media:
      return 'Média';
    case PrioridadeComunicado.alta:
      return 'Alta';
  }
}

Color corPrioridade(PrioridadeComunicado nivel) {
  switch (nivel) {
    case PrioridadeComunicado.baixa:
      return Colors.green;
    case PrioridadeComunicado.media:
      return Colors.orange;
    case PrioridadeComunicado.alta:
      return Colors.red;
  }
}

IconData iconePrioridade(PrioridadeComunicado nivel) {
  switch (nivel) {
    case PrioridadeComunicado.baixa:
      return Icons.arrow_downward;
    case PrioridadeComunicado.media:
      return Icons.remove;
    case PrioridadeComunicado.alta:
      return Icons.arrow_upward;
  }
}

}
