import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../viewmodels/AuthViewModel.dart';

class MisReportesScreen extends StatelessWidget {
  const MisReportesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ejemplo de datos para reportes
    final reportes = [
      {'folio': '100044', 'fecha': '04/12/2024', 'estado': 'pendiente', 'tipo': 'RECOLECCIÓN DE BASURA', 'descripcion': 'No ha venido en 4 días', 'ubicacion': 'Santa Fe, San Felipe'},
      {'folio': '100043', 'fecha': '02/12/2024', 'estado': 'en proceso', 'tipo': 'Alumbrado Publico', 'descripcion': 'Luminaria dañada en la esquina', 'ubicacion': 'Paraíso del Sol'},
      {'folio': '100042', 'fecha': '04/12/2024', 'estado': 'pendiente', 'tipo': 'Baches', 'descripcion': 'Bache grande en la calle', 'ubicacion': 'Av. Principal'},
      {'folio': '100037', 'fecha': '03/12/2024', 'estado': 'resuelto', 'tipo': 'Alcantarillado', 'descripcion': 'Drenaje tapado', 'ubicacion': 'Calle 5'},
      {'folio': '100033', 'fecha': '03/12/2024', 'estado': 'pendiente', 'tipo': 'RECOLECCIÓN DE BASURA', 'descripcion': 'No pasa el camión', 'ubicacion': 'Col. Centro'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Reportes', style: TextStyle(color: kPrimaryColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: kPrimaryColor),
      ),
      body: Container(
        decoration: backgroundDecoration,
        child: Column(
          children: [
            // Filtros
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('Todos', true),
                    _buildFilterChip('Pendientes', false),
                    _buildFilterChip('En proceso', false),
                    _buildFilterChip('Resueltos', false),
                  ],
                ),
              ),
            ),

            // Lista de reportes
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: reportes.length,
                itemBuilder: (context, index) {
                  final reporte = reportes[index];
                  return _buildReportCard(
                    context: context,
                    reporte: reporte,
                  );
                },
              ),
            ),
          ],
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
                children: const [
                  Icon(Icons.location_on, color: Colors.white, size: 28),
                  Icon(Icons.person, color: Colors.white, size: 28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.orange : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black54,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildReportCard({
    required BuildContext context,
    required Map<String, String> reporte,
  }) {
    IconData getIconForType(String type) {
      if (type.contains('Basura') || type.contains('RECOLECCIÓN')) {
        return Icons.delete_outline;
      } else if (type.contains('Alumbrado')) {
        return Icons.lightbulb_outline;
      } else if (type.contains('Baches')) {
        return Icons.car_repair;
      } else if (type.contains('Alcantarillado')) {
        return Icons.water_drop;
      }
      return Icons.report_problem_outlined;
    }

    // Lista simulada de estados del reporte
    final List<String> estados = [];
    estados.add('Reporte recibido');
    if (reporte['estado'] == 'en proceso' || reporte['estado'] == 'resuelto') {
      estados.add('Asignado al departamento correspondiente');
      estados.add('En revisión');
    }
    if (reporte['estado'] == 'resuelto') {
      estados.add('Problema solucionado');
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado con icono y título
            Row(
              children: [
                Icon(
                  getIconForType(reporte['tipo']!),
                  color: kPrimaryColor,
                  size: 40,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    reporte['tipo']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Descripción
            Text(
              reporte['descripcion']!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),

            // Ubicación
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  reporte['ubicacion']!,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Fecha
            Text(
              'Reportado el ${reporte['fecha']}',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),

            const Divider(height: 24),

            // Seguimiento de estados
            const Text(
              'Seguimiento del reporte',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Estados del reporte
            ...List.generate(estados.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            estados[index],
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          if (index == 0) Text('${reporte['fecha']} • 09:22', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                          if (index == 1) Text('${reporte['fecha']} • 15:40', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                          if (index == 2) Text('${reporte['fecha']} • 08:15', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                          if (index == 3) Text('${reporte['fecha']} • 14:30', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getColorPorEstado(String estado) {
    switch (estado.toLowerCase()) {
      case 'pendiente':
        return Colors.orange;
      case 'en proceso':
        return Colors.blue;
      case 'resuelto':
        return Colors.green;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _mostrarDialogoCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cerrar sesión', style: TextStyle(color: kPrimaryColor)),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar', style: TextStyle(color: kPrimaryColor)),
            ),
            ElevatedButton(
              onPressed: () {
                // Cerrar sesión
                final authViewModel = Provider.of<AuthViewModel>(
                  context,
                  listen: false,
                );
                authViewModel.signOut();

                // Cerrar todos los diálogos y navegar a la pantalla inicial
                Navigator.of(context).popUntil((route) => route.isFirst);
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