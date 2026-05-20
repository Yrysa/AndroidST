// made by Yrysa
class LocalUser {
  final String nickname;
  final String email;
  final String status;
  final String avatar;
  final String registeredAt;
  final bool isGuest;

  const LocalUser({
    required this.nickname,
    required this.email,
    required this.status,
    required this.avatar,
    required this.registeredAt,
    required this.isGuest,
  });

  factory LocalUser.guest() {
    return LocalUser(
      nickname: 'Yrysa Guest',
      email: 'guest@local.app',
      status: 'Discover knowledge beautifully',
      avatar: '🧠',
      registeredAt: DateTime.now().toIso8601String(),
      isGuest: true,
    );
  }

  factory LocalUser.fromJson(Map<String, Object?> json) {
    return LocalUser(
      nickname: json['nickname'] as String? ?? 'Yrysa User',
      email: json['email'] as String? ?? '',
      status: json['status'] as String? ?? 'Discover knowledge beautifully',
      avatar: json['avatar'] as String? ?? '🧠',
      registeredAt: json['registeredAt'] as String? ?? DateTime.now().toIso8601String(),
      isGuest: json['isGuest'] as bool? ?? true,
    );
  }

  Map<String, Object?> toJson() => {
        'nickname': nickname,
        'email': email,
        'status': status,
        'avatar': avatar,
        'registeredAt': registeredAt,
        'isGuest': isGuest,
      };

  LocalUser copyWith({String? nickname, String? email, String? status, String? avatar, bool? isGuest}) {
    return LocalUser(
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      status: status ?? this.status,
      avatar: avatar ?? this.avatar,
      registeredAt: registeredAt,
      isGuest: isGuest ?? this.isGuest,
    );
  }
}
