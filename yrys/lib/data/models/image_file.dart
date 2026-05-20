// made by Yrysa
class ImageFile {
  final String source;
  final int width;
  final int height;

  const ImageFile({required this.source, required this.width, required this.height});

  factory ImageFile.fromJson(Map<String, Object?> json) {
    return ImageFile(
      source: json['source'] as String? ?? '',
      width: json['width'] as int? ?? 0,
      height: json['height'] as int? ?? 0,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'source': source,
      'width': width,
      'height': height,
    };
  }

  bool get isValid => source.isNotEmpty;
}
