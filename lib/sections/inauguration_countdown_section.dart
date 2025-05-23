import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

class InaugurationCountdownSection extends StatelessWidget {
  const InaugurationCountdownSection({super.key});

  @override
  Widget build(BuildContext context) {
    final inaugurationDate = DateTime(2025, 5, 23, 17, 0, 0);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
           Colors.yellow,
            Color(0xFFFFC300),
            Color(0xFFEA1818),
            Colors.white
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
         
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '¡GRAN INAUGURACIÓN!',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
              shadows: [
                Shadow(
                  color: Colors.black45,
                  blurRadius: 8,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          const SizedBox(height: 32),
          TimerCountdown(
            format: CountDownTimerFormat.daysHoursMinutesSeconds,
            endTime: inaugurationDate,
            enableDescriptions: true,
            daysDescription: 'DÍAS',
            hoursDescription: 'HORAS',
            minutesDescription: 'MIN',
            secondsDescription: 'SEG',
            timeTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black38,
                  blurRadius: 6,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            descriptionTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
            colonsTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
            spacerWidth: 16,
            onEnd: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡La espera terminó!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          Text(
            '¡No te lo pierdas! probá nuestros productos y disfrutá de una experiencia única.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w400,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(1, 1),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 