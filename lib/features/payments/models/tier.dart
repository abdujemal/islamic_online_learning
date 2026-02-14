// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Tier {
  final String type;
  final String duration;
  final int off;
  final String currency;
  final int price;
  Tier({
    required this.type,
    required this.duration,
    required this.currency,
    required this.price,
    required this.off,
  });

  Tier copyWith({
    String? type,
    String? duration,
    String? currency,
    int? price,
    int? off,
  }) {
    return Tier(
      type: type ?? this.type,
      duration: duration ?? this.duration,
      currency: currency ?? this.currency,
      price: price ?? this.price,
      off: off ?? this.off,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'duration': duration,
      'currency': currency,
      'price': price,
      'off': off,
    };
  }

  factory Tier.fromMap(Map<String, dynamic> map) {
    return Tier(
      type: map['type'] as String,
      duration: map['duration'] as String,
      currency: map['currency'] as String,
      price: map['price'] as int,
      off: map['off'] as int,
    );
  }

  static List<Tier> listFromJson(String responseBody) {
    final parsed = jsonDecode(responseBody) as List<dynamic>;
    return parsed.map((json) => Tier.fromMap(json)).toList();
  }

  String toJson() => json.encode(toMap());

  factory Tier.fromJson(String source) =>
      Tier.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Tier(type: $type, duration: $duration, currency: $currency, price: $price, off: $off)';
  }

  @override
  bool operator ==(covariant Tier other) {
    if (identical(this, other)) return true;

    return other.type == type &&
        other.duration == duration &&
        other.currency == currency &&
        other.price == price &&
        other.off == off;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        duration.hashCode ^
        currency.hashCode ^
        price.hashCode ^
        off.hashCode;
  }
}
