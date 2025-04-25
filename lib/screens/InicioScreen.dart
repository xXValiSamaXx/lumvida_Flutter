import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/AuthViewModel.dart';
import 'LoginScreen.dart';
import 'MisReportesScreen.dart';
import 'ReportesScreen.dart'; // Asumimos que esta pantalla ya existe o la crearás después

class InicioScreen extends StatelessWidget {
  const InicioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo o título
                const Text(
                  'LumVida',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Mejorando nuestra ciudad juntos',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 50),

                // Sección de bienvenida
                Text(
                  authViewModel.isAuthenticated
                      ? 'Bienvenido ${authViewModel.user?.email
                      ?.split('@')
                      .first ?? 'Usuario'}'
                      : 'Bienvenido Invitado',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 50),

                // Botón para hacer un reporte
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReportesScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.purple.shade900,
                    minimumSize: const Size(250, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Haz un reporte',
                    style: TextStyle(fontSize: 16),
                  ),
                ),

                const SizedBox(height: 20),

                // Botón de Mis Reportes (verificar autenticación)
                ElevatedButton(
                  onPressed: () {
                    if (authViewModel.isAuthenticated) {
                      // Si está autenticado, ir a Mis Reportes
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MisReportesScreen(),
                        ),
                      );
                    } else {
                      // Si no está autenticado, mostrar diálogo para iniciar sesión
                      _mostrarDialogoInicioSesionRequerido(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(250, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Mis Reportes',
                    style: TextStyle(fontSize: 16),
                  ),
                ),

                const SizedBox(height: 50),

                // Botón de inicio de sesión o cierre de sesión
                if (authViewModel.isAuthenticated)
                  OutlinedButton(
                    onPressed: () {
                      _mostrarDialogoCerrarSesion(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      minimumSize: const Size(250, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Cerrar Sesión',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                else
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      minimumSize: const Size(250, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Iniciar Sesión',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _mostrarDialogoInicioSesionRequerido(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Iniciar sesión requerido'),
          content: const Text(
              'Para ver tus reportes necesitas iniciar sesión.'
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade900,
              ),
              child: const Text('Iniciar sesión'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Cerrar sesión
                final authViewModel = Provider.of<AuthViewModel>(
                  context,
                  listen: false,
                );
                await authViewModel.signOut();

                // Cerrar el diálogo
                if (context.mounted) {
                  Navigator.of(context).pop();
                  // Opcional: Actualiza la UI de alguna manera para mostrar el cambio
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sesión cerrada correctamente'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );
  }
}