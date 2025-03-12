import 'package:flutter/material.dart';
import '../models/pic_card.dart';

class PicCardWidget extends StatelessWidget {
  final PicCard card;
  final double size;
  final bool withPulse;
  final Animation<double>? pulseAnimation;

  const PicCardWidget({
    super.key,
    required this.card,
    required this.size,
    this.withPulse = false,
    this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              card.imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: size,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            card.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );

    if (withPulse && pulseAnimation != null) {
      return Stack(
        children: [
          cardContent,
          Positioned(
            right: 8,
            top: 8,
            child: AnimatedBuilder(
              animation: pulseAnimation!,
              builder: (context, child) {
                return Transform.scale(
                  scale: pulseAnimation!.value * 0.8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.touch_app,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    return cardContent;
  }
}