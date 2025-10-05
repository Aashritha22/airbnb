import 'package:equatable/equatable.dart';

enum PaymentStatus {
  pending,
  completed,
  failed,
  refunded,
  cancelled,
}

enum PaymentMethod {
  creditCard,
  debitCard,
  paypal,
  bankTransfer,
  stripe,
  applePay,
  googlePay,
}

class Payment extends Equatable {
  const Payment({
    required this.id,
    required this.bookingId,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.paymentMethod,
    required this.transactionId,
    required this.paymentDate,
    this.feeAmount,
    this.refundAmount,
    this.refundDate,
    this.notes,
  });

  final String id;
  final String bookingId;
  final String userId;
  final double amount;
  final String currency;
  final PaymentStatus status;
  final PaymentMethod paymentMethod;
  final String transactionId;
  final DateTime paymentDate;
  final double? feeAmount;
  final double? refundAmount;
  final DateTime? refundDate;
  final String? notes;

  Payment copyWith({
    String? id,
    String? bookingId,
    String? userId,
    double? amount,
    String? currency,
    PaymentStatus? status,
    PaymentMethod? paymentMethod,
    String? transactionId,
    DateTime? paymentDate,
    double? feeAmount,
    double? refundAmount,
    DateTime? refundDate,
    String? notes,
  }) {
    return Payment(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionId: transactionId ?? this.transactionId,
      paymentDate: paymentDate ?? this.paymentDate,
      feeAmount: feeAmount ?? this.feeAmount,
      refundAmount: refundAmount ?? this.refundAmount,
      refundDate: refundDate ?? this.refundDate,
      notes: notes ?? this.notes,
    );
  }

  String get statusText {
    switch (status) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.completed:
        return 'Completed';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.refunded:
        return 'Refunded';
      case PaymentStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get methodText {
    switch (paymentMethod) {
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.debitCard:
        return 'Debit Card';
      case PaymentMethod.paypal:
        return 'PayPal';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.stripe:
        return 'Stripe';
      case PaymentMethod.applePay:
        return 'Apple Pay';
      case PaymentMethod.googlePay:
        return 'Google Pay';
    }
  }

  @override
  List<Object?> get props => [
        id,
        bookingId,
        userId,
        amount,
        currency,
        status,
        paymentMethod,
        transactionId,
        paymentDate,
        feeAmount,
        refundAmount,
        refundDate,
        notes,
      ];

  // Sample data
  static List<Payment> samplePayments = [
    Payment(
      id: 'PAY001',
      bookingId: 'B001',
      userId: 'U001',
      amount: 1200.00,
      currency: 'USD',
      status: PaymentStatus.completed,
      paymentMethod: PaymentMethod.creditCard,
      transactionId: 'TXN_123456789',
      paymentDate: DateTime.now().subtract(const Duration(days: 2)),
      feeAmount: 36.00,
    ),
    Payment(
      id: 'PAY002',
      bookingId: 'B002',
      userId: 'U002',
      amount: 850.00,
      currency: 'USD',
      status: PaymentStatus.pending,
      paymentMethod: PaymentMethod.paypal,
      transactionId: 'TXN_987654321',
      paymentDate: DateTime.now().subtract(const Duration(hours: 5)),
      feeAmount: 25.50,
    ),
    Payment(
      id: 'PAY003',
      bookingId: 'B003',
      userId: 'U003',
      amount: 1500.00,
      currency: 'USD',
      status: PaymentStatus.refunded,
      paymentMethod: PaymentMethod.stripe,
      transactionId: 'TXN_456789123',
      paymentDate: DateTime.now().subtract(const Duration(days: 7)),
      feeAmount: 45.00,
      refundAmount: 1500.00,
      refundDate: DateTime.now().subtract(const Duration(days: 1)),
      notes: 'Guest requested cancellation due to travel restrictions.',
    ),
    Payment(
      id: 'PAY004',
      bookingId: 'B004',
      userId: 'U004',
      amount: 900.00,
      currency: 'USD',
      status: PaymentStatus.failed,
      paymentMethod: PaymentMethod.bankTransfer,
      transactionId: 'TXN_789123456',
      paymentDate: DateTime.now().subtract(const Duration(hours: 12)),
      feeAmount: 27.00,
      notes: 'Insufficient funds in bank account.',
    ),
    Payment(
      id: 'PAY005',
      bookingId: 'B005',
      userId: 'U005',
      amount: 2100.00,
      currency: 'USD',
      status: PaymentStatus.completed,
      paymentMethod: PaymentMethod.applePay,
      transactionId: 'TXN_321654987',
      paymentDate: DateTime.now().subtract(const Duration(days: 1)),
      feeAmount: 63.00,
    ),
  ];
}

class PaymentStats {
  const PaymentStats({
    required this.totalPayments,
    required this.totalAmount,
    required this.pendingPayments,
    required this.completedPayments,
    required this.failedPayments,
    required this.refundedPayments,
    required this.averageTransactionValue,
    required this.monthlyRevenue,
  });

  final int totalPayments;
  final double totalAmount;
  final int pendingPayments;
  final int completedPayments;
  final int failedPayments;
  final int refundedPayments;
  final double averageTransactionValue;
  final double monthlyRevenue;

  static PaymentStats calculateStats(List<Payment> payments) {
    final totalPayments = payments.length;
    final totalAmount = payments.fold(0.0, (sum, payment) => sum + payment.amount);
    final pendingPayments = payments.where((p) => p.status == PaymentStatus.pending).length;
    final completedPayments = payments.where((p) => p.status == PaymentStatus.completed).length;
    final failedPayments = payments.where((p) => p.status == PaymentStatus.failed).length;
    final refundedPayments = payments.where((p) => p.status == PaymentStatus.refunded).length;
    final averageTransactionValue = totalPayments > 0 ? totalAmount / totalPayments : 0.0;
    
    final currentMonth = DateTime.now().month;
    final currentYear = DateTime.now().year;
    final monthlyRevenue = payments
        .where((p) => p.paymentDate.month == currentMonth && 
                     p.paymentDate.year == currentYear &&
                     p.status == PaymentStatus.completed)
        .fold(0.0, (sum, payment) => sum + payment.amount);

    return PaymentStats(
      totalPayments: totalPayments,
      totalAmount: totalAmount,
      pendingPayments: pendingPayments,
      completedPayments: completedPayments,
      failedPayments: failedPayments,
      refundedPayments: refundedPayments,
      averageTransactionValue: averageTransactionValue,
      monthlyRevenue: monthlyRevenue,
    );
  }
}
