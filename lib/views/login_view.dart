import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:soilcheck/providers/auth_provider.dart';
import 'package:soilcheck/widgets/loading_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: ClipPath(
                  clipper: BottomLeftClipper(),
                  child: Container(
                    color: Color.fromARGB(255, 19, 102, 35),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/logo.png',
                            height: 200,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _buildTextField(_usernameController, 'Usuário', false,
                            focusNode: _usernameFocusNode,
                            textInputAction: TextInputAction.next,
                            nextFocusNode: _passwordFocusNode),
                        const SizedBox(height: 15),
                        _buildTextField(_passwordController, 'Senha', true,
                            focusNode: _passwordFocusNode,
                            textInputAction: TextInputAction.done),
                        const SizedBox(height: 25),
                        LoadingButton(
                          width: double.infinity,
                          onExecute: () async {
                            var localNavigator = Navigator.of(context);
                            var res = await authProvider.login(
                              _usernameController.text,
                              _passwordController.text,
                            );
                            if (res == 'ok') {
                              if (localNavigator.mounted) {
                                localNavigator.pushReplacementNamed('/home');
                              }
                            } else {
                              if (localNavigator.mounted) {
                                QuickAlert.show(
                                  context: localNavigator.context,
                                  type: QuickAlertType.error,
                                  title: 'Erro ao fazer login',
                                  text: res,
                                );
                              }
                            }
                          },
                          buttonName: 'LOGIN',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, bool isPassword,
      {FocusNode? focusNode,
      TextInputAction? textInputAction,
      FocusNode? nextFocusNode}) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: isPassword ? !_isPasswordVisible : false,
      textInputAction: textInputAction,
      onSubmitted: (value) {
        if (textInputAction != TextInputAction.done) {
          nextFocusNode?.requestFocus();
        }
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(25.7),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF9DB25D)),
          borderRadius: BorderRadius.circular(25.7),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
      ),
    );
  }
}

class BottomLeftClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(0, size.height, 150, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
