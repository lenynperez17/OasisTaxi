import 'package:flutter/material.dart';
// ignore_for_file: library_private_types_in_public_api
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;
import '../../core/theme/modern_theme.dart';
import '../../widgets/animated/modern_animated_widgets.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codeController = TextEditingController();
  
  late AnimationController _backgroundController;
  late AnimationController _formController;
  late AnimationController _iconController;
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _showTwoFactor = false;
  
  @override
  void initState() {
    super.initState();
    
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
    
    _formController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
    
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _formController.dispose();
    _iconController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Simular verificación de credenciales
      await Future.delayed(const Duration(seconds: 2));
      
      // Verificar credenciales de admin
      if (_emailController.text == 'admin@oasistaxiadmin.com' &&
          _passwordController.text == 'admin123') {
        
        // Mostrar pantalla de 2FA
        if (mounted) {
          setState(() {
            _showTwoFactor = true;
            _isLoading = false;
          });
        }
      } else {
        // Error de credenciales
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Credenciales de administrador inválidas'),
            backgroundColor: ModernTheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }
  
  /// Verificación 2FA real con Firebase Admin Verification
  Future<void> _verify2FA() async {
    final code = _codeController.text.trim();
    
    if (code.isEmpty) {
      _showSnackBar('Ingrese el código de verificación', ModernTheme.error);
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      // Verificar código 2FA con Firebase Functions
      final response = await http.post(
        Uri.parse('https://us-central1-oasistaxiperu.cloudfunctions.net/verifyAdminCode'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await FirebaseAuth.instance.currentUser?.getIdToken()}',
        },
        body: json.encode({
          'code': code,
          'email': _emailController.text,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['valid'] == true) {
          // Establecer custom claims de admin
          await _setAdminClaims();
          
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/admin/dashboard');
        } else {
          _showSnackBar('Código de verificación inválido o expirado', ModernTheme.error);
        }
      } else {
        _showSnackBar('Error del servidor. Inténtelo nuevamente.', ModernTheme.error);
      }
      
    } catch (e) {
      debugPrint('Error verificando 2FA: $e');
      _showSnackBar('Error de conexión. Verifique su internet.', ModernTheme.error);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  /// Establecer custom claims de administrador
  Future<void> _setAdminClaims() async {
    try {
      await http.post(
        Uri.parse('https://us-central1-oasistaxiperu.cloudfunctions.net/setAdminClaims'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await FirebaseAuth.instance.currentUser?.getIdToken()}',
        },
        body: json.encode({
          'uid': FirebaseAuth.instance.currentUser?.uid,
          'email': _emailController.text,
        }),
      );
    } catch (e) {
      debugPrint('Error estableciendo claims: $e');
    }
  }
  
  /// Helper para mostrar SnackBar
  void _showSnackBar(String message, Color backgroundColor) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ModernTheme.oasisBlack,
      body: Stack(
        children: [
          // Fondo animado oscuro
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      ModernTheme.oasisBlack,
                      ModernTheme.accentGray,
                      ModernTheme.oasisGreen.withValues(alpha: 0.2),
                    ],
                    transform: GradientRotation(
                      _backgroundController.value * 2 * math.pi,
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Patrón de seguridad
          ...List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _backgroundController,
              builder: (context, child) {
                final progress = (_backgroundController.value + index * 0.33) % 1;
                return Positioned(
                  left: MediaQuery.of(context).size.width * progress,
                  top: MediaQuery.of(context).size.height * 0.2 * (index + 1),
                  child: Transform.rotate(
                    angle: progress * 2 * math.pi,
                    child: Icon(
                      Icons.security,
                      size: 30,
                      color: ModernTheme.oasisGreen.withValues(alpha: 0.1),
                    ),
                  ),
                );
              },
            );
          }),
          
          // Contenido principal
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: AnimatedBuilder(
                  animation: _formController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _formController.value,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: ModernTheme.oasisGreen.withValues(alpha: 0.3),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: _showTwoFactor ? _build2FAForm() : _buildLoginForm(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icono de admin con animación
          AnimatedBuilder(
            animation: _iconController,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      ModernTheme.oasisGreen,
                      ModernTheme.oasisGreen.withValues(alpha: 0.7),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ModernTheme.oasisGreen.withValues(alpha: 0.5),
                      blurRadius: 20 + (_iconController.value * 10),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.admin_panel_settings,
                  size: 50,
                  color: Colors.white,
                ),
              );
            },
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'ADMIN PANEL',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: ModernTheme.oasisBlack,
              letterSpacing: 2,
            ),
          ),
          
          const Text(
            'Acceso Restringido',
            style: TextStyle(
              color: ModernTheme.textSecondary,
              fontSize: 14,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Campo de email
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: ModernTheme.oasisBlack),
            decoration: InputDecoration(
              labelText: 'Correo Administrativo',
              prefixIcon: const Icon(Icons.email, color: ModernTheme.oasisGreen),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: ModernTheme.oasisGreen, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresa el correo administrativo';
              }
              if (!value.contains('@')) {
                return 'Correo inválido';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          // Campo de contraseña
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: const TextStyle(color: ModernTheme.oasisBlack),
            decoration: InputDecoration(
              labelText: 'Contraseña',
              prefixIcon: const Icon(Icons.lock, color: ModernTheme.oasisGreen),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: ModernTheme.textSecondary,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: ModernTheme.oasisGreen, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresa la contraseña';
              }
              if (value.length < 6) {
                return 'Contraseña muy corta';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 24),
          
          // Botón de login
          AnimatedPulseButton(
            text: 'ACCEDER AL PANEL',
            icon: Icons.security,
            isLoading: _isLoading,
            onPressed: _login,
            color: ModernTheme.oasisGreen,
          ),
          
          const SizedBox(height: 16),
          
          // Información de seguridad
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.amber.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Este acceso es solo para administradores autorizados',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Volver al login normal
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            child: const Text(
              'Volver al Login Normal',
              style: TextStyle(color: ModernTheme.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _build2FAForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.verified_user,
          size: 60,
          color: ModernTheme.oasisGreen,
        ),
        
        const SizedBox(height: 24),
        
        const Text(
          'Verificación de 2 Factores',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: ModernTheme.oasisBlack,
          ),
        ),
        
        const SizedBox(height: 8),
        
        const Text(
          'Ingresa el código de 6 dígitos',
          style: TextStyle(
            color: ModernTheme.textSecondary,
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Campo de código
        TextFormField(
          controller: _codeController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            letterSpacing: 8,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: '000000',
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: ModernTheme.oasisGreen, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
        
        const SizedBox(height: 24),
        
        AnimatedPulseButton(
          text: 'VERIFICAR',
          icon: Icons.check,
          isLoading: _isLoading,
          onPressed: _verify2FA,
          color: ModernTheme.oasisGreen,
        ),
        
        const SizedBox(height: 16),
        
        TextButton(
          onPressed: () {
            setState(() {
              _showTwoFactor = false;
              _codeController.clear();
            });
          },
          child: const Text(
            'Cancelar',
            style: TextStyle(color: ModernTheme.textSecondary),
          ),
        ),
        
        const SizedBox(height: 16),
        
        const Text(
          'Se enviará un código de verificación a su email registrado.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}