import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ReservationButton extends StatefulWidget {
  const ReservationButton({super.key});

  @override
  State<ReservationButton> createState() => _ReservationButtonState();
}

class _ReservationButtonState extends State<ReservationButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFFA500), // Naranja
              Color(0xFFFFD700), // Amarillo
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFA500).withOpacity(0.5),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.celebration, color: Colors.white),
          label: const Text('Reservar Ahora', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 0,
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ReservationDialog(),
            );
          },
        ),
      ),
    );
  }
}

class ReservationDialog extends StatefulWidget {
  const ReservationDialog({super.key});

  @override
  State<ReservationDialog> createState() => _ReservationDialogState();
}

class _ReservationDialogState extends State<ReservationDialog> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String whatsapp = '';
  int numPeople = 2;
  DateTime? selectedDate;
  String? selectedTime;
  List<Map<String, dynamic>> horariosFiltrados = [];
  List<String> availableTimes = [];
  bool loadingTimes = false;
  String? errorTimes;
  bool sending = false;
  String? successMsg;
  int? lastStatusCode;

  Color get accentColor => const Color.fromARGB(255, 232, 28, 28); // Rojo pastel
  Color get bgColor => const Color(0xFFFCF6F0); // Fondo claro

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es', null);
    selectedDate = DateTime(DateTime.now().year, 5, 23); // 23 de mayo
    fetchTimes();
  }

  Future<void> fetchTimes() async {
    setState(() {
      loadingTimes = true;
      errorTimes = null;
      availableTimes = [];
      horariosFiltrados = [];
    });
    try {
      final response = await http.get(Uri.parse('https://n8n-n8n.25bb0d.easypanel.host/webhook/horariosDisponibles'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> horarios = data['horariosDisponibles'] ?? [];
        final String targetDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
        final filtered = horarios.where((slot) => slot['fecha'] != null && slot['fecha'].toString().startsWith(targetDate)).toList();
        horariosFiltrados = filtered.map<Map<String, dynamic>>((slot) {
          final hora = slot['hora'] as String;
          final partes = hora.split(':');
          final formatted = '${partes[0]}:${partes[1]}';
          final capacidad = slot['capacidad_maxima'] ?? 0;
          final reservadas = slot['personas_reservadas'] ?? 0;
          final disponibles = capacidad - reservadas;
          String estado = 'disponible';
          if (disponibles <= 0) {
            estado = 'no_disponible';
          } else if (disponibles < 10) {
            estado = 'pocos_cupos';
          }
          return {
            'id': slot['id'],
            'hora': formatted,
            'estado': estado,
            'disponibles': disponibles,
          };
        }).toList();
        setState(() {
          availableTimes = horariosFiltrados.where((h) => h['estado'] != 'no_disponible').map((h) => h['hora'] as String).toList();
          selectedTime = availableTimes.isNotEmpty ? availableTimes.first : null;
        });
      } else {
        setState(() {
          errorTimes = 'No se pudieron cargar los horarios.';
        });
      }
    } catch (e) {
      setState(() {
        errorTimes = 'Error de conexión.';
      });
    } finally {
      setState(() {
        loadingTimes = false;
      });
    }
  }

  void submit() async {
    if (!_formKey.currentState!.validate() || selectedTime == null) return;
    setState(() { sending = true; successMsg = null; });
    try {
      // Buscar el id del horario seleccionado
      final horarioSeleccionado = horariosFiltrados.firstWhere((h) => h['hora'] == selectedTime, orElse: () => <String, dynamic>{});
      final int? idHorario = horarioSeleccionado['id'] as int?;
      if (idHorario == null) {
        setState(() {
          sending = false;
          successMsg = 'No se pudo identificar el horario seleccionado.';
        });
        return;
      }
      final response = await http.post(
        Uri.parse('https://n8n-n8n.25bb0d.easypanel.host/webhook/crearReserva'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': idHorario,
          'personas': numPeople,
          'nombre': name,
          'whatsapp': whatsapp,
        }),
      );
      final respJson = json.decode(response.body);
      lastStatusCode = response.statusCode;
      if (response.statusCode == 200) {
        setState(() {
          sending = false;
          successMsg = respJson['msj'] ?? '¡Reserva enviada! Te confirmaremos por WhatsApp.';
        });
      } else {
        setState(() {
          sending = false;
          successMsg = respJson['msj'] ?? 'Ocurrió un error al enviar la reserva. Intenta nuevamente.';
        });
      }
    } catch (e) {
      setState(() {
        sending = false;
        successMsg = 'Error de conexión al enviar la reserva.';
        lastStatusCode = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(28),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (successMsg == null) ...[
                    Text('🎉 Reservá tu 2x1',
                      style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        letterSpacing: -1,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '¡Por inauguración! Completa tus datos para aprovechar esta oferta especial. La reserva es válida hasta el 22 de mayo a las 00:00. Cupos limitados hasta agotar reservas.',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (successMsg != null) ...[
                    if (lastStatusCode == 400) ...[
                      Text('¡Upps!',
                        style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          letterSpacing: -1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                    ]
                    else ...[
                      Text('Reservado con éxito',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          letterSpacing: -1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                    ],
                    Icon(
                      (successMsg!.toLowerCase().contains('éxito') ||
                       successMsg!.toLowerCase().contains('reservado') ||
                       successMsg!.toLowerCase().contains('enviada'))
                        ? Icons.check_circle
                        : Icons.error_outline,
                      color: (successMsg!.toLowerCase().contains('éxito') ||
                              successMsg!.toLowerCase().contains('reservado') ||
                              successMsg!.toLowerCase().contains('enviada'))
                        ? Colors.green
                        : Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    if ((successMsg!.toLowerCase().contains('éxito') ||
                         successMsg!.toLowerCase().contains('reservado') ||
                         successMsg!.toLowerCase().contains('enviada')))
                      Text('Te llegará la confirmación por WhatsApp.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[700], fontSize: 15)),
                    if (!(successMsg!.toLowerCase().contains('éxito') ||
                          successMsg!.toLowerCase().contains('reservado') ||
                          successMsg!.toLowerCase().contains('enviada')))
                      Text(successMsg!, style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Cerrar'),
                    ),
                  ] else ...[
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Nombre
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Nombre',
                              hintText: 'Tu nombre completo',
                              labelStyle: TextStyle(color: accentColor, fontWeight: FontWeight.w600),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: accentColor, width: 2),
                              ),
                            ),
                            onChanged: (v) => name = v,
                            validator: (v) => v == null || v.trim().isEmpty ? 'Rellena este campo.' : null,
                          ),
                          const SizedBox(height: 18),
                          // WhatsApp
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'WhatsApp',
                              hintText: 'Ej: +54 9 221 ...',
                              labelStyle: TextStyle(color: accentColor, fontWeight: FontWeight.w600),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: accentColor, width: 2),
                              ),
                              helperText: 'Te enviaremos la confirmación y el código QR a este número.',
                            ),
                            keyboardType: TextInputType.phone,
                            onChanged: (v) => whatsapp = v,
                            validator: (v) => v == null || v.trim().isEmpty ? 'Rellena este campo.' : null,
                          ),
                          const SizedBox(height: 18),
                          // Personas
                          DropdownButtonFormField<int>(
                            value: numPeople,
                            decoration: InputDecoration(
                              labelText: 'Personas',
                              labelStyle: TextStyle(color: accentColor, fontWeight: FontWeight.w600),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: accentColor, width: 2),
                              ),
                            ),
                            items: List.generate(6, (i) => i + 1).map((n) => DropdownMenuItem(value: n, child: Text('$n persona${n > 1 ? 's' : ''}'))).toList(),
                            onChanged: (v) => setState(() { numPeople = v ?? 2; }),
                          ),
                          const SizedBox(height: 18),
                          // Fecha
                          TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Fecha',
                              labelStyle: TextStyle(color: accentColor, fontWeight: FontWeight.w600),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: accentColor, width: 2),
                              ),
                              prefixIcon: const Icon(Icons.calendar_today),
                            ),
                            controller: TextEditingController(text: DateFormat('d MMMM yyyy', 'es').format(selectedDate!)),
                            onTap: () {}, // Solo una fecha fija
                          ),
                          const SizedBox(height: 18),
                          // Hora
                          loadingTimes
                            ? const Center(child: CircularProgressIndicator())
                            : DropdownButtonFormField<String>(
                                value: selectedTime,
                                decoration: InputDecoration(
                                  labelText: 'Hora',
                                  labelStyle: TextStyle(color: accentColor, fontWeight: FontWeight.w600),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: accentColor, width: 2),
                                  ),
                                ),
                                items: horariosFiltrados.map((h) {
                                  String label = h['hora'];
                                  if (h['estado'] == 'no_disponible') {
                                    label += ' (Sin cupos)';
                                  } else if (h['estado'] == 'pocos_cupos') {
                                    label += ' (¡Quedan pocos cupos!)';
                                  }
                                  return DropdownMenuItem<String>(
                                    value: h['hora'],
                                    enabled: h['estado'] != 'no_disponible',
                                    child: Text(label,
                                      style: TextStyle(
                                        color: h['estado'] == 'no_disponible'
                                            ? Colors.grey
                                            : h['estado'] == 'pocos_cupos'
                                                ? Colors.orange[800]
                                                : Colors.black,
                                        fontWeight: h['estado'] == 'no_disponible' ? FontWeight.normal : FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (v) => setState(() { selectedTime = v; }),
                                validator: (v) => v == null ? 'Selecciona una hora' : null,
                              ),
                          if (errorTimes != null) ...[
                            const SizedBox(height: 8),
                            Text(errorTimes!, style: const TextStyle(color: Colors.red)),
                          ],
                          const SizedBox(height: 28),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: sending ? null : submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              child: sending
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text('Confirmar Solicitud de Reserva'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Botón cerrar (X)
          Positioned(
            top: 6,
            right: 6,
            child: AnimatedScale(
              scale: 1.0,
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOutCubic,
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 22, color: Colors.grey),
                  tooltip: 'Cerrar',
                  splashRadius: 16,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 