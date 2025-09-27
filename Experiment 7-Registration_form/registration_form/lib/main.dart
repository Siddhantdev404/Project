// lib/main.dart
import 'package:flutter/material.dart';
import 'dart:developer'; // Added to use log() instead of print()

// --- MAIN ENTRY POINT ---
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

// ----------------------------------------------------------------------
// 1. APPLICATION ROOT WIDGET
// ----------------------------------------------------------------------

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Creative Registration App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'OpenSans',
        visualDensity: VisualDensity.adaptivePlatformDensity,

        // Custom Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          // FIX: Alpha calculation for 0.95 opacity (255 * 0.95 = 242)
          fillColor: Colors.white.withAlpha(242),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.deepPurpleAccent,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          labelStyle: TextStyle(color: Colors.grey[700]),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
        ),

        // Custom Elevated Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            elevation: 5,
          ),
        ),
      ),
      home: const RegistrationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ----------------------------------------------------------------------
// 2. SCREEN LAYOUT (Background and Wrapper)
// ----------------------------------------------------------------------

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  // Helper widget for background circles
  Widget _buildGradientCircle(double size, List<Color> colors) {
    return AnimatedContainer(
      duration: const Duration(seconds: 3),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: colors),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Alpha value for 0.2 opacity is 51 (255 * 0.2 = 51)
    const int alpha51 = 51;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // Main Screen Gradient Background
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE0E7FF), // Light Indigo
              Color(0xFFFAF5FF), // Pale Purple
              Color(0xFFFDF2F8), // Pale Pink
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background Elements - Corrected all .withOpacity() calls
            Positioned(
              top: -160,
              left: -160,
              child: _buildGradientCircle(320, [
                Colors.purple.withAlpha(alpha51),
                Colors.pink.withAlpha(alpha51),
              ]),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.25,
              right: -80,
              child: _buildGradientCircle(240, [
                Colors.blue.withAlpha(alpha51),
                Colors.cyan.withAlpha(alpha51),
              ]),
            ),

            // Main Content Area (Scrollable Form)
            const SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: RegistrationForm(), // The actual form widget
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// 3. REGISTRATION FORM WIDGET (Stateful for Logic)
// ----------------------------------------------------------------------

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  // Text field controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Field values
  String? _gender;
  String? _country;
  bool _acceptTerms = false;

  final List<String> _countries = [
    'USA',
    'Canada',
    'UK',
    'Australia',
    'Germany',
    'India',
    'Other',
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please accept the terms and conditions.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Success feedback (UX)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registering ${_emailController.text}...'),
          backgroundColor: Colors.deepPurpleAccent,
        ),
      );

      // Logging using log()
      log('--- REGISTRATION DATA ---');
      log('Full Name: ${_fullNameController.text}');
      log('Email: ${_emailController.text}');
      log('Gender: $_gender');
      log('Country: $_country');
      log('Accepted Terms: $_acceptTerms');
      log('-------------------------');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Create Your Account',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 30),

              // Full Name Field (Text)
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter your full name'
                    : null,
              ),
              const SizedBox(height: 20),

              // Email Field (Text)
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  // Added curly braces for flow control style guide
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email address';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Password Field (Text)
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) => (value == null || value.length < 8)
                    ? 'Password must be at least 8 characters'
                    : null,
              ),
              const SizedBox(height: 20),

              // Confirm Password Field (Text)
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock_reset),
                ),
                validator: (value) {
                  // Added curly braces for flow control style guide
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Gender Radio Buttons (Radio)
              // FIX: Reverted to the clean RadioListTile structure to resolve lingering warnings
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Gender:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              RadioListTile<String>(
                title: const Text('Male'),
                value: 'Male',
                // ignore: deprecated_member_use
                groupValue: _gender,
                // ignore: deprecated_member_use
                onChanged: (String? value) => setState(() => _gender = value),
                activeColor: Colors.deepPurpleAccent,
              ),
              RadioListTile<String>(
                title: const Text('Female'),
                value: 'Female',
                // ignore: deprecated_member_use
                groupValue: _gender,
                // ignore: deprecated_member_use
                onChanged: (String? value) => setState(() => _gender = value),
                activeColor: Colors.deepPurpleAccent,
              ),
              RadioListTile<String>(
                title: const Text('Prefer not to say'),
                value: 'Prefer not to say',
                // ignore: deprecated_member_use
                groupValue: _gender,
                // ignore: deprecated_member_use
                onChanged: (String? value) => setState(() => _gender = value),
                activeColor: Colors.deepPurpleAccent,
              ),
              const SizedBox(height: 20),

              // Country Dropdown (Dropdown)
              DropdownButtonFormField<String>(
                // Reverted to 'initialValue' to clear the confusing analyzer warning
                initialValue: _country,
                decoration: const InputDecoration(
                  labelText: 'Country',
                  prefixIcon: Icon(Icons.public),
                ),
                hint: const Text('Select your country'),
                items: _countries.map((String country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
                onChanged: (String? newValue) =>
                    setState(() => _country = newValue),
                validator: (value) =>
                    (value == null) ? 'Please select your country' : null,
              ),
              const SizedBox(height: 20),

              // Terms and Conditions Checkbox (Checkbox)
              Row(
                children: [
                  Checkbox(
                    value: _acceptTerms,
                    onChanged: (bool? newValue) =>
                        setState(() => _acceptTerms = newValue ?? false),
                    activeColor: Colors.deepPurpleAccent,
                  ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'I agree to the ',
                        style: TextStyle(color: Colors.grey[800]),
                        children: [
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Navigating to Terms & Conditions...',
                                    ),
                                    backgroundColor: Colors.blueAccent,
                                  ),
                                );
                              },
                              child: const Text(
                                'Terms & Conditions',
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Register Button
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Register Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
