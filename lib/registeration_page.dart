import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
const RegisterPage({super.key});

@override
State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

final _nameController = TextEditingController();
final _emailController = TextEditingController();
final _phoneController = TextEditingController();
final _cityController = TextEditingController();
final _passwordController = TextEditingController();
final _confirmPasswordController = TextEditingController();

bool _isLoading = false;
bool _obscurePassword = true;
bool _obscureConfirmPassword = true;

String? _errorMessage;

@override
void dispose() {

_nameController.dispose();
_emailController.dispose();
_phoneController.dispose();
_cityController.dispose();
_passwordController.dispose();
_confirmPasswordController.dispose();

super.dispose();
}

Future<void> _register() async {

final name = _nameController.text.trim();
final email = _emailController.text.trim();
final phone = _phoneController.text.trim();
final city = _cityController.text.trim();
final password = _passwordController.text.trim();
final confirmPassword = _confirmPasswordController.text.trim();

if (
name.isEmpty ||
email.isEmpty ||
phone.isEmpty ||
city.isEmpty ||
password.isEmpty ||
confirmPassword.isEmpty
) {

setState(() {
_errorMessage = 'Please fill all fields.';
});

return;
}

if (password != confirmPassword) {

setState(() {
_errorMessage = 'Passwords do not match.';
});

return;
}

setState(() {
_isLoading = true;
_errorMessage = null;
});

try {

final credential = await FirebaseAuth.instance
    .createUserWithEmailAndPassword(
email: email,
password: password,
);

final uid = credential.user!.uid;

await FirebaseFirestore.instance
    .collection('users')
    .doc(uid)
    .set({
'name': name,
'email': email,
'phone': phone,
'city': city,
'createdAt': FieldValue.serverTimestamp(),
});

if (!mounted) return;

Navigator.pushReplacement(
context,
MaterialPageRoute(
builder: (_) => const LoginPage(),
),
);

} on FirebaseAuthException catch (e) {

String message = 'Registration failed';

if (e.code == 'email-already-in-use') {
message = 'Email already exists.';
}
else if (e.code == 'weak-password') {
message = 'Password is too weak.';
}
else if (e.code == 'invalid-email') {
message = 'Invalid email.';
}

setState(() {
_errorMessage = message;
});

} catch (e) {

setState(() {
_errorMessage = e.toString();
});

} finally {

if (mounted) {

setState(() {
_isLoading = false;
});
}
}
}

@override
Widget build(BuildContext context) {

return Scaffold(
backgroundColor: const Color(0xFF181818),

body: SafeArea(
child: SingleChildScrollView(

padding: const EdgeInsets.symmetric(
horizontal: 32,
vertical: 40,
),

child: Column(
children: [

const SizedBox(height: 20),

const Text(
'Blackwood',
style: TextStyle(
fontFamily: 'Alura',
fontSize: 54,
color: Color(0xFFD5AE33),
),
),

const Text(
'Create Account',
style: TextStyle(
color: Colors.white70,
fontSize: 16,
),
),

const SizedBox(height: 40),

_buildInputField(
controller: _nameController,
label: 'Full Name',
icon: Icons.person_outline,
),

const SizedBox(height: 18),

_buildInputField(
controller: _emailController,
label: 'Email',
icon: Icons.email_outlined,
keyboardType: TextInputType.emailAddress,
),

const SizedBox(height: 18),

_buildInputField(
controller: _phoneController,
label: 'Phone',
icon: Icons.phone_outlined,
keyboardType: TextInputType.phone,
),

const SizedBox(height: 18),

_buildInputField(
controller: _cityController,
label: 'City',
icon: Icons.location_city_outlined,
),

const SizedBox(height: 18),

_buildInputField(
controller: _passwordController,
label: 'Password',
icon: Icons.lock_outline,
obscureText: _obscurePassword,
suffixIcon: IconButton(
icon: Icon(
_obscurePassword
? Icons.visibility_off
    : Icons.visibility,
color: const Color(0xFFD5AE33),
),
onPressed: () {
setState(() {
_obscurePassword = !_obscurePassword;
});
},
),
),

const SizedBox(height: 18),

_buildInputField(
controller: _confirmPasswordController,
label: 'Confirm Password',
icon: Icons.lock_outline,
obscureText: _obscureConfirmPassword,
suffixIcon: IconButton(
icon: Icon(
_obscureConfirmPassword
? Icons.visibility_off
    : Icons.visibility,
color: const Color(0xFFD5AE33),
),
onPressed: () {
setState(() {
_obscureConfirmPassword =
!_obscureConfirmPassword;
});
},
),
),

const SizedBox(height: 24),

if (_errorMessage != null)
Text(
_errorMessage!,
style: const TextStyle(
color: Colors.redAccent,
),
),

const SizedBox(height: 20),

GestureDetector(
onTap: _isLoading ? null : _register,

child: Container(
width: double.infinity,
height: 55,

decoration: BoxDecoration(
color: const Color(0xFFD5AE33),
borderRadius: BorderRadius.circular(30),
),

child: Center(
child: _isLoading
? const CircularProgressIndicator(
color: Colors.black,
)
    : const Text(
'Create Account',
style: TextStyle(
color: Colors.black,
fontSize: 22,
fontWeight: FontWeight.bold,
fontFamily: 'Alura',
),
),
),
),
),

const SizedBox(height: 20),

TextButton(
onPressed: () {

Navigator.pushReplacement(
context,
MaterialPageRoute(
builder: (_) => const LoginPage(),
),
);
},

child: const Text(
'Already have an account? Login',
style: TextStyle(
color: Color(0xFFD5AE33),
),
),
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
border: Border.all(
color: const Color(0xFFD5AE33).withOpacity(0.3),
),
),

child: TextField(

controller: controller,
obscureText: obscureText,
keyboardType: keyboardType,

style: const TextStyle(
color: Colors.white,
),

decoration: InputDecoration(

labelText: label,

labelStyle: const TextStyle(
color: Colors.white38,
),

prefixIcon: Icon(
icon,
color: const Color(0xFFD5AE33),
),

suffixIcon: suffixIcon,

border: InputBorder.none,

contentPadding: const EdgeInsets.symmetric(
horizontal: 12,
vertical: 16,
),
),
),
);
}
}

