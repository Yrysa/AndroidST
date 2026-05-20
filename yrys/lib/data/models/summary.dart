// made by Yrysa
import 'image_file.dart';
import 'titles_set.dart';

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

  bool get hasImage => imageUrl != null;

  String? get imageUrl {
    if (originalImage != null && originalImage!.isValid) return originalImage!.source;
    if (thumbnail != null && thumbnail!.isValid) return thumbnail!.source;
    return null;
  }

  bool get hasUrl => url.isNotEmpty;

  factory Summary.fromJson(Map<String, Object?> json) {
    final titlesJson = json['titles'];
    final contentUrls = json['content_urls'];
    final desktop = contentUrls is Map<String, Object?> ? contentUrls['desktop'] : null;
    final pageUrl = desktop is Map<String, Object?> ? desktop['page'] as String? : null;

    final thumbnailJson = json['thumbnail'];
    final originalImageJson = json['originalimage'];

    return Summary(
      titles: titlesJson is Map<String, Object?>
          ? TitlesSet.fromJson(titlesJson)
          : const TitlesSet(canonical: 'unknown', normalized: 'Без названия', display: 'Без названия'),
      pageId: json['pageid'] as int? ?? 0,
      extract: json['extract'] as String? ?? 'Wikipedia не вернула краткое описание для этой статьи.',
      extractHtml: json['extract_html'] as String? ?? '',
      lang: json['lang'] as String? ?? 'ru',
      dir: json['dir'] as String? ?? 'ltr',
      url: pageUrl ?? '',
      description: json['description'] as String?,
      thumbnail: thumbnailJson is Map<String, Object?> ? ImageFile.fromJson(thumbnailJson) : null,
      originalImage: originalImageJson is Map<String, Object?> ? ImageFile.fromJson(originalImageJson) : null,
    );
  }
}
