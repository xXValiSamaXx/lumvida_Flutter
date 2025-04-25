import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import '../viewmodels/AuthViewModel.dart';
import 'LoginScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
    title: const Text(
    'Crear Cuenta',
    style: TextStyle(color: Colors.white),
    ),
    ),
    extendBodyBehindAppBar: true,
    body: Container(
    decoration: BoxDecoration(
    gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
    Colors.purple.shade900,
    Colors.purple.shade800,
    ],
    ),
    ),
    child: SafeArea(
    child: Center(
    child: SingleChildScrollView(
    padding: const EdgeInsets.all(24.0),
    child: Form(
    key: _formKey,
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    const Text(
    'Regístrate',
    style: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    textAlign: TextAlign.center,
    ),
    const SizedBox(height: 16),
    const Text(
    'Crea una cuenta para reportar problemas urbanos',
    style: TextStyle(
    fontSize: 16,
    color: Colors.white70,
    ),
    textAlign: TextAlign.center,
    ),
    const SizedBox(height: 40),

    // Campo de nombre
    TextFormField(
    controller: _nameController,
    keyboardType: TextInputType.text,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
    labelText: 'Nombre completo',
    labelStyle: const TextStyle(color: Colors.white70),
    enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.white54),
    borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.white),
    borderRadius: BorderRadius.circular(8),
    ),
    errorBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.redAccent),
    borderRadius: BorderRadius.circular(8),
    ),
    focusedErrorBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.redAccent),
    borderRadius: BorderRadius.circular(8),
    ),
    prefixIcon: const Icon(Icons.person, color: Colors.white70),
    ),
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Por favor ingrese su nombre';
    }
    return null;
    },
    ),

    const SizedBox(height: 16),

    // Campo de correo electrónico
    TextFormField(
    controller: _emailController,
    keyboardType: TextInputType.emailAddress,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
    labelText: 'Correo electrónico',
    labelStyle: const TextStyle(color: Colors.white70),
    enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.white54),
    borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.white),
    borderRadius: BorderRadius.circular(8),
    ),
    errorBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.redAccent),
    borderRadius: BorderRadius.circular(8),
    ),
    focusedErrorBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.redAccent),
    borderRadius: BorderRadius.circular(8),
    ),
    prefixIcon: const Icon(Icons.email, color: Colors.white70),
    ),
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Por favor ingrese su correo electrónico';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'Ingrese un correo electrónico válido';
    }
    return null;
    },
    ),

    const SizedBox(height: 16),

    // Campo de teléfono
    TextFormField(
    controller: _phoneController,
    keyboardType: TextInputType.phone,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
    labelText: 'Teléfono (10 dígitos)',
    labelStyle: const TextStyle(color: Colors.white70),
    enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.white54),
    borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.white),
    borderRadius: BorderRadius.circular(8),
    ),
    errorBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.redAccent),
    borderRadius: BorderRadius.circular(8),
    ),
    focusedErrorBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.redAccent),
    borderRadius: BorderRadius.circular(8),
    ),
    prefixIcon: const Icon(Icons.phone, color: Colors.white70),
    ),
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Por favor ingrese su teléfono';
    }
    if (value.length != 10) {
    return 'El teléfono debe tener exactamente 10 dígitos';
    }
    return null;
    },
    onChanged: (value) {
    if (value.length > 10) {
    _phoneController.text = value.substring(0, 10);
    _phoneController.selection = TextSelection.fromPosition(
    TextPosition(offset: 10)
    );
    }
    },
    ),

    const SizedBox(height: 16),

// Campo de contraseña
      TextFormField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: 'Contraseña',
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white54),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.circular(8),
          ),
          prefixIcon: const Icon(Icons.lock, color: Colors.white70),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.white70,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingrese una contraseña';
          }
          if (value.length < 6) {
            return 'La contraseña debe tener al menos 6 caracteres';
          }
          return null;
        },
      ),

      const SizedBox(height: 16),

      // Campo de confirmar contraseña
      TextFormField(
        controller: _confirmPasswordController,
        obscureText: _obscureConfirmPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: 'Confirmar contraseña',
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white54),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.circular(8),
          ),
          prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.white70,
            ),
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor confirme su contraseña';
          }
          if (value != _passwordController.text) {
            return 'Las contraseñas no coinciden';
          }
          return null;
        },
      ),

      const SizedBox(height: 24),

      // Mensaje de error
      if (authViewModel.errorMessage != null)
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            authViewModel.errorMessage!,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),

      // Botón de registro
      ElevatedButton(
        onPressed: authViewModel.isLoading
            ? null
            : () async {
          if (_formKey.currentState!.validate()) {
            final success = await authViewModel.registerWithEmailAndPassword(
              _emailController.text.trim(),
              _passwordController.text,
              _nameController.text.trim(),
              _phoneController.text.trim(),
            );

            if (success && mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡Cuenta creada exitosamente!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.purple.shade900,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          minimumSize: const Size(double.infinity, 0),
        ),
        child: authViewModel.isLoading
            ? const CircularProgressIndicator()
            : const Text(
          'Crear cuenta',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      const SizedBox(height: 24),

      // Separador
      const Row(
        children: [
          Expanded(
            child: Divider(color: Colors.white54, thickness: 1),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'O',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          Expanded(
            child: Divider(color: Colors.white54, thickness: 1),
          ),
        ],
      ),

      const SizedBox(height: 24),

// Botón de Google
      OutlinedButton.icon(
        onPressed: authViewModel.isLoading
            ? null
            : () async {
          try {
            final success = await authViewModel.signInWithGoogle();

            if (success && mounted) {
              Navigator.of(context).pop();
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: ${e.toString()}")),
              );
            }
          }
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        icon: Image.network(
          'https://cdn-icons-png.flaticon.com/512/2991/2991148.png',
          width: 24,
          height: 24,
        ),
        label: const Text(
          'Continuar con Google',
          style: TextStyle(fontSize: 16),
        ),
      ),

      const SizedBox(height: 16),

      // Ya tienes cuenta
      Center(
        child: RichText(
          text: TextSpan(
            text: '¿Ya tienes una cuenta? ',
            style: const TextStyle(color: Colors.white70),
            children: [
              TextSpan(
                text: 'Inicia sesión',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.of(context).pop();
                  },
              ),
            ],
          ),
        ),
      ),
    ],
    ),
    ),
    ),
    ),
    ),
    ),
    );
  }
}