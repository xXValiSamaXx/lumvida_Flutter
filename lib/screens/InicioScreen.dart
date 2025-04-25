import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../viewmodels/AuthViewModel.dart';
import 'LoginScreen.dart';
import 'MisReportesScreen.dart';
import 'ReportesScreen.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: Container(
        decoration: backgroundDecoration,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/Logo blanco.png',
                    height: 200,
                  ),
                  const SizedBox(height: 40),

                  // Título de la app
                  const Text(
                    'LumVida',
                    style: kTitleStyle,
                  ),
                  const SizedBox(height: 10),

                  // Sección de bienvenida
                  Text(
                    authViewModel.isAuthenticated
                        ? 'Bienvenido ${authViewModel.user?.email?.split('@').first ?? 'Usuario'}'
                        : 'Bienvenido Invitado',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Reporte ciudadano
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Reporte ciudadano:',
                      style: kTitleStyle,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Historial de reportes
                  InkWell(
                    onTap: () {
                      if (authViewModel.isAuthenticated) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MisReportesScreen(),
                          ),
                        );
                      } else {
                        _mostrarDialogoInicioSesionRequerido(context);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          'Historial de reportes',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Realizar un reporte
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Realizar un reporte\nrelacionado con:',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Grid de categorías
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildCategoryButton(
                          context: context,
                          icon: Icons.directions_car,
                          title: 'Baches',
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportesScreen())),
                        ),
                        _buildCategoryButton(
                          context: context,
                          icon: Icons.lightbulb_outline,
                          title: 'Alumbrado\nPublico',
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportesScreen())),
                        ),
                        _buildCategoryButton(
                          context: context,
                          icon: Icons.delete_outline,
                          title: 'Basura\nacumulada',
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportesScreen())),
                        ),
                        _buildCategoryButton(
                          context: context,
                          icon: Icons.water_drop,
                          title: 'Alcantarillado',
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportesScreen())),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context, authViewModel),
    );
  }

  Widget _buildCategoryButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, AuthViewModel authViewModel) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Expanded(
            child: Center(
              child: Text(
                'Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            width: 1,
            height: 30,
            color: Colors.white.withOpacity(0.3),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.location_on, color: Colors.white, size: 28),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.white, size: 28),
                  onPressed: () {
                    if (authViewModel.isAuthenticated) {
                      _mostrarDialogoCerrarSesion(context);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoInicioSesionRequerido(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Iniciar sesión requerido'),
          content: const Text('Para ver tus reportes necesitas iniciar sesión.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar', style: TextStyle(color: kPrimaryColor)),
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
                backgroundColor: kPrimaryColor,
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
              child: const Text('Cancelar', style: TextStyle(color: kPrimaryColor)),
            ),
            ElevatedButton(
              onPressed: () async {
                final authViewModel = Provider.of<AuthViewModel>(
                  context,
                  listen: false,
                );
                await authViewModel.signOut();

                if (context.mounted) {
                  Navigator.of(context).pop();
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