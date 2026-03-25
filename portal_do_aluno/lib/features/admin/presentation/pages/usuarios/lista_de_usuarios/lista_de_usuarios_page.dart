import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// 👉 MUDANÇA 1: Importações organizadas e semânticas
import 'widgets/filtro_usuarios.dart';
import 'widgets/usuarios_list_stream.dart';
import '../../../../../auth/data/datasources/cadastro_service.dart';

class ListaDeUsuariosPage extends StatefulWidget {
  const ListaDeUsuariosPage({super.key});

  @override
  State<ListaDeUsuariosPage> createState() => _ListaDeUsuariosPageState();
}

class _ListaDeUsuariosPageState extends State<ListaDeUsuariosPage> {
  // Instância do serviço centralizada para evitar múltiplas criações
  final CadastroService _cadastroService = CadastroService();

  // 👉 MUDANÇA 2: Estado privado para melhor encapsulamento
  String? _tipoSelecionado;

  // 👉 MUDANÇA 3: Lógica de Query extraída do build para manter a UI pura
  // DICA: Em uma arquitetura Pro, isso viria de um BLoC ou Controller
  Stream<QuerySnapshot> get _usuariosStream {
    final collection = FirebaseFirestore.instance.collection('usuarios');

    // Adicionado ordenação por nome como padrão de qualidade UX
    if (_tipoSelecionado == null) {
      return collection.snapshots();
    }

    return collection.where('type', isEqualTo: _tipoSelecionado).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // 👉 MUDANÇA 4: AppBar Futurista (Transparente e com Tipografia Refinada)
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle:
            false, // Títulos à esquerda transmitem modernidade em Dashboards
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Gestão de Usuários',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w800,
              fontSize: 24,
              letterSpacing: -0.8, // Toque tipográfico premium
            ),
          ),
        ),
        actions: [
          // Espaço para futuras interações como busca ou exportação
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.tune_rounded,
            ), // Ícone mais moderno que o padrão
            color: theme.primaryColor,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 👉 MUDANÇA 5: Título de seção para guiar o olhar do usuário
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Text(
              "Filtrar por categoria",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Filtros Modernos (já preparados para o novo padrão de scroll horizontal)
          FiltroUsuarios(
            tipoSelecionado: _tipoSelecionado,
            onSelected: (value) => setState(() => _tipoSelecionado = value),
          ),

          const SizedBox(height: 16),

          // 👉 MUDANÇA 6: Container de Lista com efeito "Sheet" (Camada Superior)
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                // Uso inteligente de cor de fundo para separar controles do conteúdo
                color: theme.canvasColor.withValues(alpha: 0.5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
                child: UsuariosListStream(
                  cadastroService: _cadastroService,
                  minhaListaFiltrada: _usuariosStream,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
