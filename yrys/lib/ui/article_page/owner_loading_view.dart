// made by Yrysa
import 'package:flutter/material.dart';

class OwnerLoadingView extends StatelessWidget {
  const OwnerLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      key: ValueKey('loading'),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 22),
            Text(
              'made by Yrysa',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'GitHub: https://github.com/Yrysa',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Загрузка случайной статьи Wikipedia...',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
