// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soilcheck/models/user.dart';
import 'package:soilcheck/providers/user_provider.dart';

class AdminPanel extends StatefulWidget {
  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  List<User>? userList;

  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false)
        .getAllUsers()
        .then((user) {
      if (mounted) {
        setState(() {
          userList = user;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const double imageHeight = 150.0;
    bool isLoading = userList == null;

    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: imageHeight,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.asset(
                        'assets/images/adminPanelBG.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 16.0),
                          const Text(
                            'Usuários',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Expanded(
                            child: ListView.builder(
                              itemCount: userList!.length,
                              itemBuilder: (context, index) {
                                final user = userList![index];
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF51A468),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              user.name,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.edit,
                                                  color: Colors.white),
                                              onPressed: () {
                                                _openEditUserDialog(user);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF258F42),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10.0),
                                            bottomRight: Radius.circular(10.0),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Admin: ${user.isAdmin ? "Yes" : "No"}',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'Active: ${user.isActive ? "Yes" : "No"}',
                                              style: const TextStyle(
                                                  color: Colors.white),
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
                ],
              ),
      ),
    );
  }

  void _openEditUserDialog(User user) {
    showDialog(
      context: context,
      builder: (context) {
        final buttonText =
            user.isAdmin ? 'Remover Admin' : 'Tornar Admin';
        final buttonText2 =
            user.isActive ? 'Desativar Usuário' : 'Ativar Usuário';
        return AlertDialog(
          title: const Text('Editar Usuário'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Provider.of<UserProvider>(context, listen: false)
                      .updateUserAdminStatus(user.id!, user.isAdmin)
                      .then((res) {
                    Navigator.of(context).pop();
                    String message;
                    if (res) {
                      message = 'Permissões atualizadas com sucesso';
                    } else {
                      message = 'Erro ao atualizar permissões';
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                      ),
                    );
                  });
                },
                child: Text(buttonText),
              ),
              ElevatedButton(
                onPressed: () {
                  Provider.of<UserProvider>(context, listen: false)
                      .updateUserAdminStatus(user.id!, user.isAdmin)
                      .then((res) {
                    Navigator.of(context).pop();
                    String message;
                    if (res) {
                      message = 'Usuário atualizado com sucesso';
                    } else {
                      message = 'Erro ao atualizar usuário';
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                      ),
                    );
                  });
                },
                child: Text(buttonText2),
              ),
            ],
          ),
        );
      },
    );
  }
}
