import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/payment.dart';
import '../widgets/admin_card.dart';
import '../widgets/admin_table.dart';
import '../widgets/responsive_layout.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  List<Payment> _payments = Payment.samplePayments;
  String _searchQuery = '';
  String _selectedStatus = 'All';
  String _selectedMethod = 'All';
  final PaymentStats _paymentStats = PaymentStats.calculateStats(Payment.samplePayments);

  final List<String> _statusFilters = [
    'All',
    'Pending',
    'Completed',
    'Failed',
    'Refunded',
    'Cancelled',
  ];

  final List<String> _methodFilters = [
    'All',
    'Credit Card',
    'Debit Card',
    'PayPal',
    'Bank Transfer',
    'Stripe',
    'Apple Pay',
    'Google Pay',
  ];

  void _updatePaymentStatus(Payment payment, PaymentStatus newStatus) {
    setState(() {
      final int index = _payments.indexOf(payment);
      if (index != -1) {
        _payments[index] = payment.copyWith(status: newStatus);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment status updated to ${newStatus.name}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  List<Payment> get _filteredPayments {
    return _payments.where((Payment payment) {
      final bool matchesSearch = payment.transactionId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          payment.id.toLowerCase().contains(_searchQuery.toLowerCase());
      final bool matchesStatus = _selectedStatus == 'All' || payment.statusText == _selectedStatus;
      final bool matchesMethod = _selectedMethod == 'All' || payment.methodText == _selectedMethod;
      return matchesSearch && matchesStatus && matchesMethod;
    }).toList();
  }

  Color _getStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return Colors.orange;
      case PaymentStatus.completed:
        return Colors.green;
      case PaymentStatus.failed:
        return Colors.red;
      case PaymentStatus.refunded:
        return Colors.blue;
      case PaymentStatus.cancelled:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Payment Management',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  // Handle export payments
                },
                icon: const Icon(Icons.download),
                label: const Text('Export'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE31C5F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Stats Cards
          ResponsiveLayout(
            mobile: Column(
              children: [
                AdminCard(
                  title: 'Total Payments',
                  value: _paymentStats.totalPayments.toString(),
                  icon: Icons.payment,
                  color: Colors.blue,
                  subtitle: 'Total amount: \$${_paymentStats.totalAmount.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 16),
                AdminCard(
                  title: 'Completed',
                  value: _paymentStats.completedPayments.toString(),
                  icon: Icons.check_circle,
                  color: Colors.green,
                  subtitle: '${((_paymentStats.completedPayments / _paymentStats.totalPayments) * 100).toStringAsFixed(1)}% success rate',
                ),
                const SizedBox(height: 16),
                AdminCard(
                  title: 'Pending',
                  value: _paymentStats.pendingPayments.toString(),
                  icon: Icons.schedule,
                  color: Colors.orange,
                  subtitle: 'Awaiting processing',
                ),
                const SizedBox(height: 16),
                AdminCard(
                  title: 'Monthly Revenue',
                  value: '\$${_paymentStats.monthlyRevenue.toStringAsFixed(2)}',
                  icon: Icons.trending_up,
                  color: Colors.purple,
                  subtitle: 'This month',
                ),
              ],
            ),
            desktop: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.8,
              children: [
                AdminCard(
                  title: 'Total Payments',
                  value: _paymentStats.totalPayments.toString(),
                  icon: Icons.payment,
                  color: Colors.blue,
                  subtitle: 'Total amount: \$${_paymentStats.totalAmount.toStringAsFixed(2)}',
                ),
                AdminCard(
                  title: 'Completed',
                  value: _paymentStats.completedPayments.toString(),
                  icon: Icons.check_circle,
                  color: Colors.green,
                  subtitle: '${((_paymentStats.completedPayments / _paymentStats.totalPayments) * 100).toStringAsFixed(1)}% success rate',
                ),
                AdminCard(
                  title: 'Pending',
                  value: _paymentStats.pendingPayments.toString(),
                  icon: Icons.schedule,
                  color: Colors.orange,
                  subtitle: 'Awaiting processing',
                ),
                AdminCard(
                  title: 'Monthly Revenue',
                  value: '\$${_paymentStats.monthlyRevenue.toStringAsFixed(2)}',
                  icon: Icons.trending_up,
                  color: Colors.purple,
                  subtitle: 'This month',
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Search and Filters
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.grey.shade50,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.grey.shade50,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by transaction ID or payment ID...',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE31C5F), Color(0xFFE31C5F)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Colors.grey.shade500,
                              ),
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Filter Chips
                Row(
                  children: [
                    const Text(
                      'Filters:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Status Filter
                            DropdownButton<String>(
                              value: _selectedStatus,
                              items: _statusFilters
                                  .map((String status) => DropdownMenuItem<String>(
                                        value: status,
                                        child: Text(status),
                                      ))
                                  .toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedStatus = newValue!;
                                });
                              },
                            ),
                            const SizedBox(width: 16),
                            // Method Filter
                            DropdownButton<String>(
                              value: _selectedMethod,
                              items: _methodFilters
                                  .map((String method) => DropdownMenuItem<String>(
                                        value: method,
                                        child: Text(method),
                                      ))
                                  .toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedMethod = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Payments Table
          AdminTable(
            headers: const [
              'Payment ID',
              'Transaction ID',
              'Amount',
              'Method',
              'Status',
              'Date',
              'Actions'
            ],
            rows: _filteredPayments.map((Payment payment) {
              return [
                Expanded(
                  child: Text(
                    payment.id,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Text(
                    payment.transactionId,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Text(
                    '\$${payment.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Text(
                    payment.methodText,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(payment.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    payment.statusText,
                    style: TextStyle(
                      color: _getStatusColor(payment.status),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(DateFormat('MMM dd, yyyy').format(payment.paymentDate)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: () {
                        _showPaymentDetails(payment);
                      },
                    ),
                    if (payment.status == PaymentStatus.pending) ...[
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          _updatePaymentStatus(payment, PaymentStatus.completed);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          _updatePaymentStatus(payment, PaymentStatus.failed);
                        },
                      ),
                    ],
                    if (payment.status == PaymentStatus.completed)
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.blue),
                        onPressed: () {
                          _showRefundDialog(payment);
                        },
                      ),
                  ],
                ),
              ];
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showPaymentDetails(Payment payment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Details - ${payment.id}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Transaction ID', payment.transactionId),
            _buildDetailRow('Amount', '\$${payment.amount.toStringAsFixed(2)}'),
            _buildDetailRow('Method', payment.methodText),
            _buildDetailRow('Status', payment.statusText),
            _buildDetailRow('Date', DateFormat('MMM dd, yyyy HH:mm').format(payment.paymentDate)),
            if (payment.feeAmount != null)
              _buildDetailRow('Fee', '\$${payment.feeAmount!.toStringAsFixed(2)}'),
            if (payment.refundAmount != null)
              _buildDetailRow('Refund Amount', '\$${payment.refundAmount!.toStringAsFixed(2)}'),
            if (payment.notes != null)
              _buildDetailRow('Notes', payment.notes!),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _showRefundDialog(Payment payment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Process Refund'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Refund amount for payment ${payment.id}:'),
            const SizedBox(height: 8),
            Text(
              '\$${payment.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE31C5F),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _updatePaymentStatus(
                payment,
                payment.copyWith(
                  status: PaymentStatus.refunded,
                  refundAmount: payment.amount,
                  refundDate: DateTime.now(),
                ).status,
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Process Refund'),
          ),
        ],
      ),
    );
  }
}
