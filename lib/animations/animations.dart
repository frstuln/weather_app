import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class ComplexWeatherAnimations extends StatelessWidget {
  final String condition;
  final bool isNight;

  const ComplexWeatherAnimations({
    required this.condition,
    required this.isNight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base animation
        _getBaseAnimation(),
        // // Particle effects
        // _getParticleEffects(),
        // // Special effects
        // if (_needsSpecialEffects()) _getSpecialEffects(),
      ],
    );
  }

  Widget _getBaseAnimation() {
    final String animationPath = _getAnimationPath();
    return Lottie.asset(
      animationPath,
      fit: BoxFit.cover,
    );
  }

  String _getAnimationPath() {
    final String timePrefix = isNight ? 'night_' : 'day_';
    switch (condition.toLowerCase()) {
      case 'thunderstorm':
        return 'assets/animations/${timePrefix}thunder.json';
      case 'tornado':
        return 'assets/animations/tornado.json';
      case 'hurricane':
        return 'assets/animations/hurricane.json';
      // Add more conditions...
      default:
        return 'assets/animations/${timePrefix}clear.json';
    }
  }
}
