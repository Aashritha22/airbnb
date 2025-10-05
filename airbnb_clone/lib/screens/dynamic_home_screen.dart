import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/api_property.dart';
import '../models/category_icon.dart';
import '../providers/property_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/search_segment.dart';
import '../widgets/nav_tab.dart';
import '../widgets/category_button.dart';
import '../widgets/property_card.dart';
import '../widgets/filter_dialog.dart';
import 'profile_screen.dart';
import 'search_results_screen.dart';

class DynamicHomeScreen extends StatefulWidget {
  const DynamicHomeScreen({super.key});

  @override
  State<DynamicHomeScreen> createState() => _DynamicHomeScreenState();
}

class _DynamicHomeScreenState extends State<DynamicHomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final propertyProvider = Provider.of<PropertyProvider>(context, listen: false);
      propertyProvider.loadProperties();
      propertyProvider.loadCategories();
      propertyProvider.loadAmenities();
      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.loadCurrentUser();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      final propertyProvider = Provider.of<PropertyProvider>(context, listen: false);
      if (!propertyProvider.isLoading && propertyProvider.hasMore) {
        propertyProvider.loadProperties();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<PropertyProvider>(
          builder: (context, propertyProvider, child) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                // App Bar
                SliverAppBar(
                  floating: true,
                  snap: true,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE31C5F),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Airbnb',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        },
                        icon: Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            if (authProvider.userProfileImage != null) {
                              return CircleAvatar(
                                backgroundImage: NetworkImage(authProvider.userProfileImage!),
                                radius: 15,
                              );
                            }
                            return const CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 15,
                              child: Icon(Icons.person, color: Colors.white),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Search Segment
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SearchSegment(
                      onSearch: (query) {
                        propertyProvider.setSearchQuery(query);
                        propertyProvider.refresh();
                      },
                      onFilter: () => _showFilterDialog(context),
                    ),
                  ),
                ),

                // Categories
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: propertyProvider.categories.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: CategoryButton(
                              category: const CategoryIcon(emoji: '🏠', label: 'All'),
                              isSelected: propertyProvider.selectedCategory == null,
                              onTap: () {
                                propertyProvider.setCategory(null);
                                propertyProvider.refresh();
                              },
                            ),
                          );
                        }

                        final category = propertyProvider.categories[index - 1];
                        final categoryIcon = CategoryIcon(
                          emoji: category.emoji,
                          label: category.name,
                        );

                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: CategoryButton(
                            category: categoryIcon,
                            isSelected: propertyProvider.selectedCategory == category.id,
                            onTap: () {
                              propertyProvider.setCategory(category.id);
                              propertyProvider.refresh();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Properties List
                if (propertyProvider.isLoading && propertyProvider.properties.isEmpty)
                  const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                else if (propertyProvider.error != null && propertyProvider.properties.isEmpty)
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Text(
                              'Error: ${propertyProvider.error}',
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => propertyProvider.refresh(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index < propertyProvider.properties.length) {
                            final property = propertyProvider.properties[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: PropertyCard(
                                property: _convertToLegacyProperty(property),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PropertyDetailsScreen(
                                        property: property,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                          return null;
                        },
                        childCount: propertyProvider.properties.length,
                      ),
                    ),
                  ),

                // Loading indicator at bottom
                if (propertyProvider.isLoading && propertyProvider.properties.isNotEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),

                // No more data indicator
                if (!propertyProvider.hasMore && propertyProvider.properties.isNotEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          'No more properties to load',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const NavTab(),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FilterDialog(
        onApplyFilters: (filters) {
          final propertyProvider = Provider.of<PropertyProvider>(context, listen: false);
          
          propertyProvider.setPriceRange(
            filters.priceRange.start > 0 ? filters.priceRange.start : null,
            filters.priceRange.end < 1000 ? filters.priceRange.end : null,
          );
          
          propertyProvider.setGuests(filters.guestCount > 1 ? filters.guestCount : null);
          propertyProvider.setAmenities(filters.amenities);
          
          propertyProvider.refresh();
        },
      ),
    );
  }

  // Convert API property to legacy property format for existing UI components
  dynamic _convertToLegacyProperty(ApiProperty property) {
    return {
      'title': property.title,
      'location': property.location.fullLocation,
      'distance': property.location.distance,
      'dates': 'Check dates',
      'price': property.price.basePrice,
      'priceText': property.price.priceText,
      'rating': property.ratings.overall,
      'imageEmoji': property.imageEmoji,
      'category': property.category.name,
      'host': property.hostName,
      'isGuestFavourite': property.isGuestFavourite,
      'imageCount': property.imageCount,
      'imageUrl': property.imageUrl,
      'totalReviews': property.reviews.totalCount,
      'reviews': [],
    };
  }
}

// Placeholder for property details screen
class PropertyDetailsScreen extends StatelessWidget {
  final ApiProperty property;

  const PropertyDetailsScreen({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(property.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Property Title
            Text(
              property.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Location
            Text(
              property.location.fullLocation,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            
            // Rating and Reviews
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text('${property.ratings.overall}'),
                const SizedBox(width: 8),
                Text('(${property.reviews.totalCount} reviews)'),
              ],
            ),
            const SizedBox(height: 16),
            
            // Price
            Text(
              property.price.priceText,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Description
            Text(
              property.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            
            // Amenities
            if (property.amenities.isNotEmpty) ...[
              const Text(
                'Amenities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: property.amenities.take(6).map((amenity) {
                  return Chip(
                    label: Text('${amenity.icon} ${amenity.name}'),
                    backgroundColor: Colors.grey[200],
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
