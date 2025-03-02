import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/AuthViewModel.dart';

class MisReportesScreen extends StatelessWidget {
  const MisReportesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ejemplo de datos para reportes
    final reportes = [
      {'folio': '100044', 'fecha': '04/12/2024', 'estado': 'pendiente'},
      {'folio': '100043', 'fecha': '04/12/2024', 'estado': 'pendiente'},
      {'folio': '100042', 'fecha': '04/12/2024', 'estado': 'pendiente'},
      {'folio': '100037', 'fecha': '03/12/2024', 'estado': 'pendiente'},
      {'folio': '100033', 'fecha': '03/12/2024', 'estado': 'pendiente'},
      {'folio': '100024', 'fecha': '01/12/2024', 'estado': 'pendiente'},
      {'folio': '100023', 'fecha': '01/12/2024', 'estado': 'pendiente'},
      {'folio': '100022', 'fecha': '01/12/2024', 'estado': 'pendiente'},
      {'folio': '100020', 'fecha': '28/11/2024', 'estado': 'pendiente'},
      {'folio': '100014', 'fecha': '27/11/2024', 'estado': 'pendiente'},
      {'folio': '100004', 'fecha': '25/11/2024', 'estado': 'pendiente'},
      {'folio': '100002', 'fecha': '25/11/2024', 'estado': 'pendiente'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Reportes'),
        backgroundColor: Colors.purple.shade900,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _mostrarDialogoCerrarSesion(context);
            },
          ),
        ],
      ),
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
        child: Column(
          children: [
            // Encabezado de la tabla
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.purple.shade700,
              ),
              child: Row(
                children: const [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Folio',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Fecha',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Estado',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Lista de reportes
            Expanded(
              child: ListView.builder(
                itemCount: reportes.length,
                itemBuilder: (context, index) {
                  final reporte = reportes[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade800.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      onTap: () {
                        // Navegar a la pantalla de detalle del reporte
                        // TODO: Implementar navegación al detalle
                      },
                      title: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              reporte['folio']!,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              reporte['fecha']!,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getColorPorEstado(reporte['estado']!),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                reporte['estado']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la pantalla para crear un nuevo reporte
          // TODO: Implementar navegación a crear reporte
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.purple.shade900,
        child: const Icon(Icons.add),
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