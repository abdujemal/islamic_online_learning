// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Subscription {
  final String id;
  final String userId;
  final String plan;
  final String status;
  final DateTime startedAt;
  final DateTime expiresAt;
  final String startedAtH;
  final String expiresAtH;
  final String paymentProvider;
  Subscription({
    required this.id,
    required this.userId,
    required this.plan,
    required this.status,
    required this.startedAt,
    required this.expiresAt,
    required this.startedAtH,
    required this.expiresAtH,
    required this.paymentProvider,
  });

  Subscription copyWith({
    String? id,
    String? userId,
    String? plan,
    String? status,
    DateTime? startedAt,
    DateTime? expiresAt,
    String? startedAtH,
    String? expiresAtH,
    String? paymentProvider,
  }) {
    return Subscription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      plan: plan ?? this.plan,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      startedAtH: startedAtH ?? this.startedAtH,
      expiresAtH: expiresAtH ?? this.expiresAtH,
      paymentProvider: paymentProvider ?? this.paymentProvider,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'plan': plan,
      'status': status,
      'startedAt': startedAt.toString(),
      'expiresAt': expiresAt.toString(),
      'startedAtH': startedAtH,
      'expiresAtH': expiresAtH,
      'paymentProvider': paymentProvider,
    };
  }

  bool isDue() {
    DateTime today = DateTime.now();
    return today.compareTo(expiresAt) == 1;
  }

  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
      id: map['id'] as String,
      userId: map['userId'] as String,
      plan: map['plan'] as String,
      status: map['status'] as String,
      startedAt: DateTime.parse(map['startedAt'] as String).toLocal(),
      expiresAt: DateTime.parse(map['expiresAt'] as String).toLocal(),
      startedAtH: map['startedAtH'] as String,
      expiresAtH: map['expiresAtH'] as String,
      paymentProvider: map['paymentProvider'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Subscription.fromJson(String source) =>
      Subscription.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Subscription(id: $id, userId: $userId, plan: $plan, status: $status, startedAt: $startedAt, expiresAt: $expiresAt, startedAtH: $startedAtH, expiresAtH: $expiresAtH, paymentProvider: $paymentProvider)';
  }

  @override
  bool operator ==(covariant Subscription other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.plan == plan &&
        other.status == status &&
        other.startedAt == startedAt &&
        other.expiresAt == expiresAt &&
        other.startedAtH == startedAtH &&
        other.expiresAtH == expiresAtH &&
        other.paymentProvider == paymentProvider;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        plan.hashCode ^
        status.hashCode ^
        startedAt.hashCode ^
        expiresAt.hashCode ^
        startedAtH.hashCode ^
        expiresAtH.hashCode ^
        paymentProvider.hashCode;
  }
}
