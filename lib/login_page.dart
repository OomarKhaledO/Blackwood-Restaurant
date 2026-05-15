import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please enter your email and password.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      if (!mounted) return;

      if (query.docs.isEmpty) {
        setState(() => _errorMessage = 'Invalid email or password.');
      } else {
        final userData = query.docs.first.data();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => RestaurantHomePage(userData: userData)),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'Login failed. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    setState(() => _errorMessage = 'To reset your password, please contact the restaurant admin.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // Decorative gold top bar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(height: 6, color: const Color(0xFFD5AE33)),
              ),

              // Main content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),

                    // Restaurant name header
                    const Text(
                      'Blackwood',
                      style: TextStyle(
                        fontFamily: 'Alura',
                        fontSize: 54,
                        color: Color(0xFFD5AE33),
                        letterSpacing: 2,
                      ),
                    ),
                    const Text(
                      'Restaurant',
                      style: TextStyle(
                        fontFamily: 'Alura',
                        fontSize: 28,
                        color: Colors.white54,
                        letterSpacing: 4,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Gold divider
                    Container(width: 100, height: 2, color: const Color(0xFFD5AE33)),

                    const SizedBox(height: 50),

                    // Welcome text
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontFamily: 'Alura',
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Sign in to continue',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white38,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Email field
                    _buildInputField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 18),

                    // Password field
                    _buildInputField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: const Color(0xFFD5AE33),
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: _resetPassword,
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Color(0xFFD5AE33),
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFFD5AE33),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Error message
                    if (_errorMessage != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.withOpacity(0.4)),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    if (_errorMessage != null) const SizedBox(height: 18),

                    // Login button
                    GestureDetector(
                      onTap: _isLoading ? null : _login,
                      child: Container(
                        width: double.infinity,
                        height: 54,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD5AE33),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFD5AE33).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: _isLoading
                              ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2.5,
                            ),
                          )
                              : const Text(
                            'Sign In',
                            style: TextStyle(
                              fontFamily: 'Alura',
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),

              // Decorative gold bottom bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(height: 6, color: const Color(0xFFD5AE33)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF221919),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD5AE33).withOpacity(0.3)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white38, fontFamily: 'Alura', fontSize: 16),
          prefixIcon: Icon(icon, color: const Color(0xFFD5AE33), size: 20),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          floatingLabelStyle: const TextStyle(color: Color(0xFFD5AE33), fontSize: 13),
        ),
        cursorColor: const Color(0xFFD5AE33),
      ),
    );
  }
}