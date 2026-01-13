import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/providers/selected_provider.dart';
import 'package:provider/provider.dart';

class FirestoreSelectButton extends StatefulWidget {
  final String dropId;
  final String textLabel;
  final Icon icon;
  final Stream<QuerySnapshot<Map<String, dynamic>>> minhaStream;
  final String nomeCampo;
  final String mensagemError;
  final void Function(String id, String nome)? onSelected;

  const FirestoreSelectButton({
    super.key,
    required this.dropId,
    required this.minhaStream,
    required this.textLabel,
    required this.icon,
    required this.nomeCampo,
    required this.mensagemError,
    this.onSelected,
  });

  @override
  State<FirestoreSelectButton> createState() => _FirestoreSelectButtonState();
}

class _FirestoreSelectButtonState extends State<FirestoreSelectButton> {
  @override
  Widget build(BuildContext context) {
    final selectedProvider = context.watch<SelectedProvider>();
    final displayText =
        selectedProvider.getNome(widget.dropId) ?? widget.textLabel;

    debugPrint(
      ' FirestoreSelectButton(${widget.dropId}): displayText = $displayText',
    );

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: widget.minhaStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text(widget.mensagemError));
        }

        final docs = snapshot.data!.docs;

        return SizedBox(
          width: double.infinity,
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        'Selecione um item',
                        style: TextStyle(fontSize: 20),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final item = docs[index];
                            final nomeItem = item[widget.nomeCampo] ?? '';

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    context.read<SelectedProvider>().selectItem(
                                      widget.dropId,
                                      item.id,
                                      nomeItem,
                                    );

                                    if (widget.onSelected != null) {
                                      widget.onSelected!(item.id, nomeItem);
                                    }

                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          widget.icon.icon,
                                          color: Theme.of(
                                            context,
                                          ).iconTheme.color,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          nomeItem,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  widget.icon,
                  const SizedBox(width: 8),
                  Text(
                    displayText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  const Icon(CupertinoIcons.chevron_down, size: 16),
                ],
              ),
            ),

            /*TextButton.icon(
              icon: widget.icon,
              label: Text(displayText, style: const TextStyle(fontSize: 16)),
              style: Theme.of(context).textButtonTheme.style,
              onPressed: () {
                
              },
            ),*/
          ),
        );
      },
    );
  }
}
