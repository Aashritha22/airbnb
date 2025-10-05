class Review {
  const Review({
    required this.guestName,
    required this.rating,
    required this.comment,
    required this.date,
    required this.guestTenure,
    this.guestAvatar,
  });

  final String guestName;
  final double rating;
  final String comment;
  final String date;
  final String guestTenure;
  final String? guestAvatar;
}

class Property {
  const Property({
    required this.title,
    required this.location,
    required this.distance,
    required this.dates,
    required this.price,
    required this.priceText,
    required this.rating,
    required this.imageEmoji,
    required this.category,
    required this.host,
    required this.isGuestFavourite,
    required this.imageCount,
    required this.reviews,
    required this.totalReviews,
    this.imageUrl,
  });

  final String title;
  final String location;
  final String distance;
  final String dates;
  final double price;
  final String priceText;
  final double rating;
  final String imageEmoji;
  final String category;
  final String host;
  final bool isGuestFavourite;
  final int imageCount;
  final List<Review> reviews;
  final int totalReviews;
  final String? imageUrl;
}
