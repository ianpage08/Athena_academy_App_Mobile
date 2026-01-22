import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/tokens_firestore.dart';
import 'package:portal_do_aluno/features/admin/presentation/providers/user_provider.dart';
import 'package:portal_do_aluno/shared/widgets/navigation_menu_card.dart';
import 'package:portal_do_aluno/shared/widgets/firestore/firestore_document_stream_builder.dart';

import 'package:portal_do_aluno/core/user/user.dart';
import 'package:portal_do_aluno/navigation/navigation_service.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool _updateToken = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final argumentos =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (argumentos != null && argumentos['user'] != null) {
        final userId = argumentos['user']['id'];
        Provider.of<UserProvider>(context, listen: false).setUserId(userId);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_updateToken) {
      final argumentos =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (argumentos != null && argumentos['user'] != null) {
        final userId = argumentos['user']['id'];
        TokensService().gerarToken(userId);
        _updateToken = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuarioId = Provider.of<UserProvider>(context).userId;
    if (usuarioId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Administrador'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Row(
                  children: [
                    Expanded(
                      child: FirestoreDocumentStreamBuilder(
                        collectionPath: 'usuarios',
                        documentId: usuarioId,
                        builder: (context, snapshot) {
                          final data = snapshot.data!.data()!;
                          final dadosUsuario = Usuario.fromJson(data);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Color.fromARGB(
                                    255,
                                    88,
                                    70,
                                    20,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Admin: ${dadosUsuario.name}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
                                      Text(
                                        'Escola: AEEC',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleSmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                childAspectRatio: 1.45,
                mainAxisSpacing: 16,
                physics: const BouncingScrollPhysics(),
                children: [
                  // NavigationMenuCard: widget personalizado dos botões do menu.
                  // - NavigationService e RouteNames: controle de rotas e nomes das páginas personalizados.
                  NavigationMenuCard(
                    highlight: true,
                    icon: CupertinoIcons.person_2_square_stack,
                    title: 'Nova Matrícula',
                    subtitle: 'Cadastrar alunos ',
                    onTap: () {
                      NavigatorService.navigateTo(
                        RouteNames.adminMatriculaCadastro,
                      );
                    },
                  ),

                  NavigationMenuCard(
                    icon: CupertinoIcons.home,
                    title: 'Gestão Escolar',
                    subtitle: 'Turmas e disciplinas',
                    onTap: () {
                      NavigatorService.navigateTo(
                        RouteNames.adminGestaoEscolar,
                      );
                    },
                  ),

                  NavigationMenuCard(
                    icon: CupertinoIcons.person_add,
                    title: 'Usuários',
                    subtitle: 'Gerenciar perfis',
                    onTap: () {
                      NavigatorService.navigateTo(RouteNames.adminGestao);
                    },
                  ),

                  NavigationMenuCard(
                    icon: CupertinoIcons.doc_on_doc,
                    title: 'Relatórios',
                    subtitle: 'Certificados',
                    onTap: () {
                      NavigatorService.navigateTo(
                        RouteNames.adminGeracaoDocumentos,
                      );
                    },
                  ),

                  NavigationMenuCard(
                    icon: CupertinoIcons.chat_bubble_2_fill,
                    title: 'Comunicação',
                    subtitle: 'Avisos e comunicados',
                    onTap: () {
                      NavigatorService.navigateTo(
                        RouteNames.adminComunicacaoInstiticional,
                      );
                    },
                  ),

                  NavigationMenuCard(
                    icon: CupertinoIcons.lock_shield,
                    title: 'Segurança',
                    subtitle: 'Permissões e acessos',
                    onTap: () {
                      NavigatorService.navigateTo(
                        RouteNames.adminSegurancaEPermissoes,
                      );
                    },
                  ),

                  NavigationMenuCard(
                    icon: Icons.settings,
                    title: 'Configurações',
                    subtitle: 'Preferências do sistema',
                    onTap: () {
                      NavigatorService.navigateTo(RouteNames.studentSettings);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
