// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:soilcheck/models/user.dart';
import 'package:soilcheck/providers/user_provider.dart';

class CreateUser extends StatefulWidget {
  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Usuário'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Usuário'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),
              TextField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Confirmar Senha'),
                obscureText: true,
              ),
              CheckboxListTile(
                title: const Text('Administrador'),
                value: isAdmin,
                onChanged: (bool? value) {
                  if (value != null) {
                    setState(() {
                      isAdmin = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  final User user = User(
                    name: _nameController.text,
                    password: _passwordController.text,
                    username: _usernameController.text,
                    isAdmin: isAdmin,
                    isActive: true,
                  );
                  Provider.of<UserProvider>(context, listen: false)
                      .createUser(user)
                      .then((_) {
                    Navigator.of(context).pop();
                  });
                },
                child: const Text('Criar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
