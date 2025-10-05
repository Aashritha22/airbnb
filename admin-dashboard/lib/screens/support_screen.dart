import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/support_ticket.dart';
import '../widgets/admin_card.dart';
import '../widgets/admin_table.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  List<SupportTicket> _tickets = SupportTicket.sampleTickets;
  String _searchQuery = '';
  String _selectedStatus = 'All';
  String _selectedPriority = 'All';
  String _selectedCategory = 'All';
  final SupportStats _supportStats = SupportStats.calculateStats(SupportTicket.sampleTickets);

  final List<String> _statusFilters = [
    'All',
    'Open',
    'In Progress',
    'Resolved',
    'Closed',
  ];

  final List<String> _priorityFilters = [
    'All',
    'Low',
    'Medium',
    'High',
    'Urgent',
  ];

  final List<String> _categoryFilters = [
    'All',
    'Technical',
    'Billing',
    'Account',
    'Booking',
    'Property',
    'General',
  ];

  void _updateTicketStatus(SupportTicket ticket, TicketStatus newStatus) {
    setState(() {
      final int index = _tickets.indexOf(ticket);
      if (index != -1) {
        _tickets[index] = ticket.copyWith(
          status: newStatus,
          resolvedDate: newStatus == TicketStatus.resolved || newStatus == TicketStatus.closed
              ? DateTime.now()
              : null,
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ticket status updated to ${newStatus.name}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  List<SupportTicket> get _filteredTickets {
    return _tickets.where((SupportTicket ticket) {
      final bool matchesSearch = ticket.subject.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          ticket.userName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          ticket.userEmail.toLowerCase().contains(_searchQuery.toLowerCase());
      final bool matchesStatus = _selectedStatus == 'All' || ticket.statusText == _selectedStatus;
      final bool matchesPriority = _selectedPriority == 'All' || ticket.priorityText == _selectedPriority;
      final bool matchesCategory = _selectedCategory == 'All' || ticket.categoryText == _selectedCategory;
      return matchesSearch && matchesStatus && matchesPriority && matchesCategory;
    }).toList();
  }

  Color _getStatusColor(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return Colors.red;
      case TicketStatus.inProgress:
        return Colors.orange;
      case TicketStatus.resolved:
        return Colors.blue;
      case TicketStatus.closed:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(TicketPriority priority) {
    switch (priority) {
      case TicketPriority.low:
        return Colors.green;
      case TicketPriority.medium:
        return Colors.yellow;
      case TicketPriority.high:
        return Colors.orange;
      case TicketPriority.urgent:
        return Colors.red;
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
                'Support Tickets',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  // Handle new ticket
                },
                icon: const Icon(Icons.add),
                label: const Text('New Ticket'),
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
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.8,
            children: [
              AdminCard(
                title: 'Total Tickets',
                value: _supportStats.totalTickets.toString(),
                icon: Icons.support_agent,
                color: Colors.blue,
                subtitle: '${_supportStats.urgentTickets} urgent tickets',
              ),
              AdminCard(
                title: 'Open Tickets',
                value: _supportStats.openTickets.toString(),
                icon: Icons.assignment,
                color: Colors.red,
                subtitle: 'Require attention',
              ),
              AdminCard(
                title: 'In Progress',
                value: _supportStats.inProgressTickets.toString(),
                icon: Icons.work,
                color: Colors.orange,
                subtitle: 'Being worked on',
              ),
              AdminCard(
                title: 'Avg Resolution',
                value: '${_supportStats.averageResolutionTime.toStringAsFixed(1)}h',
                icon: Icons.timer,
                color: Colors.green,
                subtitle: 'Response time',
              ),
            ],
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
                      hintText: 'Search by subject, user name, or email...',
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
                            // Priority Filter
                            DropdownButton<String>(
                              value: _selectedPriority,
                              items: _priorityFilters
                                  .map((String priority) => DropdownMenuItem<String>(
                                        value: priority,
                                        child: Text(priority),
                                      ))
                                  .toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedPriority = newValue!;
                                });
                              },
                            ),
                            const SizedBox(width: 16),
                            // Category Filter
                            DropdownButton<String>(
                              value: _selectedCategory,
                              items: _categoryFilters
                                  .map((String category) => DropdownMenuItem<String>(
                                        value: category,
                                        child: Text(category),
                                      ))
                                  .toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedCategory = newValue!;
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
          
          // Tickets Table
          AdminTable(
            headers: const [
              'Ticket ID',
              'Subject',
              'User',
              'Category',
              'Priority',
              'Status',
              'Created',
              'Actions'
            ],
            rows: _filteredTickets.map((SupportTicket ticket) {
              return [
                Text(
                  ticket.id,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Text(
                    ticket.subject,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.userName,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      ticket.userEmail,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Text(ticket.categoryText),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(ticket.priority).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    ticket.priorityText,
                    style: TextStyle(
                      color: _getPriorityColor(ticket.priority),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(ticket.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    ticket.statusText,
                    style: TextStyle(
                      color: _getStatusColor(ticket.status),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(DateFormat('MMM dd, yyyy').format(ticket.createdDate)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: () {
                        _showTicketDetails(ticket);
                      },
                    ),
                    if (ticket.status == TicketStatus.open) ...[
                      IconButton(
                        icon: const Icon(Icons.play_arrow, color: Colors.orange),
                        onPressed: () {
                          _updateTicketStatus(ticket, TicketStatus.inProgress);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          _updateTicketStatus(ticket, TicketStatus.resolved);
                        },
                      ),
                    ],
                    if (ticket.status == TicketStatus.inProgress)
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          _updateTicketStatus(ticket, TicketStatus.resolved);
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

  void _showTicketDetails(SupportTicket ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ticket Details - ${ticket.id}'),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Subject', ticket.subject),
              _buildDetailRow('User', '${ticket.userName} (${ticket.userEmail})'),
              _buildDetailRow('Category', ticket.categoryText),
              _buildDetailRow('Priority', ticket.priorityText),
              _buildDetailRow('Status', ticket.statusText),
              _buildDetailRow('Created', DateFormat('MMM dd, yyyy HH:mm').format(ticket.createdDate)),
              if (ticket.assignedTo != null)
                _buildDetailRow('Assigned To', ticket.assignedTo!),
              if (ticket.resolvedDate != null)
                _buildDetailRow('Resolved', DateFormat('MMM dd, yyyy HH:mm').format(ticket.resolvedDate!)),
              const SizedBox(height: 16),
              const Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(ticket.description),
              ),
              if (ticket.resolution != null) ...[
                const SizedBox(height: 16),
                const Text(
                  'Resolution:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Text(ticket.resolution!),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (ticket.status != TicketStatus.closed)
            ElevatedButton(
              onPressed: () {
                _showReplyDialog(ticket);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE31C5F),
                foregroundColor: Colors.white,
              ),
              child: const Text('Reply'),
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

  void _showReplyDialog(SupportTicket ticket) {
    final TextEditingController replyController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reply to Ticket ${ticket.id}'),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: replyController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Enter your reply...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (replyController.text.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reply sent successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE31C5F),
              foregroundColor: Colors.white,
            ),
            child: const Text('Send Reply'),
          ),
        ],
      ),
    );
  }
}
