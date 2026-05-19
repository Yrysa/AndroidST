// made by Yrysa
import 'package:flutter/material.dart';

import '../../models/summary.dart';

class ArticleWidget extends StatelessWidget {
  final Summary summary;

  const ArticleWidget({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final image = summary.originalImage?.source ?? summary.thumbnail?.source;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (image != null && image.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 18),
            Text(
              summary.titles.normalized,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            if (summary.description != null) ...[
              const SizedBox(height: 8),
              Text(
                summary.description!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
            const SizedBox(height: 14),
            Text(
              summary.extract,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.45),
            ),
          ],
        ),
      ),
    );
  }
}
