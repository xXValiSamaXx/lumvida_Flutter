import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../utils/report_categories.dart';
import '../viewmodels/AuthViewModel.dart';
import 'LoginScreen.dart';

class ReportesScreen extends StatefulWidget {
  final String categoria;

  const ReportesScreen({Key? key, required this.categoria}) : super(key: key);

  @override
  State<ReportesScreen> createState() => _ReportesScreenState();
}

class _ReportesScreenState extends State<ReportesScreen> {
  String? _selectedOption;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final category = ReportCategories.getCategoryByName(widget.categoria);

    return Scaffold(
      appBar: AppBar(
        title: Text('Reportar ${category.name}', style: const TextStyle(color: kPrimaryColor)),
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
                    category.icon,
                    color: kPrimaryColor,
                    size: 60,
                  ),
                ),

                const SizedBox(height: 20),

                // Título principal
                Text(
                  'Reportar ${category.name}',
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
                  'DESCRIBE EL PROBLEMA:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),

                const SizedBox(height: 10),

                // Opciones de reporte
                ...category.options.map((option) => _buildCheckOption(
                  option.description,
                  option.description == _selectedOption,
                      () {
                    setState(() {
                      _selectedOption = option.description;
                    });
                  },
                )).toList(),

                // Campo para comentarios adicionales
                if (_selectedOption == 'Otro (especificar)') ...[
                  const SizedBox(height: 20),
                  TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Describe el problema...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    maxLines: 3,
                  ),
                ],

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
                    if (_selectedOption == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor selecciona una opción'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

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
        height: 50,
        decoration: const BoxDecoration(
          color: kSecondaryColor,
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

  Widget _buildCheckOption(String text, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black12, width: 1),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? kPrimaryColor : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoContainer() {
    return Expanded(
      child: InkWell(
        onTap: () {
          // Implementar selección de foto
        },
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.add_a_photo,
              color: Colors.grey,
              size: 30,
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