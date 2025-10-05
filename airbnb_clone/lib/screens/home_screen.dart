import 'package:flutter/material.dart';
import '../models/property.dart';
import '../models/category_icon.dart';
import '../models/filter.dart';
import '../widgets/search_segment.dart';
import '../widgets/nav_tab.dart';
import '../widgets/category_button.dart';
import '../widgets/property_card.dart';
import '../widgets/filter_dialog.dart';
import 'profile_screen.dart';
import 'search_results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final List<CategoryIcon> categories = <CategoryIcon>[
    CategoryIcon(emoji: '🏠', label: 'All'),
    CategoryIcon(emoji: '🏖️', label: 'Beach'),
    CategoryIcon(emoji: '🏔️', label: 'Mountain'),
    CategoryIcon(emoji: '🏙️', label: 'City'),
    CategoryIcon(emoji: '🏡', label: 'Countryside'),
    CategoryIcon(emoji: '🏞️', label: 'Lakefront'),
    CategoryIcon(emoji: '🏜️', label: 'Desert'),
    CategoryIcon(emoji: '🌺', label: 'Tropical'),
    CategoryIcon(emoji: '🏢', label: 'Flats'),
    CategoryIcon(emoji: '🏝️', label: 'Resort'),
    CategoryIcon(emoji: '⛷️', label: 'Alpine'),
    CategoryIcon(emoji: '🏰', label: 'Castle'),
  ];

  List<Property> get properties => <Property>[
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
          comment: 'Perfect location and amazing host! The apartment was clean, comfortable, and had everything we needed. Sarah was very responsive and helpful.',
          date: '2 weeks ago',
          guestTenure: '3 months on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
        Review(
          guestName: 'Rahul',
          rating: 4.8,
          comment: 'Great stay! The apartment is exactly as described. Very clean and well-maintained. The location is perfect for exploring Bengaluru.',
          date: '1 month ago',
          guestTenure: '1 year on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
        Review(
          guestName: 'Ananya',
          rating: 5.0,
          comment: 'Absolutely loved our stay! The apartment is beautiful and the host is fantastic. Would definitely recommend to anyone visiting Bengaluru.',
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
          guestName: 'Michael',
          rating: 5.0,
          comment: 'Stunning ocean views and a beautifully designed beach house. Emma was an incredible host who made our stay unforgettable.',
          date: '1 week ago',
          guestTenure: '2 years on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
        Review(
          guestName: 'Jessica',
          rating: 4.9,
          comment: 'Perfect beach getaway! The house is modern, clean, and has everything you need. The location is amazing with direct beach access.',
          date: '3 weeks ago',
          guestTenure: '1 year on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
        Review(
          guestName: 'David',
          rating: 4.8,
          comment: 'Amazing property with breathtaking views. The house is well-equipped and Emma provided excellent recommendations for local activities.',
          date: '1 month ago',
          guestTenure: '6 months on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
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
          guestName: 'Sophie',
          rating: 5.0,
          comment: 'Absolutely magical mountain retreat! The cabin is cozy, well-appointed, and the views are spectacular. Mike was a wonderful host.',
          date: '2 weeks ago',
          guestTenure: '1 year on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
        Review(
          guestName: 'James',
          rating: 4.7,
          comment: 'Perfect for a peaceful mountain getaway. The cabin has all the amenities you need and the location is ideal for hiking and skiing.',
          date: '1 month ago',
          guestTenure: '8 months on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
        Review(
          guestName: 'Lisa',
          rating: 4.9,
          comment: 'Beautiful cabin with amazing mountain views. Very clean and comfortable. Mike provided great local recommendations.',
          date: '2 months ago',
          guestTenure: '3 years on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
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
          guestName: 'Alex',
          rating: 4.8,
          comment: 'Great stay! The property was exactly as described. Clean, comfortable, and in a perfect location. David was an excellent host.',
          date: '1 week ago',
          guestTenure: '6 months on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
        Review(
          guestName: 'Maria',
          rating: 5.0,
          comment: 'Absolutely amazing loft in New York! Everything was perfect - from check-in to check-out. Highly recommended!',
          date: '2 weeks ago',
          guestTenure: '1 year on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
        Review(
          guestName: 'John',
          rating: 4.6,
          comment: 'Nice loft with good amenities. The location was convenient and David was very responsive to our needs.',
          date: '1 month ago',
          guestTenure: '2 years on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
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
        Review(
          guestName: 'Emma',
          rating: 4.7,
          comment: 'Beautiful farmhouse with authentic Tuscan charm. Giuseppe was very helpful and the location was perfect.',
          date: '1 month ago',
          guestTenure: '2 years on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
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
    
    // Mountain Properties
    Property(
      title: 'Alpine Ski Lodge with Fireplace',
      location: 'Whistler, Canada',
      distance: '3,200 kilometres away',
      dates: '26-30 Jul',
      price: 280,
      priceText: '\$280 night',
      rating: 4.8,
      imageEmoji: '🏔️',
      category: 'Mountain',
      host: 'Alex',
      isGuestFavourite: true,
      imageCount: 5,
      imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      totalReviews: 95,
      reviews: const <Review>[
        Review(
          guestName: 'Tom',
          rating: 4.7,
          comment: 'Great ski lodge in Whistler! Alex was a wonderful host and the location was perfect for skiing.',
          date: '1 week ago',
          guestTenure: '8 months on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
        Review(
          guestName: 'Rachel',
          rating: 5.0,
          comment: 'Amazing ski lodge! Alex was very helpful and the property was exactly as described.',
          date: '2 weeks ago',
          guestTenure: '1 year on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
      ],
    ),
    Property(
      title: 'Cozy Mountain Cabin with Hot Tub',
      location: 'Banff, Alberta',
      distance: '2,800 kilometres away',
      dates: '1-5 Aug',
      price: 220,
      priceText: '\$220 night',
      rating: 4.9,
      imageEmoji: '🏕️',
      category: 'Mountain',
      host: 'Sarah',
      isGuestFavourite: false,
      imageCount: 4,
      imageUrl: 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      totalReviews: 134,
      reviews: const <Review>[
        Review(
          guestName: 'Mark',
          rating: 4.9,
          comment: 'Perfect mountain cabin! Sarah was an excellent host and the location was breathtaking.',
          date: '1 week ago',
          guestTenure: '6 months on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
        Review(
          guestName: 'Amanda',
          rating: 5.0,
          comment: 'Incredible cabin in Banff! Sarah made our stay perfect and the views were amazing.',
          date: '2 weeks ago',
          guestTenure: '1 year on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
      ],
    ),
    Property(
      title: 'Rocky Mountain Retreat',
      location: 'Denver, Colorado',
      distance: '1,500 kilometres away',
      dates: '6-10 Aug',
      price: 190,
      priceText: '\$190 night',
      rating: 4.7,
      imageEmoji: '⛰️',
      category: 'Mountain',
      host: 'Jake',
      isGuestFavourite: false,
      imageCount: 3,
      imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      totalReviews: 78,
      reviews: const <Review>[
        Review(
          guestName: 'Chris',
          rating: 4.8,
          comment: 'Great mountain retreat! Jake was a fantastic host and the property was perfect for relaxation.',
          date: '1 week ago',
          guestTenure: '6 months on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
        Review(
          guestName: 'Jessica',
          rating: 5.0,
          comment: 'Amazing retreat in Denver! Jake was very accommodating and the location was perfect.',
          date: '2 weeks ago',
          guestTenure: '1 year on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
      ],
    ),
    
    // Resort Properties
    Property(
      title: 'Luxury Beach Resort Villa',
      location: 'Cancun, Mexico',
      distance: '2,100 kilometres away',
      dates: '11-15 Aug',
      price: 450,
      priceText: '\$450 night',
      rating: 4.9,
      imageEmoji: '🏖️',
      category: 'Resort',
      host: 'Carlos',
      isGuestFavourite: true,
      imageCount: 6,
      imageUrl: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      totalReviews: 167,
      reviews: const <Review>[
        Review(
          guestName: 'Robert',
          rating: 4.9,
          comment: 'Perfect resort villa in Cancun! Carlos was an excellent host and the property was amazing.',
          date: '1 week ago',
          guestTenure: '8 months on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
        Review(
          guestName: 'Michelle',
          rating: 5.0,
          comment: 'Incredible villa in Cancun! Carlos made our vacation perfect and the location was unbeatable.',
          date: '2 weeks ago',
          guestTenure: '1 year on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
      ],
    ),
    Property(
      title: 'All-Inclusive Spa Resort',
      location: 'Bali, Indonesia',
      distance: '8,900 kilometres away',
      dates: '16-20 Aug',
      price: 380,
      priceText: '\$380 night',
      rating: 4.8,
      imageEmoji: '🏝️',
      category: 'Resort',
      host: 'Made',
      isGuestFavourite: true,
      imageCount: 7,
      imageUrl: 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      totalReviews: 245,
      reviews: const <Review>[
        Review(
          guestName: 'Kevin',
          rating: 4.8,
          comment: 'Amazing spa resort in Bali! Made was a wonderful host and the property was perfect for relaxation.',
          date: '1 week ago',
          guestTenure: '6 months on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
        Review(
          guestName: 'Nicole',
          rating: 5.0,
          comment: 'Perfect spa resort! Made was very helpful and the location was absolutely beautiful.',
          date: '2 weeks ago',
          guestTenure: '1 year on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
      ],
    ),
    Property(
      title: 'Golf Resort with Ocean Views',
      location: 'Pebble Beach, CA',
      distance: '3,500 kilometres away',
      dates: '21-25 Aug',
      price: 520,
      priceText: '\$520 night',
      rating: 4.9,
      imageEmoji: '⛳',
      category: 'Resort',
      host: 'Tom',
      isGuestFavourite: false,
      imageCount: 5,
      imageUrl: 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      totalReviews: 112,
      reviews: const <Review>[
        Review(
          guestName: 'Brian',
          rating: 4.9,
          comment: 'Excellent golf resort! Tom was a fantastic host and the property exceeded all expectations.',
          date: '1 week ago',
          guestTenure: '8 months on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
        Review(
          guestName: 'Laura',
          rating: 5.0,
          comment: 'Amazing golf resort in Pebble Beach! Tom was very accommodating and the location was perfect.',
          date: '2 weeks ago',
          guestTenure: '1 year on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
      ],
    ),
    
    // Flats/Apartments
    Property(
      title: 'Modern Studio Apartment',
      location: 'San Francisco, CA',
      distance: '4,200 kilometres away',
      dates: '26-30 Aug',
      price: 180,
      priceText: '\$180 night',
      rating: 4.6,
      imageEmoji: '🏢',
      category: 'Flats',
      host: 'Jennifer',
      isGuestFavourite: false,
      imageCount: 3,
      imageUrl: 'https://images.unsplash.com/photo-1484154218962-a197022b5858?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      totalReviews: 89,
      reviews: const <Review>[
        Review(
          guestName: 'Daniel',
          rating: 4.7,
          comment: 'Great studio apartment in San Francisco! Jennifer was a wonderful host and the location was perfect.',
          date: '1 week ago',
          guestTenure: '6 months on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
        Review(
          guestName: 'Stephanie',
          rating: 5.0,
          comment: 'Perfect studio apartment! Jennifer was very helpful and the property was exactly as described.',
          date: '2 weeks ago',
          guestTenure: '1 year on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
      ],
    ),
    Property(
      title: 'Luxury Penthouse with City Views',
      location: 'Miami, FL',
      distance: '2,800 kilometres away',
      dates: '1-5 Sep',
      price: 320,
      priceText: '\$320 night',
      rating: 4.8,
      imageEmoji: '🏙️',
      category: 'Flats',
      host: 'Roberto',
      isGuestFavourite: true,
      imageCount: 4,
      imageUrl: 'https://images.unsplash.com/photo-1484154218962-a197022b5858?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      totalReviews: 156,
      reviews: const <Review>[
        Review(
          guestName: 'Antonio',
          rating: 4.8,
          comment: 'Amazing penthouse in Miami! Roberto was an excellent host and the views were incredible.',
          date: '1 week ago',
          guestTenure: '6 months on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
        Review(
          guestName: 'Isabella',
          rating: 5.0,
          comment: 'Perfect penthouse! Roberto was very accommodating and the location was unbeatable.',
          date: '2 weeks ago',
          guestTenure: '1 year on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
      ],
    ),
    Property(
      title: 'Cozy 2-Bedroom Flat',
      location: 'Seattle, WA',
      distance: '3,100 kilometres away',
      dates: '6-10 Sep',
      price: 160,
      priceText: '\$160 night',
      rating: 4.7,
      imageEmoji: '🏠',
      category: 'Flats',
      host: 'Michelle',
      isGuestFavourite: false,
      imageCount: 3,
      imageUrl: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      totalReviews: 73,
      reviews: const <Review>[
        Review(
          guestName: 'Ryan',
          rating: 4.7,
          comment: 'Great flat in Seattle! Michelle was a wonderful host and the location was perfect for exploring.',
          date: '1 week ago',
          guestTenure: '8 months on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
        Review(
          guestName: 'Ashley',
          rating: 5.0,
          comment: 'Perfect flat! Michelle was very helpful and the property was exactly as described.',
          date: '2 weeks ago',
          guestTenure: '1 year on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
      ],
    ),
    Property(
      title: 'Art Deco Apartment in Historic Building',
      location: 'Chicago, IL',
      distance: '2,200 kilometres away',
      dates: '11-15 Sep',
      price: 140,
      priceText: '\$140 night',
      rating: 4.5,
      imageEmoji: '🏛️',
      category: 'Flats',
      host: 'Marcus',
      isGuestFavourite: false,
      imageCount: 2,
      imageUrl: 'https://images.unsplash.com/photo-1484154218962-a197022b5858?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      totalReviews: 45,
      reviews: const <Review>[
        Review(
          guestName: 'Tyler',
          rating: 4.6,
          comment: 'Nice apartment in Chicago! Marcus was a good host and the location was convenient.',
          date: '1 week ago',
          guestTenure: '6 months on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
        Review(
          guestName: 'Megan',
          rating: 4.8,
          comment: 'Great apartment! Marcus was very responsive and the property was clean and comfortable.',
          date: '2 weeks ago',
          guestTenure: '1 year on Airbnb',
          guestAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
        ),
      ],
    ),
  ];

  String selectedCategory = 'All';
  int selectedTabIndex = 0;
  FilterModel currentFilter = const FilterModel();
  
  // Search state
  String searchQuery = '';
  String selectedLocation = 'Anywhere';
  String selectedCheckIn = 'Add dates';
  String selectedCheckOut = 'Add dates';
  int selectedGuests = 1;
  
  // Scroll to top functionality
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels > 300) {
      if (!_showScrollToTop) {
        setState(() {
          _showScrollToTop = true;
        });
      }
    } else {
      if (_showScrollToTop) {
        setState(() {
          _showScrollToTop = false;
        });
      }
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isMobile = screenSize.width < 768;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.grey.shade50,
                ],
              ),
            ),
            child: Column(
              children: <Widget>[
            // Enhanced Header with Glass Morphism
            Container(
              margin: const EdgeInsets.all(16),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 24, 
                vertical: isMobile ? 16 : 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
            child: Row(
              children: <Widget>[
                // Enhanced Logo
                Row(
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE31C5F), Color(0xFFE31C5F)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE31C5F).withOpacity(0.3),
                            spreadRadius: 0,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'airbnb',
                      style: TextStyle(
                        color: Color(0xFFE31C5F),
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: isMobile ? 16 : 32),
                
                // Enhanced Segmented Search Bar
                Expanded(
                  child: Container(
                    height: isMobile ? 52 : 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      border: Border.all(color: Colors.grey.shade200, width: 1),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 0,
                          blurRadius: 15,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: SearchSegment(
                            label: 'Where',
                            hint: selectedLocation,
                            onTap: () => _showLocationDialog(),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 24,
                          color: Colors.grey.shade300,
                        ),
                        Expanded(
                          child: SearchSegment(
                            label: 'Check in',
                            hint: selectedCheckIn,
                            onTap: () => _showDateDialog('checkin'),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 24,
                          color: Colors.grey.shade300,
                        ),
                        Expanded(
                          child: SearchSegment(
                            label: 'Check out',
                            hint: selectedCheckOut,
                            onTap: () => _showDateDialog('checkout'),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 24,
                          color: Colors.grey.shade300,
                        ),
                        Expanded(
                          child: SearchSegment(
                            label: 'Who',
                            hint: selectedGuests == 1 ? 'Add guests' : '$selectedGuests guests',
                            onTap: () => _showGuestDialog(),
                          ),
                        ),
                        GestureDetector(
                          onTap: _performSearch,
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFE31C5F), Color(0xFFE31C5F)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFE31C5F).withOpacity(0.3),
                                  spreadRadius: 0,
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.search, color: Colors.white, size: 22),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(width: isMobile ? 16 : 24),
                
                // User Menu
                Row(
                  children: <Widget>[
                    if (!isMobile) ...[
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: const Text(
                          'Airbnb your home',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.language, color: Colors.black87),
                    ),
                    SizedBox(width: isMobile ? 4 : 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(Icons.menu, size: 16, color: Colors.black87),
                          const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.grey.shade200,
                          child: const Text(
                            'C',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Enhanced Navigation Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                NavTab(
                  label: 'Homes',
                  isSelected: selectedTabIndex == 0,
                  onTap: () => setState(() => selectedTabIndex = 0),
                ),
                SizedBox(width: isMobile ? 16 : 32),
                NavTab(
                  label: 'Experiences',
                  isSelected: selectedTabIndex == 1,
                  onTap: () => setState(() => selectedTabIndex = 1),
                ),
              ],
            ),
          ),
          
          // Enhanced Category Filters
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 24, 
              vertical: isMobile ? 12 : 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories.map((category) {
                        final bool isSelected = category.label == selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: CategoryButton(
                            category: category,
                            isSelected: isSelected,
                            onTap: () => setState(() => selectedCategory = category.label),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => _showFilterDialog(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: currentFilter.hasActiveFilters 
                                ? [const Color(0xFFE31C5F), const Color(0xFFE31C5F)]
                                : [Colors.grey.shade100, Colors.grey.shade200],
                          ),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: currentFilter.hasActiveFilters 
                                  ? const Color(0xFFE31C5F).withOpacity(0.3)
                                  : Colors.black.withOpacity(0.05),
                              spreadRadius: 0,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.tune, 
                              size: 18,
                              color: currentFilter.hasActiveFilters 
                                  ? Colors.white 
                                  : Colors.grey.shade600,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Filters',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: currentFilter.hasActiveFilters 
                                    ? Colors.white 
                                    : Colors.grey.shade600,
                              ),
                            ),
                            if (currentFilter.hasActiveFilters) ...[
                              const SizedBox(width: 4),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(Icons.price_check, size: 12, color: Colors.pink),
                          const SizedBox(width: 4),
                          const Text(
                            'Prices include all fees',
                            style: TextStyle(color: Colors.pink, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Main Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: selectedTabIndex == 0 ? _buildHomesContent(isMobile) : _buildExperiencesContent(isMobile),
            ),
          ),
        ],
      ),
    ),
    // Scroll to Top Button
    _buildFloatingActionButton(),
  ],
  ),
  );
  }

  Widget _buildHomesContent(bool isMobile) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxW = constraints.maxWidth;
        int columns = 4;
        if (maxW < 600) columns = 1;
        else if (maxW < 900) columns = 2;
        else if (maxW < 1200) columns = 3;
        else if (maxW < 1600) columns = 4;
        else if (maxW < 2000) columns = 5;
        else columns = 6;

        final List<Property> filteredProperties = properties.where((property) {
          // Category filter
          final bool matchesCategory = selectedCategory == 'All' || property.category == selectedCategory;
          
          // Price filter
          final bool matchesPrice = property.price >= currentFilter.priceRange.start && 
                                   property.price <= currentFilter.priceRange.end;
          
          // Property type filter (simplified - using category for now)
          final bool matchesPropertyType = currentFilter.propertyTypes.isEmpty || 
                                          currentFilter.propertyTypes.contains(property.category.toLowerCase());
          
          return matchesCategory && matchesPrice && matchesPropertyType;
        }).toList();

        return GridView.builder(
          controller: _scrollController,
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
    );
  }

  Widget _buildExperiencesContent(bool isMobile) {
    final List<Map<String, dynamic>> experiences = [
      {
        'title': 'Cooking Class with Local Chef',
        'location': 'Rome, Italy',
        'price': '\$89',
        'rating': 4.9,
        'duration': '3 hours',
        'image': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      },
      {
        'title': 'Wine Tasting in Tuscany',
        'location': 'Florence, Italy',
        'price': '\$120',
        'rating': 4.8,
        'duration': '4 hours',
        'image': 'https://images.unsplash.com/photo-1506377247377-2a5b3b417ebb?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      },
      {
        'title': 'Photography Walk in Paris',
        'location': 'Paris, France',
        'price': '\$75',
        'rating': 4.7,
        'duration': '2.5 hours',
        'image': 'https://images.unsplash.com/photo-1502602898536-47ad22581b52?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      },
      {
        'title': 'Surfing Lesson in Malibu',
        'location': 'Malibu, California',
        'price': '\$95',
        'rating': 4.6,
        'duration': '2 hours',
        'image': 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      },
      {
        'title': 'Hiking Adventure in Yosemite',
        'location': 'Yosemite, California',
        'price': '\$110',
        'rating': 4.9,
        'duration': '6 hours',
        'image': 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      },
      {
        'title': 'Street Art Tour in Berlin',
        'location': 'Berlin, Germany',
        'price': '\$65',
        'rating': 4.5,
        'duration': '3 hours',
        'image': 'https://images.unsplash.com/photo-1484154218962-a197022b5858?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxW = constraints.maxWidth;
        int columns = 3;
        if (maxW < 600) columns = 1;
        else if (maxW < 900) columns = 2;
        else if (maxW < 1200) columns = 3;
        else if (maxW < 1600) columns = 4;
        else columns = 5;

        return GridView.builder(
          controller: _scrollController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: isMobile ? 16 : 24,
            crossAxisSpacing: isMobile ? 16 : 24,
            childAspectRatio: isMobile ? 0.7 : 0.8,
          ),
          itemCount: experiences.length,
          itemBuilder: (context, index) {
            final experience = experiences[index];
            return _buildExperienceCard(experience, isMobile);
          },
        );
      },
    );
  }

  Widget _buildExperienceCard(Map<String, dynamic> experience, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to experience details
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Image
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(experience['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                
                // Content
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Title
                        Text(
                          experience['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        
                        // Location and Rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                experience['location'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Icon(Icons.star, size: 14, color: Colors.amber),
                                  const SizedBox(width: 2),
                                  Text(
                                    experience['rating'].toString(),
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        
                        // Duration
                        Text(
                          experience['duration'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const Spacer(),
                        
                        // Price
                        Text(
                          experience['price'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFE31C5F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    if (!_showScrollToTop) return const SizedBox.shrink();
    
    return Positioned(
      bottom: 24,
      right: 24,
      child: FloatingActionButton(
        onPressed: _scrollToTop,
        backgroundColor: const Color(0xFFE31C5F),
        foregroundColor: Colors.white,
        elevation: 8,
        child: const Icon(Icons.keyboard_arrow_up, size: 28),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FilterDialog(
        filter: currentFilter,
        onApply: (FilterModel newFilter) {
          setState(() {
            currentFilter = newFilter;
          });
        },
      ),
    );
  }

  void _performSearch() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SearchResultsScreen(
          searchQuery: searchQuery,
          location: selectedLocation != 'Anywhere' ? selectedLocation : null,
          checkIn: selectedCheckIn != 'Add dates' ? selectedCheckIn : null,
          checkOut: selectedCheckOut != 'Add dates' ? selectedCheckOut : null,
          guests: selectedGuests > 1 ? selectedGuests : null,
        ),
      ),
    );
  }

  void _showLocationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Where are you going?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search destinations',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
            const SizedBox(height: 16),
            const Text('Popular destinations'),
            const SizedBox(height: 8),
            ...['Bengaluru, India', 'New York, NY', 'Malibu, California', 'Aspen, Colorado']
                .map((location) => ListTile(
                      title: Text(location),
                      onTap: () {
                        setState(() => selectedLocation = location);
                        Navigator.of(context).pop();
                      },
                    ))
                .toList(),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showDateDialog(String type) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((DateTime? selectedDate) {
      if (selectedDate != null) {
        final String formattedDate = '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}';
        setState(() {
          if (type == 'checkin') {
            selectedCheckIn = formattedDate;
          } else {
            selectedCheckOut = formattedDate;
          }
        });
      }
    });
  }

  void _showGuestDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Number of guests'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Adults'),
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: selectedGuests > 1
                          ? () => setState(() => selectedGuests--)
                          : null,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text('$selectedGuests'),
                    IconButton(
                      onPressed: () => setState(() => selectedGuests++),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
