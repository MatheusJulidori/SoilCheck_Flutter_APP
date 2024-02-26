import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
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
                child: Container(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _buildTextField(_usernameController, 'Email', false),
                      const SizedBox(height: 15),
                      _buildTextField(_passwordController, 'Password', true),
                      const SizedBox(height: 25),
                      LoadingButton(
                        onExecute: () async {
                          // Login logic
                        },
                        buttonName: 'LOGIN',
                        // Button color
                      ),
                    ],
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
    TextEditingController controller, String label, bool isPassword) {
  return TextField(
    controller: controller,
    obscureText: isPassword ? !_isPasswordVisible : false,
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
                // Toggle the icon based on password visibility
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                // Update the password visibility state
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
