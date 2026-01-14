import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/helper/limitar_tamanho_texto.dart';

class CardExercicio extends StatelessWidget {
  final String titulo;
  final String conteudo;
  final String nomeProfessor;
  final String userId;
  final String exerciciosId;
  final Future<bool> Function(String userId, String exerciciosId) getStatusEntregue;

  const CardExercicio({super.key, required this.titulo, required this.conteudo, required this.nomeProfessor, required this.userId, required this.exerciciosId, required this.getStatusEntregue});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: getStatusEntregue(userId, exerciciosId),
      builder: (context, snapshot) {
        final status = snapshot.data ?? false;
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(55, 88, 87, 87)),
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).cardTheme.color,
          ),
          height: 82,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        limitarCampo('Exercicio de: $titulo', 30),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(limitarCampo(conteudo, 30)),
                      Text('Professor: $nomeProfessor'),
                    ],
                  ),
                ),
              ),
              Container(
                height: 100,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  color: status == true
                      ? Colors.green
                      : const Color.fromARGB(255, 26, 110, 236),
                ),

                child: Icon(
                  status == true
                      ? CupertinoIcons.check_mark
                      : CupertinoIcons.arrow_right,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}