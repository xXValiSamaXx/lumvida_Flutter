import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../viewmodels/AuthViewModel.dart';
import 'LoginScreen.dart';

class ReportesScreen extends StatelessWidget {
  const ReportesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportar un problema', style: TextStyle(color: kPrimaryColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: kPrimaryColor),
      ),
      body: Container(
        decoration: backgroundDecoration,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icono del tipo de problema
                Center(
                  child: Icon(
                    Icons.car_repair,
                    color: kPrimaryColor,
                    size: 60,
                  ),
                ),

                const SizedBox(height: 20),

                // Título principal
                const Text(
                  'Reportar un problema',
                  style: kTitleStyle,
                ),

                const SizedBox(height: 30),

                // Ubicación
                const Text(
                  '¿DÓNDE SE UBICA EL PROBLEMA?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),

                const SizedBox(height: 10),

                // Mapa (simulado)
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Center(
                    child: Text('Mapa aquí', style: TextStyle(color: Colors.grey)),
                  ),
                ),

                const SizedBox(height: 30),

                // Descripción
                const Text(
                  'DESCRIBE EL REPORTE (EL FILTRO QUE HABIAMOS HABLADO)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),

                const SizedBox(height: 10),

                // Opciones de reporte
                _buildCheckOption('No recogieron toda la basura'),
                _buildCheckOption('El personal fue irrespetuoso'),
                _buildCheckOption('Cambiaron el horario sin avisar'),

                const SizedBox(height: 30),

                // Sección de fotos
                const Text(
                  'ADJUNTA FOTOS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),

                const SizedBox(height: 20),

                // Contenedores para fotos
                Row(
                  children: [
                    _buildPhotoContainer(),
                    const SizedBox(width: 10),
                    _buildPhotoContainer(),
                    const SizedBox(width: 10),
                    _buildPhotoContainer(),
                  ],
                ),

                const SizedBox(height: 40),

                // Botón de enviar
                ElevatedButton(
                  onPressed: () {
                    if (authViewModel.isAuthenticated) {
                      // Mostrar mensaje de éxito
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Reporte enviado con éxito'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      // Volver a la pantalla anterior
                      Navigator.pop(context);
                    } else {
                      // Si no está autenticado, mostrar diálogo
                      _mostrarDialogoInicioSesionRequerido(context);
                    }
                  },
                  style: kPrimaryButtonStyle,
                  child: const Text(
                    'Enviar Reporte',
                    style: kButtonTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
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
                      if (!authViewModel.isAuthenticated) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckOption(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black12, width: 1),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildPhotoContainer() {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Text(
              '100\n×\n100',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
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
          title: const Text('Iniciar sesión requerido', style: TextStyle(color: kPrimaryColor)),
          content: const Text('Para crear un reporte necesitas iniciar sesión.'),
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
}