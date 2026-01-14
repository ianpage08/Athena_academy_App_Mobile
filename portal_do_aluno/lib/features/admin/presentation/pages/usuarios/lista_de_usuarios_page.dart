import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/usuarios/widgets/filtro_usuarios.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/usuarios/widgets/usuarios_list_stream.dart';
import 'package:portal_do_aluno/features/auth/data/datasouces/cadastro_service.dart';

class ListaDeUsuariosPage extends StatefulWidget {
  const ListaDeUsuariosPage({super.key});

  @override
  State<ListaDeUsuariosPage> createState() => _ListaDeUsuariosPageState();
}

class _ListaDeUsuariosPageState extends State<ListaDeUsuariosPage> {
  final CadastroService _cadastroService = CadastroService();
  String? tipoSelecionado;

  Stream<QuerySnapshot> get minhaListaFiltrada {
    final base = FirebaseFirestore.instance.collection('usuarios');

    if (tipoSelecionado == null) return base.snapshots();

    return base.where('type', isEqualTo: tipoSelecionado).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Lista de Usuários'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // ----------- FILTROS MODERNOS ------------- //
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: FiltroUsuarios(
                tipoSelecionado: tipoSelecionado,
                onSelected: (value) {
                  setState(() {
                    tipoSelecionado = value;
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 6),

          // ----------- LISTA ---------------- //
          UsuariosListStream(
            cadastroService: _cadastroService,
            minhaListaFiltrada: minhaListaFiltrada,
          ),
        ],
      ),
    );
  }
}
