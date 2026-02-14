// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Payment {
  final String id;
  final String userId;
  final String txnId;
  final int expectedAmount;
  final int? paidAmount;
  final String? senderPhone;
  final String paymentType;
  final String status;
  final String? failedReason;
  final DateTime startDate;
  final String paymentProvider;
  final DateTime createdAt;
  Payment({
    required this.id,
    required this.userId,
    required this.txnId,
    required this.expectedAmount,
    this.paidAmount,
    this.senderPhone,
    required this.paymentType,
    required this.status,
    this.failedReason,
    required this.startDate,
    required this.paymentProvider,
    required this.createdAt,
  });

  Payment copyWith({
    String? id,
    String? userId,
    String? txnId,
    int? expectedAmount,
    int? paidAmount,
    String? senderPhone,
    String? paymentType,
    String? status,
    String? failedReason,
    DateTime? startDate,
    String? paymentProvider,
    DateTime? createdAt,
  }) {
    return Payment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      txnId: txnId ?? this.txnId,
      expectedAmount: expectedAmount ?? this.expectedAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      senderPhone: senderPhone ?? this.senderPhone,
      paymentType: paymentType ?? this.paymentType,
      status: status ?? this.status,
      failedReason: failedReason ?? this.failedReason,
      startDate: startDate ?? this.startDate,
      paymentProvider: paymentProvider ?? this.paymentProvider,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'txnId': txnId,
      'expectedAmount': expectedAmount,
      'paidAmount': paidAmount,
      'senderPhone': senderPhone,
      'paymentType': paymentType,
      'status': status,
      'failedReason': failedReason,
      'startDate': startDate.toString(),
      'paymentProvider': paymentProvider,
      'createdAt': createdAt.toString(),
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'] as String,
      userId: map['userId'] as String,
      txnId: map['txnId'] as String,
      expectedAmount: map['expectedAmount'] as int,
      paidAmount: map['paidAmount'] != null ? map['paidAmount'] as int : null,
      senderPhone: map['senderPhone'] != null ? map['senderPhone'] as String : null,
      paymentType: map['paymentType'] as String,
      status: map['status'] as String,
      failedReason: map['failedReason'] != null ? map['failedReason'] as String : null,
      startDate: DateTime.parse(map['startDate'] as String).toLocal(),
      paymentProvider: map['paymentProvider'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String).toLocal(),
    );
  }

  static List<Payment> listFromJson(String responseBody) {
    final parsed = jsonDecode(responseBody) as List<dynamic>;
    return parsed.map((json) => Payment.fromMap(json)).toList();
  }

  String toJson() => json.encode(toMap());

  factory Payment.fromJson(String source) => Payment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Payment(id: $id, userId: $userId, txnId: $txnId, expectedAmount: $expectedAmount, paidAmount: $paidAmount, senderPhone: $senderPhone, paymentType: $paymentType, status: $status, failedReason: $failedReason, startDate: $startDate, paymentProvider: $paymentProvider, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant Payment other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.userId == userId &&
      other.txnId == txnId &&
      other.expectedAmount == expectedAmount &&
      other.paidAmount == paidAmount &&
      other.senderPhone == senderPhone &&
      other.paymentType == paymentType &&
      other.status == status &&
      other.failedReason == failedReason &&
      other.startDate == startDate &&
      other.paymentProvider == paymentProvider &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userId.hashCode ^
      txnId.hashCode ^
      expectedAmount.hashCode ^
      paidAmount.hashCode ^
      senderPhone.hashCode ^
      paymentType.hashCode ^
      status.hashCode ^
      failedReason.hashCode ^
      startDate.hashCode ^
      paymentProvider.hashCode ^
      createdAt.hashCode;
  }
}
