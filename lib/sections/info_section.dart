import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InfoSection extends StatelessWidget {
  const InfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.location_city, size: 48, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            'Visítanos y Contáctanos',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Te esperamos en Fuente de soda Maggy\'s, conéctate con nosotros en línea.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: const [
              _InfoCard(
                icon: Icons.place,
                title: 'Nuestra Ubicación',
                description: '¡Te esperamos!',
                content: 'Calle 66 entre 122 y 123 - Berisso',
                isLocation: true,
                locationUrl: 'https://www.google.com.ar/maps/place/Desayunos+Maggy\'s/@-34.9122036,-57.9200088,60m/data=!3m1!1e3!4m14!1m7!3m6!1s0x95a2e70076d91b93:0x8b54f6053bbd2ad2!2sDesayunos+Maggy\'s!8m2!3d-34.9122606!4d-57.9198873!16s%2Fg%2F11mcnbdpf3!3m5!1s0x95a2e70076d91b93:0x8b54f6053bbd2ad2!8m2!3d-34.9122606!4d-57.9198873!16s%2Fg%2F11mcnbdpf3?entry=ttu&g_ep=EgoyMDI1MDUxNS4wIKXMDSoASAFQAw%3D%3D',
              ),
              _InfoCard(
                icon: Icons.access_time,
                title: 'Horario de Atención',
                description: 'Listos para servirte.',
                content: 'Lunes a Jueves: 8:00 - 13:00 y 16:00 - 20:00\nViernes Sábados y Domingos: 7:00 - 22:00',
              ),
              _InfoCard(
                icon: Icons.phone,
                title: 'Llámanos o Escríbenos',
                description: 'Reservas y consultas.',
                phoneNumber: '+54 9 2215 67-5619',
                whatsappNumber: '+54 9 2215 06-5316',
                isContact: true,
              ),
              _InfoCard(
                icon: Icons.people,
                title: 'Redes Sociales',
                description: 'Síguenos y contáctanos.',
                content: 'Instagram: @fuentemaggys\nFacebook: https://www.facebook.com/profile.php?id=100029070852160',
                isSocial: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? content;
  final String? phoneNumber;
  final String? whatsappNumber;
  final String? locationUrl;
  final bool isContact;
  final bool isSocial;
  final bool isLocation;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.description,
    this.content,
    this.phoneNumber,
    this.whatsappNumber,
    this.locationUrl,
    this.isContact = false,
    this.isSocial = false,
    this.isLocation = false,
  });

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('No se pudo abrir $url');
    }
  }

  Future<void> _launchPhone(String phone) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phone.replaceAll(RegExp(r'[^\d+]'), ''),
    );
    if (!await launchUrl(phoneUri)) {
      throw Exception('No se pudo abrir $phoneUri');
    }
  }

  Future<void> _launchWhatsApp(String phone) async {
    final Uri whatsappUri = Uri.parse(
      'https://wa.me/${phone.replaceAll(RegExp(r'[^\d+]'), '')}',
    );
    if (!await launchUrl(whatsappUri)) {
      throw Exception('No se pudo abrir WhatsApp');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            if (isSocial) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.facebook, color: Color(0xFF1877F2)),
                    onPressed: () => _launchUrl('https://www.facebook.com/profile.php?id=100029070852160'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt, color: Color(0xFFE4405F)),
                    onPressed: () => _launchUrl('https://www.instagram.com/fuentemaggys/'),
                  ),
                ],
              ),
            ] else if (isContact) ...[
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.phone, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        phoneNumber!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(FontAwesomeIcons.whatsapp, color: Color(0xFF25D366), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        whatsappNumber!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.phone, color: Colors.green),
                        tooltip: 'Llamar',
                        onPressed: () => _launchPhone(phoneNumber!),
                      ),
                      IconButton(
                        icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Color(0xFF25D366)),
                        tooltip: 'WhatsApp',
                        onPressed: () => _launchWhatsApp(whatsappNumber!),
                      ),
                    ],
                  ),
                ],
              ),
            ] else if (isLocation) ...[
              InkWell(
                onTap: () => _launchUrl(locationUrl!),
                child: Column(
                  children: [
                    Text(
                      content!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Icon(Icons.map, color: Colors.red, size: 24),
                    const SizedBox(height: 4),
                    Text(
                      'Ver en Google Maps',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ] else
              Text(content!, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
} 