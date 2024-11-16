import 'package:flutter/material.dart';
import 'package:swing_app/services/auth_service.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _swingIdController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  String _errorMessage = '';

  // Function to handle user registration
  void _registerUser() async {
    final name = _nameController.text;
    final swingId = _swingIdController.text;
    final password = _passwordController.text;

    if (name.isEmpty || swingId.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "Please fill in all fields.";
      });
      return;
    }

    final result = await _authService.register(name, swingId, password);
    if (result['error'] != null) {
      setState(() {
        _errorMessage = result['error'];
      });
    } else {
      // Successful registration logic here, like navigating to the next screen
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  // Function to navigate to the login screen
  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Account')),
      body: SingleChildScrollView(
        // Wrap the body with SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tagline
            const Text(
              'Ab chote dream chodo, swing karo',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),

            const Text(
              'The Future of Fantasy Cricket.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 40),

            // Name Field
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Swing ID Field
            TextField(
              controller: _swingIdController,
              decoration: InputDecoration(
                labelText: 'Swing ID (@username)',
                hintText: 'Enter your Swing ID (e.g., @john_doe)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Password Field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Error Message (if any)
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),

            // Create Account Button
            ElevatedButton(
              onPressed: _registerUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4169E1), // Royal Blue
                padding: const EdgeInsets.symmetric(
                    vertical: 15), // Increased padding
                minimumSize: Size(double.infinity,
                    50), // Ensure the button takes full width and is taller
              ),
              child: const Text(
                'Create Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Link to Login Page
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account? ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: _navigateToLogin, // Use the navigation function here
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Color(0xFF4169E1),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
