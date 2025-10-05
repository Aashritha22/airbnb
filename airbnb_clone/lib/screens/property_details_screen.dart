import 'dart:async';
import 'package:flutter/material.dart';
import '../models/property.dart';
import '../widgets/search_segment.dart';
import 'profile_screen.dart';

class PropertyDetailsScreen extends StatefulWidget {
  const PropertyDetailsScreen({
    super.key,
    required this.property,
  });

  final Property property;

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  int selectedImageIndex = 0;
  DateTime? checkInDate;
  DateTime? checkOutDate;
  int guestCount = 1;
  int selectedTabIndex = 0;
  
  // User comments and reviews
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, dynamic>> _userComments = <Map<String, dynamic>>[];
  double _userRating = 5.0;
  
  // Auto scroll functionality
  Timer? _autoScrollTimer;
  bool _isAutoScrolling = true;
  final PageController _pageController = PageController();

  final List<String> propertyImages = [
    'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', // Main studio image
    'https://images.unsplash.com/photo-1571896349842-33c89424de2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', // Beach house
    'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', // Mountain cabin
    'https://images.unsplash.com/photo-1484154218962-a197022b5858?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', // City loft
    'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', // Farmhouse
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_isAutoScrolling && mounted) {
        setState(() {
          selectedImageIndex = (selectedImageIndex + 1) % propertyImages.length;
        });
        _pageController.animateToPage(
          selectedImageIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopAutoScroll() {
    setState(() {
      _isAutoScrolling = false;
    });
    _autoScrollTimer?.cancel();
  }

  void _resumeAutoScroll() {
    setState(() {
      _isAutoScrolling = true;
    });
    _startAutoScroll();
  }

  void _onImagePageChanged(int index) {
    setState(() {
      selectedImageIndex = index;
    });
    // Pause auto scroll when user manually changes image
    _stopAutoScroll();
    // Resume auto scroll after 5 seconds of inactivity
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        _resumeAutoScroll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Size screenSize = MediaQuery.of(context).size;
    final bool isMobile = screenSize.width < 768;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                          color: Color(0xFFE31C5F),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: isMobile ? 16 : 32),
                  
                  // Search Bar
                  Expanded(
                    child: Container(
                      height: isMobile ? 48 : 56,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: SearchSegment(
                              label: 'Anywhere',
                              hint: 'Search destinations',
                              onTap: () {},
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 24,
                            color: Colors.grey.shade300,
                          ),
                          Expanded(
                            child: SearchSegment(
                              label: 'Any week',
                              hint: 'Add dates',
                              onTap: () {},
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 24,
                            color: Colors.grey.shade300,
                          ),
                          Expanded(
                            child: SearchSegment(
                              label: 'Add guests',
                              hint: 'Add guests',
                              onTap: () {},
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(4),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE31C5F),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.search, color: Colors.white, size: 20),
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
                            'Become a host',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.menu, color: Colors.black87),
                      ),
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
                          radius: 16,
                          backgroundColor: Colors.black,
                          child: const Text(
                            'C',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Main Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 24),
                  
                  // Property Title
                  Text(
                    widget.property.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Navigation Tabs
                  _buildNavigationTabs(),
                  const SizedBox(height: 24),
                  
                  // Tab Content
                  _buildTabContent(),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery(bool isMobile) {
    return Column(
      children: <Widget>[
        // Main Image with PageView
        Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: <Widget>[
              // PageView for auto-scrolling images
              PageView.builder(
                controller: _pageController,
                onPageChanged: _onImagePageChanged,
                itemCount: propertyImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(propertyImages[index]),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                },
              ),
              
              // Auto-scroll indicator
              Positioned(
                top: 16,
                right: 16,
                child: GestureDetector(
                  onTap: () {
                    if (_isAutoScrolling) {
                      _stopAutoScroll();
                    } else {
                      _resumeAutoScroll();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          _isAutoScrolling ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _isAutoScrolling ? 'Auto' : 'Paused',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Image navigation arrows
              Positioned(
                left: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      final int prevIndex = selectedImageIndex > 0 
                          ? selectedImageIndex - 1 
                          : propertyImages.length - 1;
                      _pageController.animateToPage(
                        prevIndex,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.chevron_left, size: 24),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      final int nextIndex = (selectedImageIndex + 1) % propertyImages.length;
                      _pageController.animateToPage(
                        nextIndex,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.chevron_right, size: 24),
                    ),
                  ),
                ),
              ),
              
              // Image dots indicator
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(propertyImages.length, (index) {
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: index == selectedImageIndex 
                            ? Colors.white 
                            : Colors.white.withOpacity(0.5),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        // Thumbnail Images
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: propertyImages.length,
            itemBuilder: (context, index) {
              final bool isSelected = index == selectedImageIndex;
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? const Color(0xFFE31C5F) : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(propertyImages[index]),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          // Guest Favourite Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Guest favourite',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.pink,
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Description
          const Expanded(
            child: Text(
              'One of the most loved home on Airbnb, according to guests',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          
          // Rating
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.star, size: 16, color: Colors.black),
                  const SizedBox(width: 4),
                  const Text(
                    '4.92',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '64 Reviews',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'About this place',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Experience the perfect blend of comfort and style in this cozy studio apartment. Located in the heart of Bengaluru, this space offers modern amenities and a peaceful environment for your stay.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade700,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        
        // Amenities
        const Text(
          'What this place offers',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: <Widget>[
            _buildAmenity('Wi-Fi'),
            _buildAmenity('Kitchen'),
            _buildAmenity('Parking'),
            _buildAmenity('Air conditioning'),
            _buildAmenity('TV'),
            _buildAmenity('Balcony'),
          ],
        ),
      ],
    );
  }

  Widget _buildAmenity(String amenity) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(Icons.check, size: 16, color: Colors.green),
        const SizedBox(width: 8),
        Text(
          amenity,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildBookingCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Price
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              const Text(
                '₹6,504',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'for 2 nights',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Availability Notice
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Rare find! This place is usually booked',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Check-in/Check-out
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'CHECK-IN',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      checkInDate != null 
                        ? '${checkInDate!.day}/${checkInDate!.month}/${checkInDate!.year}'
                        : 'Add date',
                      style: TextStyle(
                        fontSize: 14,
                        color: checkInDate != null ? Colors.black : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'CHECKOUT',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      checkOutDate != null 
                        ? '${checkOutDate!.day}/${checkOutDate!.month}/${checkOutDate!.year}'
                        : 'Add date',
                      style: TextStyle(
                        fontSize: 14,
                        color: checkOutDate != null ? Colors.black : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Guest Count
          const Text(
            'GUESTS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$guestCount guest${guestCount > 1 ? 's' : ''}',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 24),
          
          // Reserve Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showReservationDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE31C5F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Reserve',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Price Breakdown
          Column(
            children: <Widget>[
              _buildPriceRow('₹3,252 x 2 nights', '₹6,504'),
              const SizedBox(height: 8),
              _buildPriceRow('Cleaning fee', '₹500'),
              const SizedBox(height: 8),
              _buildPriceRow('Service fee', '₹650'),
              const Divider(),
              _buildPriceRow('Total', '₹7,654', isTotal: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            decoration: isTotal ? TextDecoration.underline : null,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationTabs() {
    final List<String> tabs = <String>[
      'Photos',
      'Amenities',
      'Reviews',
      'Location',
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final int index = entry.key;
          final String tab = entry.value;
          final bool isSelected = index == selectedTabIndex;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedTabIndex = index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? Colors.black : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  tab,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? Colors.black : Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTabIndex) {
      case 0:
        return _buildPhotosTab();
      case 1:
        return _buildAmenitiesTab();
      case 2:
        return _buildReviewsTab();
      case 3:
        return _buildLocationTab();
      default:
        return _buildPhotosTab();
    }
  }

  Widget _buildPhotosTab() {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isMobile = screenSize.width < 768;

    return Column(
      children: <Widget>[
        // Image Gallery
        _buildImageGallery(isMobile),
        const SizedBox(height: 24),
        
        // Content Layout
        isMobile 
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Property Type and Location
                Text(
                  'Entire apartment in Bengaluru, India',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '2 guests, 1 bedroom, 1 bathroom',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Reviews Card
                _buildReviewsCard(),
                const SizedBox(height: 24),
                
                // Booking Card (on top for mobile)
                _buildBookingCard(),
                const SizedBox(height: 24),
                
                // Property Description
                _buildPropertyDescription(),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            // Left Column - Property Details
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Property Type and Location
                  Text(
                    'Entire apartment in Bengaluru, India',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '2 guests, 1 bedroom, 1 bathroom',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Reviews Card
                  _buildReviewsCard(),
                  const SizedBox(height: 24),
                  
                  // Property Description
                  _buildPropertyDescription(),
                ],
              ),
            ),
            
            const SizedBox(width: 48),
            
            // Right Column - Booking Card
            SizedBox(
              width: 360,
              child: _buildBookingCard(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAmenitiesTab() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'What this place offers',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          
          // Amenities Grid
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    _buildAmenityItem('wifi', '📶'),
                    _buildAmenityItem('Free parking on premises', '🅿️'),
                    _buildAmenityItem('TV', '📺'),
                    _buildAmenityItem('Air conditioning', '❄️'),
                    _buildAmenityItem('Fridge', '🧊'),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: <Widget>[
                    _buildAmenityItem('Dedicated workspace', '💻'),
                    _buildAmenityItem('Pool', '🏊'),
                    _buildAmenityItem('Lift', '🛗'),
                    _buildAmenityItem('Hair Dryer', '💨'),
                    _buildAmenityItem('Carbon monoxide alarm', '🔔'),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Show all amenities button
          Center(
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'Show all 27 amenities',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Booking Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  '2 nights in candolim',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '27 Jun 2025 - 29 Jun 2025',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityItem(String name, String icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: <Widget>[
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Guest Favourite Badge
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: <Widget>[
                  // Laurel wreath design with rating
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300, width: 3),
                    ),
                    child: Center(
                      child: Text(
                        widget.property.rating.toString(),
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.property.isGuestFavourite ? 'Guest favourite' : 'Highly rated',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This home has ${widget.property.totalReviews} reviews with an average rating of ${widget.property.rating}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          
          // Rating Breakdown
          const Text(
            'Rating breakdown',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          // Rating Categories
          Wrap(
            spacing: 24,
            runSpacing: 16,
            children: <Widget>[
              _buildRatingCategory('Overall rating', widget.property.rating.toString()),
              _buildRatingCategory('Cleanliness', (widget.property.rating - 0.1).toStringAsFixed(1)),
              _buildRatingCategory('Accuracy', (widget.property.rating + 0.1).toStringAsFixed(1)),
              _buildRatingCategory('Check-in', (widget.property.rating + 0.2).toStringAsFixed(1)),
              _buildRatingCategory('Communication', (widget.property.rating - 0.1).toStringAsFixed(1)),
              _buildRatingCategory('Location', (widget.property.rating + 0.1).toStringAsFixed(1)),
              _buildRatingCategory('Value', (widget.property.rating - 0.2).toStringAsFixed(1)),
            ],
          ),
          const SizedBox(height: 32),
          
          // Individual Reviews
          const Text(
            'Reviews',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          // Reviews Grid
          ...widget.property.reviews.take(2).map((review) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildReviewItem(
              review.guestName,
              review.rating.toString(),
              review.comment,
              review.date,
              review.guestTenure,
              review.guestAvatar,
            ),
          )).toList(),
          
          if (widget.property.reviews.length > 2)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: TextButton(
                onPressed: () {
                  // Show all reviews dialog
                  _showAllReviewsDialog();
                },
                child: Text('Show all ${widget.property.totalReviews} reviews'),
              ),
            ),
          
          const SizedBox(height: 32),
          
          // User Comments Section
          const Text(
            'Leave a Review',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          // Rating Input
          Row(
            children: <Widget>[
              const Text('Your Rating: '),
              ...List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _userRating = index + 1.0;
                    });
                  },
                  child: Icon(
                    index < _userRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 24,
                  ),
                );
              }),
              const SizedBox(width: 8),
              Text('${_userRating.toInt()}/5'),
            ],
          ),
          const SizedBox(height: 16),
          
          // Comment Input
          TextField(
            controller: _commentController,
            decoration: const InputDecoration(
              hintText: 'Share your experience with this property...',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(16),
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          
          // Submit Button
          ElevatedButton(
            onPressed: () {
              if (_commentController.text.trim().isNotEmpty) {
                _addUserComment();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE31C5F),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Submit Review'),
          ),
          
          const SizedBox(height: 24),
          
          // User Comments Display
          if (_userComments.isNotEmpty) ...[
            const Text(
              'Your Reviews',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ..._userComments.map((comment) => _buildUserComment(comment)),
          ],
        ],
      ),
    );
  }

  Widget _buildRatingBreakdown() {
    final List<Map<String, dynamic>> ratings = [
      {'label': 'Cleanliness', 'rating': 4.9},
      {'label': 'Accuracy', 'rating': 4.8},
      {'label': 'Check-in', 'rating': 4.9},
      {'label': 'Communication', 'rating': 4.7},
      {'label': 'Location', 'rating': 4.8},
      {'label': 'Value', 'rating': 4.6},
    ];

    return Column(
      children: ratings.map((rating) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                rating['label'],
                style: const TextStyle(fontSize: 16),
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 100,
                    child: LinearProgressIndicator(
                      value: rating['rating'] / 5.0,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    rating['rating'].toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRatingCategory(String label, String rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            rating,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String name, String rating, String comment, String date, String tenure, [String? avatarUrl]) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.green.shade700,
                backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                child: avatarUrl == null ? Text(
                  name[0],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ) : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      tenure,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  ...List.generate(5, (index) {
                    final double ratingValue = double.parse(rating);
                    if (index < ratingValue.floor()) {
                      return const Icon(Icons.star, color: Colors.black, size: 16);
                    } else if (index == ratingValue.floor() && ratingValue % 1 != 0) {
                      return const Icon(Icons.star_half, color: Colors.black, size: 16);
                    } else {
                      return Icon(Icons.star, color: Colors.grey.shade300, size: 16);
                    }
                  }),
                  const SizedBox(width: 4),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            comment,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTab() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Where you\'ll be',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          // Location Description
          Text(
            'Bengaluru, Karnataka, India',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 16),
          
          Text(
            'This property is located in the heart of Bengaluru, close to major attractions, restaurants, and shopping areas. The neighborhood is safe and well-connected with public transportation.',
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          
          // Nearby Places
          const Text(
            'What\'s nearby',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildNearbyPlace('Candolim Beach', '12-min walk'),
          _buildNearbyPlace('Goa International Airport', '45 min drive'),
          _buildNearbyPlace('Calangute Beach', '15 min drive'),
          _buildNearbyPlace('Baga Beach', '20 min drive'),
          _buildNearbyPlace('Anjuna Beach', '25 min drive'),
          
          const SizedBox(height: 24),
          
          // Map Placeholder
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.map, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    'Interactive Map',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyPlace(String name, String distance) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            distance,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  void _showReservationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Reservation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.property.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.property.location,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),
              
              // Booking Details
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text('Check-in:'),
                        Text(checkInDate != null 
                          ? '${checkInDate!.day}/${checkInDate!.month}/${checkInDate!.year}'
                          : 'Select dates'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text('Check-out:'),
                        Text(checkOutDate != null 
                          ? '${checkOutDate!.day}/${checkOutDate!.month}/${checkOutDate!.year}'
                          : 'Select dates'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text('Guests:'),
                        Text('$guestCount guest${guestCount > 1 ? 's' : ''}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text('Total:'),
                        Text(
                          '₹${(widget.property.price * 2 + 1150).toString()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              const Text(
                'By clicking "Confirm Reservation", you agree to the terms and conditions.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => _confirmReservation(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE31C5F),
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirm Reservation'),
            ),
          ],
        );
      },
    );
  }

  void _confirmReservation() {
    Navigator.of(context).pop(); // Close the dialog
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reservation confirmed! You will receive a confirmation email shortly.'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
    
    // Show booking confirmation dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text('Booking Confirmed!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Your reservation at ${widget.property.title} has been confirmed.',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Booking Details:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Property: ${widget.property.title}'),
                    Text('Location: ${widget.property.location}'),
                    Text('Check-in: ${checkInDate?.day}/${checkInDate?.month}/${checkInDate?.year ?? 'TBD'}'),
                    Text('Check-out: ${checkOutDate?.day}/${checkOutDate?.month}/${checkOutDate?.year ?? 'TBD'}'),
                    Text('Guests: $guestCount'),
                    Text('Total: ₹${(widget.property.price * 2 + 1150).toString()}'),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              const Text(
                'A confirmation email has been sent to your registered email address. You can view your booking details in the "Travel" section of your profile.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('View Profile'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to home
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE31C5F),
                foregroundColor: Colors.white,
              ),
              child: const Text('Continue Browsing'),
            ),
          ],
        );
      },
    );
  }

  void _showAllReviewsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('All Reviews (${widget.property.totalReviews})'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: widget.property.reviews.length,
            itemBuilder: (context, index) {
              final review = widget.property.reviews[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildReviewItem(
                  review.guestName,
                  review.rating.toString(),
                  review.comment,
                  review.date,
                  review.guestTenure,
                  review.guestAvatar,
                ),
              );
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _addUserComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        _userComments.add({
          'rating': _userRating,
          'comment': _commentController.text.trim(),
          'date': DateTime.now(),
          'userName': 'Aashritha Vejendla', // Current user name
        });
      });
      
      _commentController.clear();
      _userRating = 5.0;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review submitted successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildUserComment(Map<String, dynamic> comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue.shade700,
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      comment['userName'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Your review • ${_formatDate(comment['date'])}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < comment['rating'] ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            comment['comment'],
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
