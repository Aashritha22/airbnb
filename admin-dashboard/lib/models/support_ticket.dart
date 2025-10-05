import 'package:equatable/equatable.dart';

enum TicketStatus {
  open,
  inProgress,
  resolved,
  closed,
}

enum TicketPriority {
  low,
  medium,
  high,
  urgent,
}

enum TicketCategory {
  technical,
  billing,
  account,
  booking,
  property,
  general,
}

class SupportTicket extends Equatable {
  const SupportTicket({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.subject,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.createdDate,
    this.assignedTo,
    this.resolvedDate,
    this.resolution,
    this.attachments,
  });

  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String subject;
  final String description;
  final TicketCategory category;
  final TicketPriority priority;
  final TicketStatus status;
  final DateTime createdDate;
  final String? assignedTo;
  final DateTime? resolvedDate;
  final String? resolution;
  final List<String>? attachments;

  SupportTicket copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userEmail,
    String? subject,
    String? description,
    TicketCategory? category,
    TicketPriority? priority,
    TicketStatus? status,
    DateTime? createdDate,
    String? assignedTo,
    DateTime? resolvedDate,
    String? resolution,
    List<String>? attachments,
  }) {
    return SupportTicket(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdDate: createdDate ?? this.createdDate,
      assignedTo: assignedTo ?? this.assignedTo,
      resolvedDate: resolvedDate ?? this.resolvedDate,
      resolution: resolution ?? this.resolution,
      attachments: attachments ?? this.attachments,
    );
  }

  String get statusText {
    switch (status) {
      case TicketStatus.open:
        return 'Open';
      case TicketStatus.inProgress:
        return 'In Progress';
      case TicketStatus.resolved:
        return 'Resolved';
      case TicketStatus.closed:
        return 'Closed';
    }
  }

  String get priorityText {
    switch (priority) {
      case TicketPriority.low:
        return 'Low';
      case TicketPriority.medium:
        return 'Medium';
      case TicketPriority.high:
        return 'High';
      case TicketPriority.urgent:
        return 'Urgent';
    }
  }

  String get categoryText {
    switch (category) {
      case TicketCategory.technical:
        return 'Technical';
      case TicketCategory.billing:
        return 'Billing';
      case TicketCategory.account:
        return 'Account';
      case TicketCategory.booking:
        return 'Booking';
      case TicketCategory.property:
        return 'Property';
      case TicketCategory.general:
        return 'General';
    }
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        userEmail,
        subject,
        description,
        category,
        priority,
        status,
        createdDate,
        assignedTo,
        resolvedDate,
        resolution,
        attachments,
      ];

  // Sample data
  static List<SupportTicket> sampleTickets = [
    SupportTicket(
      id: 'TKT001',
      userId: 'U001',
      userName: 'John Doe',
      userEmail: 'john.doe@email.com',
      subject: 'Unable to complete booking',
      description: 'I am trying to book a property but the payment keeps failing. I have tried multiple cards but none seem to work.',
      category: TicketCategory.technical,
      priority: TicketPriority.high,
      status: TicketStatus.open,
      createdDate: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    SupportTicket(
      id: 'TKT002',
      userId: 'U002',
      userName: 'Jane Smith',
      userEmail: 'jane.smith@email.com',
      subject: 'Refund request for cancelled booking',
      description: 'I had to cancel my booking due to an emergency. Can you please process a refund for booking ID B002?',
      category: TicketCategory.billing,
      priority: TicketPriority.medium,
      status: TicketStatus.inProgress,
      createdDate: DateTime.now().subtract(const Duration(days: 1)),
      assignedTo: 'Support Agent 1',
    ),
    SupportTicket(
      id: 'TKT003',
      userId: 'U003',
      userName: 'Mike Johnson',
      userEmail: 'mike.johnson@email.com',
      subject: 'Account verification issue',
      description: 'I uploaded my ID for verification but it has been pending for over a week. Can you please check and approve?',
      category: TicketCategory.account,
      priority: TicketPriority.medium,
      status: TicketStatus.resolved,
      createdDate: DateTime.now().subtract(const Duration(days: 3)),
      assignedTo: 'Support Agent 2',
      resolvedDate: DateTime.now().subtract(const Duration(hours: 5)),
      resolution: 'Account verification completed. User has been notified.',
    ),
    SupportTicket(
      id: 'TKT004',
      userId: 'U004',
      userName: 'Sarah Wilson',
      userEmail: 'sarah.wilson@email.com',
      subject: 'Property listing not showing',
      description: 'I listed my property yesterday but it is not appearing in search results. Please help.',
      category: TicketCategory.property,
      priority: TicketPriority.high,
      status: TicketStatus.open,
      createdDate: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    SupportTicket(
      id: 'TKT005',
      userId: 'U005',
      userName: 'David Brown',
      userEmail: 'david.brown@email.com',
      subject: 'General inquiry about platform',
      description: 'I am new to the platform and would like to know more about how the booking process works.',
      category: TicketCategory.general,
      priority: TicketPriority.low,
      status: TicketStatus.closed,
      createdDate: DateTime.now().subtract(const Duration(days: 5)),
      assignedTo: 'Support Agent 1',
      resolvedDate: DateTime.now().subtract(const Duration(days: 2)),
      resolution: 'Provided comprehensive guide and documentation links.',
    ),
  ];
}

class SupportStats {
  const SupportStats({
    required this.totalTickets,
    required this.openTickets,
    required this.inProgressTickets,
    required this.resolvedTickets,
    required this.closedTickets,
    required this.averageResolutionTime,
    required this.urgentTickets,
  });

  final int totalTickets;
  final int openTickets;
  final int inProgressTickets;
  final int resolvedTickets;
  final int closedTickets;
  final double averageResolutionTime;
  final int urgentTickets;

  static SupportStats calculateStats(List<SupportTicket> tickets) {
    final totalTickets = tickets.length;
    final openTickets = tickets.where((t) => t.status == TicketStatus.open).length;
    final inProgressTickets = tickets.where((t) => t.status == TicketStatus.inProgress).length;
    final resolvedTickets = tickets.where((t) => t.status == TicketStatus.resolved).length;
    final closedTickets = tickets.where((t) => t.status == TicketStatus.closed).length;
    final urgentTickets = tickets.where((t) => t.priority == TicketPriority.urgent).length;

    final resolvedTicketsWithTime = tickets.where((t) => t.resolvedDate != null).toList();
    final averageResolutionTime = resolvedTicketsWithTime.isEmpty
        ? 0.0
        : resolvedTicketsWithTime
                .map((t) => t.resolvedDate!.difference(t.createdDate).inHours)
                .reduce((a, b) => a + b) /
            resolvedTicketsWithTime.length;

    return SupportStats(
      totalTickets: totalTickets,
      openTickets: openTickets,
      inProgressTickets: inProgressTickets,
      resolvedTickets: resolvedTickets,
      closedTickets: closedTickets,
      averageResolutionTime: averageResolutionTime,
      urgentTickets: urgentTickets,
    );
  }
}
