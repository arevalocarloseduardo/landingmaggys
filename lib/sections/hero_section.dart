import 'package:flutter/material.dart';
import './reservation_dialog.dart';
import 'package:flutter_arc_text/flutter_arc_text.dart';
import 'dart:math';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        // Fondo blanco con logo y degradado
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.yellow,
                Colors.yellow,
                 // Azul oscuro igual al card de abajo
              ],
              stops: [0.7, 1.0],
            ),
          ),
          padding: const EdgeInsets.only(top: 64, bottom: 40),
          child: Column(
            children: [
              Text(
                "Maggy's\n",
                style: TextStyle(
                  color: Color.fromARGB(255, 243, 30, 30),
                  fontWeight: FontWeight.w900,
                  fontSize: 84,
                  letterSpacing: 2,
                  shadows: [Shadow(color: Colors.black.withOpacity(0.18), blurRadius: 8, offset: Offset(0, 2))],
                ),
              ),
              Container(height: 50),

              // recorta la mitad superior
              Container(
                
                width: 350,
                height: 20,
                child: CustomPaint(painter: ArcDividerPainter()),
              ),

              // Divider en arco
              Container(
                color: Colors.white,
                width: 0,
                height: 0,
                child: ArcText(
                  radius: 150,
                  text: 'FUENTE DE SODA',
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    letterSpacing: 3,
                  ),
                  startAngle: 0, // Ajuste para que quede arqueado hacia arriba
                  startAngleAlignment: StartAngleAlignment.center,
                  placement: Placement.outside,
                  direction: Direction.clockwise,
                ),
              ),

              // Línea curva decorativa
            ],
          ),
        ),
        // Fondo oscuro con promo
        // Bloque de promo de inauguración eliminado
      ],
    );
  }
}

// Widget para las esferas decorativas
class _DecorativeBall extends StatelessWidget {
  final double size;
  final Color color;
  const _DecorativeBall({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

// Divider en arco
class ArcDividerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB(255, 243, 30, 30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    final radius = size.width / 2 - 4;
    final rect = Rect.fromCircle(center: Offset(size.width / 2, 0), radius: radius);
    final sweepAngle = (pi / 2) * 0.87;
    final startAngle = (5 * pi / 4) * -0.58;
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
