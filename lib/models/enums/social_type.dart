import 'dart:ui';

enum SocialType {
  naver("네이버", Color(0xFF03C75A)),
  kakao("카카오", Color(0xFFFEE500)),
  apple("Apple", Color(0xFFF6F6F9));

  const SocialType(this.label, this.color);
  final String label;
  final Color color;
}
