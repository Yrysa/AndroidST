// made by Yrysa
class Summary {
  final TitlesSet titles;
  final int pageId;
  final String extract;
  final String extractHtml;
  final String lang;
  final String dir;
  final String url;
  final String? description;
  final ImageFile? thumbnail;
  final ImageFile? originalImage;

  const Summary({
    required this.titles,
    required this.pageId,
    required this.extract,
    required this.extractHtml,
    required this.lang,
    required this.dir,
    required this.url,
    this.description,
    this.thumbnail,
    this.originalImage,
  });

  bool get hasImage => originalImage != null || thumbnail != null;

  factory Summary.fromJson(Map<String, dynamic> json) {
    final contentUrls = json['content_urls'] as Map<String, dynamic>?;
    final desktop = contentUrls?['desktop'] as Map<String, dynamic>?;

    return Summary(
      titles: TitlesSet.fromJson(json['titles'] as Map<String, dynamic>),
      pageId: json['pageid'] as int? ?? 0,
      extract: json['extract'] as String? ?? 'No extract found.',
      extractHtml: json['extract_html'] as String? ?? '',
      lang: json['lang'] as String? ?? 'en',
      dir: json['dir'] as String? ?? 'ltr',
      url: desktop?['page'] as String? ?? '',
      description: json['description'] as String?,
      thumbnail: json['thumbnail'] is Map<String, dynamic>
          ? ImageFile.fromJson(json['thumbnail'] as Map<String, dynamic>)
          : null,
      originalImage: json['originalimage'] is Map<String, dynamic>
          ? ImageFile.fromJson(json['originalimage'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ImageFile {
  final String source;
  final int width;
  final int height;

  const ImageFile({required this.source, required this.width, required this.height});

  factory ImageFile.fromJson(Map<String, dynamic> json) {
    return ImageFile(
      source: json['source'] as String? ?? '',
      width: json['width'] as int? ?? 0,
      height: json['height'] as int? ?? 0,
    );
  }
}

class TitlesSet {
  final String canonical;
  final String normalized;
  final String display;

  const TitlesSet({
    required this.canonical,
    required this.normalized,
    required this.display,
  });

  factory TitlesSet.fromJson(Map<String, dynamic> json) {
    return TitlesSet(
      canonical: json['canonical'] as String? ?? '',
      normalized: json['normalized'] as String? ?? 'Unknown article',
      display: json['display'] as String? ?? 'Unknown article',
    );
  }
}
