class Booking {
  const Booking({
    required this.id,
    required this.userId,
    required this.propertyId,
    required this.propertyTitle,
    required this.hostId,
    required this.hostName,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guests,
    required this.totalAmount,
    required this.status,
    required this.bookingDate,
    required this.paymentMethod,
    required this.isRefundable,
    this.notes,
  });

  final String id;
  final String userId;
  final String propertyId;
  final String propertyTitle;
  final String hostId;
  final String hostName;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int guests;
  final double totalAmount;
  final BookingStatus status;
  final DateTime bookingDate;
  final String paymentMethod;
  final bool isRefundable;
  final String? notes;

  int get nights => checkOutDate.difference(checkInDate).inDays;
}

enum BookingStatus {
  pending,
  confirmed,
  checkedIn,
  checkedOut,
  cancelled,
  refunded,
}

extension BookingStatusExtension on BookingStatus {
  String get displayName {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.checkedIn:
        return 'Checked In';
      case BookingStatus.checkedOut:
        return 'Checked Out';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.refunded:
        return 'Refunded';
    }
  }

  String get color {
    switch (this) {
      case BookingStatus.pending:
        return 'orange';
      case BookingStatus.confirmed:
        return 'blue';
      case BookingStatus.checkedIn:
        return 'green';
      case BookingStatus.checkedOut:
        return 'purple';
      case BookingStatus.cancelled:
        return 'red';
      case BookingStatus.refunded:
        return 'gray';
    }
  }
}

class BookingStats {
  const BookingStats({
    required this.totalBookings,
    required this.pendingBookings,
    required this.confirmedBookings,
    required this.cancelledBookings,
    required this.totalRevenue,
    required this.averageBookingValue,
    required this.occupancyRate,
  });

  final int totalBookings;
  final int pendingBookings;
  final int confirmedBookings;
  final int cancelledBookings;
  final double totalRevenue;
  final double averageBookingValue;
  final double occupancyRate;
}
