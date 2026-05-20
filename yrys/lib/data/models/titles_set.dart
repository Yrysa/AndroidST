// made by Yrysa
class TitlesSet {
  final String canonical;
  final String normalized;
  final String display;

  const TitlesSet({
    required this.canonical,
    required this.normalized,
    required this.display,
  });

  factory TitlesSet.fromJson(Map<String, Object?> json) {
    final normalized = json['normalized'] as String?;
    final display = json['display'] as String?;
    final canonical = json['canonical'] as String?;

    return TitlesSet(
      canonical: canonical ?? normalized ?? display ?? 'unknown',
      normalized: normalized ?? display ?? canonical ?? 'Без названия',
      display: display ?? normalized ?? canonical ?? 'Без названия',
    );
  }
}
