// made by Yrysa
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';
import 'widgets/splash_feature_text.dart';
import 'widgets/yrysa_loading_indicator.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> _openGithub() async {
    final uri = Uri.parse(AppConstants.githubUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF140A2E), Color(0xFF27115C), Color(0xFF07111F)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: 420,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34),
                color: Colors.white.withValues(alpha: 0.08),
                border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
                boxShadow: [BoxShadow(color: Colors.purpleAccent.withValues(alpha: 0.22), blurRadius: 44)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const YrysaLoadingIndicator(),
                  const SizedBox(height: 26),
                  const Text(
                    AppConstants.appName,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: -0.8),
                  ),
                  const SizedBox(height: 8),
                  const Text('made by Yrysa', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 14),
                  TextButton.icon(
                    onPressed: _openGithub,
                    icon: const Icon(Icons.code_rounded, color: Colors.white),
                    label: const Text('github.com/Yrysa', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 12),
                  const SplashFeatureText(),
                  const SizedBox(height: 8),
                  const Text('Powered by Wikipedia • Discover knowledge beautifully', textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
