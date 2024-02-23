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
      backgroundColor: Colors.white, // Background is white
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: ClipPath(
                  clipper: BottomLeftClipper(), // Custom clipper defined below
                  child: Container(
                    color: Color.fromARGB(
                        255, 19, 102, 35), // Top part with new color
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
      TextEditingController controller, String label, bool obscureText) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(25.7),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: Color(0xFF9DB25D)), // Focus border color
          borderRadius: BorderRadius.circular(25.7),
        ),
      ),
    );
  }
}

class BottomLeftClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 200); // Start from the top left corner
    path.quadraticBezierTo(0, size.height, 200, size.height); // Create the curve
    path.lineTo(size.width, size.height); // Bottom edge
    path.lineTo(size.width, 0); // Right edge
    path.close(); // Completes the path to the starting point
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
