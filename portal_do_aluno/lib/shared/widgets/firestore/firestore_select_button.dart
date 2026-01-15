import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/providers/selected_provider.dart';
import 'package:provider/provider.dart';

class FirestoreSelectButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final selectedProvider = context.watch<SelectedProvider>();
    final displayText = selectedProvider.getNome(dropId) ?? textLabel;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: minhaStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text(mensagemError);
        }

        final docs = snapshot.data!.docs;

        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _abrirModal(context, docs),
          child: Container(
            width: double.infinity,
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
                icon,
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    displayText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(CupertinoIcons.chevron_down, size: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  void _abrirModal(
    BuildContext context,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Selecione um item',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final item = docs[index];
                    final nomeItem = item[nomeCampo] ?? '';

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1,
                          ),
                        ),
                        child: ListTile(
                          leading: icon,
                          title: Text(nomeItem),
                          onTap: () {
                            context.read<SelectedProvider>().selectItem(
                              dropId,
                              item.id,
                              nomeItem,
                            );

                            onSelected?.call(item.id, nomeItem);

                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
