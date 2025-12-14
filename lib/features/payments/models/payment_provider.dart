// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PaymentProvider {
  final String id;
  final String name;
  final String accountName;
  final String accountNumber;
  final String code;
  final bool isActive;
  final String logoUrl;
  final String guideUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  PaymentProvider({
    required this.id,
    required this.name,
    required this.accountName,
    required this.accountNumber,
    required this.code,
    required this.isActive,
    required this.logoUrl,
    required this.guideUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  PaymentProvider copyWith({
    String? id,
    String? name,
    String? accountName,
    String? accountNumber,
    String? code,
    bool? isActive,
    String? logoUrl,
    String? guideUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentProvider(
      id: id ?? this.id,
      name: name ?? this.name,
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      code: code ?? this.code,
      isActive: isActive ?? this.isActive,
      logoUrl: logoUrl ?? this.logoUrl,
      guideUrl: guideUrl ?? this.guideUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'accountName': accountName,
      'accountNumber': accountNumber,
      'code': code,
      'isActive': isActive,
      'logoUrl': logoUrl,
      'guideUrl': guideUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  static List<PaymentProvider> listFromJson(String responseBody) {
    final parsed = jsonDecode(responseBody) as List<dynamic>;
    return parsed.map((json) => PaymentProvider.fromMap(json)).toList();
  }

  factory PaymentProvider.fromMap(Map<String, dynamic> map) {
    return PaymentProvider(
      id: map['id'] as String,
      name: map['name'] as String,
      accountName: map['accountName'] as String,
      accountNumber: map['accountNumber'] as String,
      code: map['code'] as String,
      isActive: map['isActive'] as bool,
      logoUrl: map['logoUrl'] as String,
      guideUrl: map['guideUrl'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentProvider.fromJson(String source) => PaymentProvider.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PaymentProvider(id: $id, name: $name, accountName: $accountName, accountNumber: $accountNumber, code: $code, isActive: $isActive, logoUrl: $logoUrl, guideUrl: $guideUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant PaymentProvider other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.accountName == accountName &&
      other.accountNumber == accountNumber &&
      other.code == code &&
      other.isActive == isActive &&
      other.logoUrl == logoUrl &&
      other.guideUrl == guideUrl &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      accountName.hashCode ^
      accountNumber.hashCode ^
      code.hashCode ^
      isActive.hashCode ^
      logoUrl.hashCode ^
      guideUrl.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
  }
}
