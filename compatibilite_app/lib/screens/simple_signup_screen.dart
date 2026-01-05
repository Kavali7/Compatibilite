import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_background.dart';

/// Simple signup screen - only requires email, password, and name
/// No couple information required for basic account creation
class SimpleSignupScreen extends StatefulWidget {
  const SimpleSignupScreen({super.key});

  @override
  State<SimpleSignupScreen> createState() => _SimpleSignupScreenState();
}

class _SimpleSignupScreenState extends State<SimpleSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await AuthService.instance.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
      );

      if (user != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Compte créé avec succès !'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(true); // Return true to indicate success
        }
      } else {
        setState(() {
          _errorMessage = 'Erreur lors de la création du compte';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Créer un compte',
            style: GoogleFonts.philosopher(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textLight,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Rejoignez-nous',
                    style: GoogleFonts.philosopher(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Créez votre compte pour accéder à tous nos services de compatibilité et prévisions.',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                  
                  const SizedBox(height: 32),

                  // Name field
                  _buildLabel('Votre nom'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: AppColors.textLight),
                    decoration: _inputDecoration(
                      hint: 'Prénom ou pseudo',
                      icon: Icons.person,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez entrer votre nom';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Email field
                  _buildLabel('Adresse email'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: AppColors.textLight),
                    decoration: _inputDecoration(
                      hint: 'exemple@email.com',
                      icon: Icons.email,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez entrer votre email';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Veuillez entrer un email valide';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Password field
                  _buildLabel('Mot de passe'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: AppColors.textLight),
                    decoration: _inputDecoration(
                      hint: 'Minimum 6 caractères',
                      icon: Icons.lock,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          color: AppColors.textMuted,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un mot de passe';
                      }
                      if (value.length < 6) {
                        return 'Le mot de passe doit contenir au moins 6 caractères';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Confirm password field
                  _buildLabel('Confirmer le mot de passe'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    style: const TextStyle(color: AppColors.textLight),
                    decoration: _inputDecoration(
                      hint: 'Répétez le mot de passe',
                      icon: Icons.lock_outline,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                          color: AppColors.textMuted,
                        ),
                        onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                    ),
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Les mots de passe ne correspondent pas';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  // Error message
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Signup button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signup,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Créer mon compte',
                              style: GoogleFonts.philosopher(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Already have account
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Déjà un compte ? Se connecter',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textLight,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textMuted),
      prefixIcon: Icon(icon, color: AppColors.primary),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.block.withValues(alpha: 0.6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }
}
