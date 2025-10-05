import 'package:flutter/material.dart';
import '../models/property.dart';
import '../widgets/property_card.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({
    super.key,
    required this.searchQuery,
    this.location,
    this.checkIn,
    this.checkOut,
    this.guests,
  });

  final String searchQuery;
  final String? location;
  final String? checkIn;
  final String? checkOut;
  final int? guests;

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  // Helper method to generate reviews for properties
  List<Review> _generateReviews(String hostName, String location, String propertyType) {
    final List<Map<String, dynamic>> reviewData = [
      {
        'guestName': 'Alex',
        'rating': 4.8,
        'comment': 'Great stay! The property was exactly as described. Clean, comfortable, and in a perfect location. $hostName was an excellent host.',
        'date': '1 week ago',
        'guestTenure': '6 months on Airbnb',
        'avatar': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
      },
      {
        'guestName': 'Maria',
        'rating': 5.0,
        'comment': 'Absolutely amazing $propertyType in $location! Everything was perfect - from check-in to check-out. Highly recommended!',
        'date': '2 weeks ago',
        'guestTenure': '1 year on Airbnb',
        'avatar': 'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
      },
      {
        'guestName': 'John',
        'rating': 4.6,
        'comment': 'Nice $propertyType with good amenities. The location was convenient and $hostName was very responsive to our needs.',
        'date': '1 month ago',
        'guestTenure': '2 years on Airbnb',
        'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
      },
    ];

    return reviewData.map((data) => Review(
      guestName: data['guestName'],
      rating: data['rating'],
      comment: data['comment'],
      date: data['date'],
      guestTenure: data['guestTenure'],
      guestAvatar: data['avatar'],
    )).toList();
  }

  List<Property> get allProperties => <Property>[
    Property(
      title: 'Cozy Studio Apartment 4 @ Hole in the Wall Cafe',
      location: 'Bengaluru, India',
      distance: '541 kilometres away',
      dates: '14-19 Jun',
      price: 6504,
      priceText: '₹6,504 for 2 nights',
      rating: 4.92,
      imageEmoji: '🏠',
      category: 'All',
      host: 'Sarah',
      isGuestFavourite: true,
      imageCount: 5,
      imageUrl: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      totalReviews: 128,
      reviews: const <Review>[
        Review(
          guestName: 'Priya',
          rating: 5.0,
          comment: 'Perfect location and amazing host! The apartment was clean, comfortable, and had everything we needed.',
          date: '2 weeks ago',
          guestTenure: '3 months on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
        Review(
          guestName: 'Rahul',
          rating: 4.8,
          comment: 'Great stay! The apartment is exactly as described. Very clean and well-maintained.',
          date: '1 month ago',
          guestTenure: '1 year on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
        Review(
          guestName: 'Ananya',
          rating: 5.0,
          comment: 'Absolutely loved our stay! The apartment is beautiful and the host is fantastic.',
          date: '2 months ago',
          guestTenure: '6 months on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
      ],
    ),
    Property(
      title: 'Modern Beach House with Ocean View',
      location: 'Malibu, California',
      distance: '2,847 kilometres away',
      dates: '20-25 Jun',
      price: 250,
      priceText: '\$250 night',
      rating: 4.9,
      imageEmoji: '🏖️',
      category: 'Beach',
      host: 'Emma',
      isGuestFavourite: false,
      imageCount: 4,
      imageUrl: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      totalReviews: 89,
      reviews: const <Review>[
        Review(
          guestName: 'Alex',
          rating: 4.8,
          comment: 'Great stay! The property was exactly as described. Clean, comfortable, and in a perfect location. Emma was an excellent host.',
          date: '1 week ago',
          guestTenure: '6 months on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
        Review(
          guestName: 'Maria',
          rating: 5.0,
          comment: 'Absolutely amazing beach house in Malibu! Everything was perfect - from check-in to check-out. Highly recommended!',
          date: '2 weeks ago',
          guestTenure: '1 year on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
      ],
    ),
    Property(
      title: 'Luxury Mountain Cabin Retreat',
      location: 'Aspen, Colorado',
      distance: '1,234 kilometres away',
      dates: '26-30 Jun',
      price: 180,
      priceText: '\$180 night',
      rating: 4.8,
      imageEmoji: '🏔️',
      category: 'Mountain',
      host: 'Mike',
      isGuestFavourite: false,
      imageCount: 3,
      imageUrl: 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      totalReviews: 67,
      reviews: const <Review>[
        Review(
          guestName: 'John',
          rating: 4.6,
          comment: 'Nice cabin with good amenities. The location was convenient and Mike was very responsive to our needs.',
          date: '1 month ago',
          guestTenure: '2 years on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
        Review(
          guestName: 'Sarah',
          rating: 4.8,
          comment: 'Amazing mountain cabin! Mike was a wonderful host and the location was perfect for skiing.',
          date: '2 weeks ago',
          guestTenure: '1 year on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
      ],
    ),
    Property(
      title: 'Downtown Loft with City Views',
      location: 'New York, NY',
      distance: '3,456 kilometres away',
      dates: '1-5 Jul',
      price: 320,
      priceText: '\$320 night',
      rating: 4.7,
      imageEmoji: '🏙️',
      category: 'City',
      host: 'David',
      isGuestFavourite: false,
      imageCount: 4,
      imageUrl: 'https://images.unsplash.com/photo-1484154218962-a197022b5858?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      totalReviews: 156,
      reviews: const <Review>[
        Review(
          guestName: 'Tom',
          rating: 4.7,
          comment: 'Great loft in New York! David was an excellent host and the city views were incredible.',
          date: '1 week ago',
          guestTenure: '6 months on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
        Review(
          guestName: 'Lisa',
          rating: 5.0,
          comment: 'Perfect downtown loft! David was very accommodating and the location was unbeatable.',
          date: '2 weeks ago',
          guestTenure: '1 year on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
      ],
    ),
    Property(
      title: 'Rustic Farmhouse in Tuscany',
      location: 'Tuscany, Italy',
      distance: '5,678 kilometres away',
      dates: '6-10 Jul',
      price: 150,
      priceText: '\$150 night',
      rating: 4.9,
      imageEmoji: '🏡',
      category: 'Countryside',
      host: 'Giuseppe',
      isGuestFavourite: true,
      imageCount: 5,
      imageUrl: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      totalReviews: 203,
      reviews: const <Review>[
        Review(
          guestName: 'Sophie',
          rating: 4.9,
          comment: 'Perfect Tuscan experience! The farmhouse was beautiful and Giuseppe was a wonderful host. Highly recommend!',
          date: '1 week ago',
          guestTenure: '8 months on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
        Review(
          guestName: 'Luca',
          rating: 5.0,
          comment: 'Amazing farmhouse in Tuscany! The views were incredible and Giuseppe made our stay unforgettable.',
          date: '2 weeks ago',
          guestTenure: '1 year on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
      ],
    ),
    Property(
      title: 'Lakefront Villa with Private Dock',
      location: 'Lake Tahoe, CA',
      distance: '2,345 kilometres away',
      dates: '11-15 Jul',
      price: 400,
      priceText: '\$400 night',
      rating: 4.8,
      imageEmoji: '🏞️',
      category: 'Lakefront',
      host: 'Maria',
      isGuestFavourite: true,
      imageCount: 6,
      imageUrl: 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      totalReviews: 142,
      reviews: const <Review>[
        Review(
          guestName: 'James',
          rating: 4.8,
          comment: 'Stunning lakefront villa! The private dock was perfect and Maria was an excellent host.',
          date: '1 week ago',
          guestTenure: '6 months on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
        Review(
          guestName: 'Sarah',
          rating: 5.0,
          comment: 'Perfect villa for a Lake Tahoe getaway! The views were breathtaking and everything was spotless.',
          date: '2 weeks ago',
          guestTenure: '1 year on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
      ],
    ),
    Property(
      title: 'Desert Oasis with Private Pool',
      location: 'Sedona, Arizona',
      distance: '1,890 kilometres away',
      dates: '16-20 Jul',
      price: 220,
      priceText: '\$220 night',
      rating: 4.6,
      imageEmoji: '🏜️',
      category: 'Desert',
      host: 'Carlos',
      isGuestFavourite: false,
      imageCount: 4,
      imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      totalReviews: 89,
      reviews: const <Review>[
        Review(
          guestName: 'Michael',
          rating: 4.9,
          comment: 'Amazing desert oasis! Carlos was a fantastic host and the property exceeded all expectations.',
          date: '1 week ago',
          guestTenure: '8 months on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
        Review(
          guestName: 'Lisa',
          rating: 5.0,
          comment: 'Incredible experience in Sedona! The oasis was beautiful and Carlos was very accommodating.',
          date: '2 weeks ago',
          guestTenure: '1 year on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
      ],
    ),
    Property(
      title: 'Tropical Paradise Beach House',
      location: 'Maui, Hawaii',
      distance: '4,567 kilometres away',
      dates: '21-25 Jul',
      price: 350,
      priceText: '\$350 night',
      rating: 4.9,
      imageEmoji: '🌺',
      category: 'Tropical',
      host: 'Keoni',
      isGuestFavourite: true,
      imageCount: 5,
      imageUrl: 'https://images.unsplash.com/photo-1573843981267-be1999ff37cd?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      totalReviews: 178,
      reviews: const <Review>[
        Review(
          guestName: 'David',
          rating: 4.8,
          comment: 'Perfect beach house in Maui! Keoni was an amazing host and the location was unbeatable.',
          date: '1 week ago',
          guestTenure: '6 months on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
        Review(
          guestName: 'Jennifer',
          rating: 5.0,
          comment: 'Dream vacation in Maui! The beach house was perfect and Keoni made our stay unforgettable.',
          date: '2 weeks ago',
          guestTenure: '1 year on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
      ],
    ),
  ];

  String selectedSortOption = 'Recommended';
  final List<String> sortOptions = <String>[
    'Recommended',
    'Price (low to high)',
    'Price (high to low)',
    'Distance',
    'Rating',
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Size screenSize = MediaQuery.of(context).size;
    final bool isMobile = screenSize.width < 768;

    final List<Property> filteredProperties = _getFilteredProperties();

    return Scaffold(
      body: Column(
        children: <Widget>[
          // Header
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 24,
              vertical: isMobile ? 12 : 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: scheme.outlineVariant.withOpacity(0.3))),
            ),
            child: Row(
              children: <Widget>[
                // Back Button
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                ),
                const SizedBox(width: 16),
                
                // Logo
                Row(
                  children: <Widget>[
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE31C5F),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'airbnb',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE31C5F),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                
                // Search Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.location ?? 'Anywhere',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      if (widget.checkIn != null && widget.checkOut != null)
                        Text(
                          '${widget.checkIn} - ${widget.checkOut}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      if (widget.guests != null)
                        Text(
                          '${widget.guests} guest${widget.guests! > 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Sort Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: selectedSortOption,
                    underline: const SizedBox(),
                    items: sortOptions.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSortOption = newValue ?? 'Recommended';
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Results Count
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 24,
              vertical: 16,
            ),
            child: Row(
              children: <Widget>[
                Text(
                  '${filteredProperties.length} places to stay',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.tune, color: Colors.black87),
                ),
              ],
            ),
          ),
          
          // Results Grid
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double maxW = constraints.maxWidth;
                  int columns = 4;
                  if (maxW < 600) columns = 1;
                  else if (maxW < 900) columns = 2;
                  else if (maxW < 1200) columns = 3;
                  else if (maxW < 1600) columns = 4;
                  else if (maxW < 2000) columns = 5;
                  else columns = 6;

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisSpacing: isMobile ? 16 : 24,
                      crossAxisSpacing: isMobile ? 16 : 24,
                      childAspectRatio: isMobile ? 0.8 : 0.75,
                    ),
                    itemCount: filteredProperties.length,
                    itemBuilder: (context, index) {
                      final Property property = filteredProperties[index];
                      return PropertyCard(property: property);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Property> _getFilteredProperties() {
    List<Property> results = List.from(allProperties);

    // Filter by search query
    if (widget.searchQuery.isNotEmpty) {
      results = results.where((property) {
        return property.title.toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
               property.location.toLowerCase().contains(widget.searchQuery.toLowerCase());
      }).toList();
    }

    // Filter by location
    if (widget.location != null && widget.location!.isNotEmpty && widget.location != 'Anywhere') {
      results = results.where((property) {
        return property.location.toLowerCase().contains(widget.location!.toLowerCase());
      }).toList();
    }

    // Sort results
    switch (selectedSortOption) {
      case 'Price (low to high)':
        results.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price (high to low)':
        results.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Rating':
        results.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Distance':
        results.sort((a, b) => a.distance.compareTo(b.distance));
        break;
      default:
        // Recommended - keep original order
        break;
    }

    return results;
  }
}
