// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soilcheck/models/user.dart';
import 'package:soilcheck/providers/user_provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? userData;
  int? userChecks;

  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false)
        .getUserById()
        .then((user) {
      if (mounted) {
        setState(() {
          userData = user;
        });
      }
    });
    Provider.of<UserProvider>(context, listen: false)
        .countChecks()
        .then((count) {
      if (mounted) {
        setState(() {
          userChecks = count;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const double imageHeight = 150.0;
    bool isLoading = userData == null || userChecks == null;

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
                        'assets/images/profilePageBG.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    child: Container(
                      color: const Color(0xFFf1f1f1),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 16.0),
                          Text(
                            userData?.name ?? '',
                            style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 46, 57, 31)),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            textAlign: TextAlign.start,
                            "${userChecks ?? ''} ${userChecks == 1 ? ' verificação realizada' : ' verificações realizadas'}",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 46, 57, 31)),
                          ),
                          const SizedBox(height: 32.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _openNameChangeDialog();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 130, 222, 250),
                                ),
                                label: const Text('Editar nome'),
                              ),
                              const SizedBox(width: 16.0),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.lock_person),
                                onPressed: () {
                                  _openPasswordChangeDialog();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 130, 222, 255),
                                ),
                                label: const Text('Trocar senha'),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _openNameChangeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _nameController = TextEditingController();
        return AlertDialog(
          title: const Text('Editar nome'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Novo nome',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Provider.of<UserProvider>(context, listen: false)
                      .updateUserName(_nameController.text)
                      .then((res) {
                    Navigator.of(context).pop();
                    String message;
                    if (res) {
                      message = 'Nome atualizado com sucesso';
                    } else {
                      message = 'Erro ao atualizar nome';
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                      ),
                    );
                  });
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openPasswordChangeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _passwordController =
            TextEditingController();
        final TextEditingController _oldPasswordController =
            TextEditingController();
        bool _isNewPasswordVisible = false;
        bool _isOldPasswordVisible = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Trocar senha'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isNewPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Nova senha',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isNewPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isNewPasswordVisible = !_isNewPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  TextField(
                    controller: _oldPasswordController,
                    obscureText: !_isOldPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Senha atual',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isOldPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isOldPasswordVisible = !_isOldPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<UserProvider>(context, listen: false)
                          .updatePassword(_passwordController.text,
                              _oldPasswordController.text)
                          .then((res) {
                        Navigator.of(context).pop();
                        String message;
                        if (res) {
                          message = 'Senha atualizada com sucesso';
                        } else {
                          message = 'Erro ao atualizar senha';
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                          ),
                        );
                      });
                    },
                    child: const Text('Salvar'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
