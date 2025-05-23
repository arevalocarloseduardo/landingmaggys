import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// Assuming these sections exist and are correctly implemented
import 'sections/hero_section.dart';
import 'sections/product_section.dart';
import 'sections/info_section.dart';
import 'sections/contact_section.dart';
import 'sections/rewards_section.dart';
import 'sections/inauguration_countdown_section.dart';

// Define the WaveClipper class here or in semicircle_clipper.dart
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    // Start at the top-left corner
    path.lineTo(0, 0);

    // Define the height of the semicircles (depth of the wave)
    final double waveHeight = 20; // Adjust this value to control the depth of the semicircles
    // Define the width of each semicircle
    final double semicircleWidth = size.width / 6; // Adjust this to control the number of semicircles

    // Draw the semicircles
    for (int i = 0; i < 6; i++) { // Assuming 6 semicircles based on the image
      final double startX = i * semicircleWidth;
      final double midX = startX + semicircleWidth / 2;
      final double endX = startX + semicircleWidth;

      // First part of the semicircle (going down)
      path.quadraticBezierTo(
        startX + semicircleWidth / 4, 0, // Control point x (closer to start), Control point y (at top)
        midX, waveHeight, // End point of the first curve (bottom of the semicircle)
      );

      // Second part of the semicircle (going up)
      path.quadraticBezierTo(
        startX + (3 * semicircleWidth / 4), waveHeight, // Control point x (closer to end), Control point y (at bottom)
        endX, 0, // End point of the second curve (back to top)
      );
    }

    // Close the path to form a shape, going down to the bottom right, then bottom left
    path.lineTo(size.width, size.height); // Move to bottom-right
    path.lineTo(0, size.height); // Move to bottom-left
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false; // Only reclip if the clipper's properties change
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.yellow,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                ClipPath(
                  clipper: SvgWaveClipper(),
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    color: Color.fromARGB(255, 234, 24, 24),
                  ),
                ),
                Positioned(
                  left: 24,
                  top: 40,
                  child: Text(
                    "Maggy's",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                decoration: null,
                child: const HeroSection(),
              ),
              const InaugurationCountdownSection(),
              const ProductSection(),
              const RewardsSection(),
              const InfoSection(),
              const ContactSection(),
              // Footer personalizado
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                color: Color(0xFF77CAE6),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '© 2025 Maggy\'s. Todos los derechos reservados.',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Diseñado con ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                        Icon(Icons.favorite, color: Colors.red, size: 18),
                        Text(
                          ' para Maggy\'s.',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      '¡Gracias por visitarnos! v1.1',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class SvgWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.75);
    // Ancho mínimo de cada semicirculo
    double semicircleWidth = 60;
    int semicircles = (size.width / semicircleWidth).round();
    double waveWidth = size.width / semicircles;
    double baseY = size.height * 0.75;
    for (int i = semicircles; i > 0; i--) {
      double x2 = waveWidth * (i - 1);
      path.arcToPoint(
        Offset(x2, baseY),
        radius: Radius.circular(waveWidth / 2),
        clockwise: true,
      );
    }
    path.lineTo(0, baseY);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
