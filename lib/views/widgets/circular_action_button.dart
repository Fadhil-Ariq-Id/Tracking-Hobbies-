import 'package:flutter/material.dart';

class CircularActionButton extends StatelessWidget {
  final String emoji;
  final String text;
  final VoidCallback onTap;
  final Color borderColor;

  const CircularActionButton({
    super.key,
    required this.emoji,
    required this.text,
    required this.onTap,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 180,
        height: 180,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Circular border with text
            CustomPaint(
              size: const Size(180, 180),
              painter: CircularTextPainter(
                text: text,
                emoji: emoji,
                borderColor: borderColor,
              ),
            ),
            // Center icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: borderColor,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: borderColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.play_arrow_rounded,
                  size: 48,
                  color: borderColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularTextPainter extends CustomPainter {
  final String text;
  final String emoji;
  final Color borderColor;

  CircularTextPainter({
    required this.text,
    required this.emoji,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Draw circle border
    final paint = Paint()
      ..color = borderColor.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius, paint);

    // Draw text around circle
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final words = text.split(' ');
    final totalWords = words.length;
    final angleStep = (2 * 3.14159) / (totalWords * 2);

    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      final angle = i * angleStep * 2 - 3.14159 / 2;

      textPainter.text = TextSpan(
        text: word,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: borderColor,
        ),
      );

      textPainter.layout();

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle + 3.14159 / 2);
      canvas.translate(-textPainter.width / 2, -radius - 5);
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();

      // Draw emoji
      if (i % 2 == 0 && i < totalWords - 1) {
        final emojiAngle = (i + 0.5) * angleStep * 2 - 3.14159 / 2;
        final emojiX = center.dx + radius * 0.9 * (emojiAngle).dx;
        final emojiY = center.dy + radius * 0.9 * (emojiAngle).dy;

        final emojiPainter = TextPainter(
          text: TextSpan(
            text: emoji,
            style: const TextStyle(fontSize: 14),
          ),
          textDirection: TextDirection.ltr,
        );

        emojiPainter.layout();
        emojiPainter.paint(
          canvas,
          Offset(emojiX - emojiPainter.width / 2, emojiY - emojiPainter.height / 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

extension on double {
  double get dx => (this).cos();
  double get dy => (this).sin();
}

double cos(double radians) => radians.cos();
double sin(double radians) => radians.sin();

extension on double {
  double cos() {
    return (this * 180 / 3.14159).toRadians().cosine();
  }

  double sin() {
    return (this * 180 / 3.14159).toRadians().sine();
  }

  double toRadians() => this * 3.14159 / 180;
  
  double cosine() {
    // Taylor series approximation
    double x = this;
    double result = 1.0;
    double term = 1.0;
    for (int i = 1; i < 10; i++) {
      term *= -x * x / ((2 * i - 1) * (2 * i));
      result += term;
    }
    return result;
  }

  double sine() {
    // Taylor series approximation
    double x = this;
    double result = x;
    double term = x;
    for (int i = 1; i < 10; i++) {
      term *= -x * x / ((2 * i) * (2 * i + 1));
      result += term;
    }
    return result;
  }
}