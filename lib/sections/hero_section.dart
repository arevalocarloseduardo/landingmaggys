import 'package:flutter/material.dart';
import './reservation_dialog.dart';
import 'package:flutter_arc_text/flutter_arc_text.dart';

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
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
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
                Colors.white,
                Color(0xFF0A1026), // Azul oscuro igual al card de abajo
              ],
              stops: [0.7, 1.0],
            ),
          ),
          padding: const EdgeInsets.only(top: 64, bottom: 40),
          child: Column(
            children: [
              Text(
                "Maggy's",
                style: TextStyle(
                  color: Color.fromARGB(255, 243, 30, 30),
                  fontWeight: FontWeight.w900,
                  fontSize: 84,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
                Container(height: 250,), 
              Container(color: Colors.white,
                width: 340,
                height: 0,
                child: ArcText(
                  radius: 220,
                  text: 'FUENTE DE SODA',
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    letterSpacing: 2,
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0A1026), // Fondo oscuro
                Color(0xFF1B2236),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              // Esferas decorativas
              Positioned(
                top: -30,
                left: -30,
                child: _DecorativeBall(size: 90, color: Color(0xFFE53935).withOpacity(0.18)),
              ),
              Positioned(
                bottom: -40,
                right: -40,
                child: _DecorativeBall(size: 120, color: Color(0xFFFB8C00).withOpacity(0.15)),
              ),
              Positioned(
                top: 60,
                right: 40,
                child: _DecorativeBall(size: 40, color: Color(0xFF43A047).withOpacity(0.18)),
              ),
              // Contenido principal
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        // Borde (stroke) para el texto
                        Text(
                          'PROMO INAUGURACIÓN',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 46,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 4
                              ..color = Colors.black.withOpacity(0.55),
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.35),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // Texto principal encima
                        Text(
                          'PROMO INAUGURACIÓN',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Color.fromARGB(255, 244, 33, 33),
                            fontWeight: FontWeight.w900,
                            fontSize: 46,
                            letterSpacing: 3,
                            shadows: [
                              Shadow(
                                color: Colors.white.withOpacity(0.45),
                                blurRadius: 12,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // 2x1 grande
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 38),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: Color(0xFFFF5252).withOpacity(0.18), width: 2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '2',
                            style: TextStyle(
                              color: Color.fromARGB(255, 240, 35, 35),
                              fontWeight: FontWeight.w900,
                              fontSize: 90,
                              shadows: [
                                Shadow(
                                  color: Color.fromARGB(255, 240, 35, 35).withOpacity(0.18),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(0, -4), // Eleva la 'x' 18px hacia arriba
                            child: Text(
                              'x',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 78,
                                shadows: [
                                  Shadow(
                                    color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.18),
                                    blurRadius: 12,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Text(
                            '1',
                            style: TextStyle(
                              color: Color.fromARGB(255, 240, 35, 35),
                              fontWeight: FontWeight.w900,
                              fontSize: 90,
                              shadows: [
                                Shadow(
                                  color: Color.fromARGB(255, 240, 35, 35).withOpacity(0.18),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'En licuados y postres shot',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '¡Solo por tiempo limitado!',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.85),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ReservationButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
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
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
} 