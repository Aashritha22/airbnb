import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/admin_card.dart';
import '../widgets/admin_table.dart';
import '../widgets/responsive_layout.dart';
import '../models/property.dart';
import '../models/property_category.dart';

class PropertiesScreen extends StatefulWidget {
  const PropertiesScreen({super.key});

  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  String selectedFilter = 'All';
  final List<String> filters = ['All', 'Active', 'Verified', 'Blocked', 'New'];

  @override
  Widget build(BuildContext context) {
    // Sample data - in a real app, this would come from an API
    final propertyStats = const PropertyStats(
      totalProperties: 320,
      activeProperties: 280,
      verifiedProperties: 250,
      blockedProperties: 15,
      averageRating: 4.7,
      totalRevenue: 125000.0,
      averagePrice: 150.0,
    );

    final properties = [
      Property(
        id: '1',
        title: 'Cozy Studio Apartment',
        location: 'Bengaluru, India',
        category: PropertyCategory.all[1], // Beach
        hostId: 'host1',
        hostName: 'Sarah Johnson',
        price: 150.0,
        rating: 4.8,
        totalReviews: 128,
        isActive: true,
        isVerified: true,
        createdDate: DateTime.now().subtract(const Duration(days: 30)),
        lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
        imageUrl: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        description: 'A beautiful studio apartment in the heart of the city.',
        amenities: ['Wi-Fi', 'Kitchen', 'Parking'],
        maxGuests: 2,
        bedrooms: 1,
        bathrooms: 1,
        totalBookings: 45,
        totalRevenue: 6750.0,
        isBlocked: false,
      ),
      Property(
        id: '2',
        title: 'Modern Beach House',
        location: 'Malibu, California',
        category: PropertyCategory.all[1], // Beach
        hostId: 'host2',
        hostName: 'Emma Wilson',
        price: 250.0,
        rating: 4.9,
        totalReviews: 89,
        isActive: true,
        isVerified: true,
        createdDate: DateTime.now().subtract(const Duration(days: 60)),
        lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
        imageUrl: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        description: 'Stunning beach house with ocean views.',
        amenities: ['Wi-Fi', 'Kitchen', 'Pool', 'Parking'],
        maxGuests: 6,
        bedrooms: 3,
        bathrooms: 2,
        totalBookings: 32,
        totalRevenue: 8000.0,
        isBlocked: false,
      ),
      Property(
        id: '3',
        title: 'Luxury Mountain Cabin',
        location: 'Aspen, Colorado',
        category: PropertyCategory.all[2], // Mountain
        hostId: 'host3',
        hostName: 'Mike Chen',
        price: 180.0,
        rating: 4.7,
        totalReviews: 67,
        isActive: true,
        isVerified: false,
        createdDate: DateTime.now().subtract(const Duration(days: 15)),
        lastUpdated: DateTime.now().subtract(const Duration(hours: 12)),
        imageUrl: 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        description: 'Cozy mountain retreat with fireplace.',
        amenities: ['Wi-Fi', 'Fireplace', 'Hot Tub'],
        maxGuests: 4,
        bedrooms: 2,
        bathrooms: 1,
        totalBookings: 18,
        totalRevenue: 3240.0,
        isBlocked: false,
      ),
      Property(
        id: '4',
        title: 'Downtown Loft',
        location: 'New York, NY',
        category: PropertyCategory.all[3], // City
        hostId: 'host4',
        hostName: 'David Brown',
        price: 320.0,
        rating: 4.6,
        totalReviews: 156,
        isActive: false,
        isVerified: true,
        createdDate: DateTime.now().subtract(const Duration(days: 90)),
        lastUpdated: DateTime.now().subtract(const Duration(days: 5)),
        imageUrl: 'https://images.unsplash.com/photo-1484154218962-a197022b5858?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        description: 'Modern loft in downtown Manhattan.',
        amenities: ['Wi-Fi', 'Kitchen', 'Gym'],
        maxGuests: 4,
        bedrooms: 2,
        bathrooms: 2,
        totalBookings: 78,
        totalRevenue: 24960.0,
        isBlocked: true,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ResponsiveLayout(
            mobile: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Properties Management',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Handle add property
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Property'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE31C5F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            desktop: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Properties Management',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle add property
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Property'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE31C5F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Stats Cards
          ResponsiveLayout(
            mobile: Column(
              children: [
                AdminCard(
                  title: 'Total Properties',
                  value: propertyStats.totalProperties.toString(),
                  icon: Icons.home,
                  color: Colors.blue,
                  subtitle: 'Active: ${propertyStats.activeProperties}',
                ),
                const SizedBox(height: 16),
                AdminCard(
                  title: 'Verified Properties',
                  value: propertyStats.verifiedProperties.toString(),
                  icon: Icons.verified,
                  color: Colors.green,
                  subtitle: '${((propertyStats.verifiedProperties / propertyStats.totalProperties) * 100).toStringAsFixed(1)}% of total',
                ),
                const SizedBox(height: 16),
                AdminCard(
                  title: 'Average Rating',
                  value: propertyStats.averageRating.toString(),
                  icon: Icons.star,
                  color: Colors.orange,
                  subtitle: 'Based on all reviews',
                ),
                const SizedBox(height: 16),
                AdminCard(
                  title: 'Total Revenue',
                  value: NumberFormat.currency(symbol: '\$').format(propertyStats.totalRevenue),
                  icon: Icons.attach_money,
                  color: Colors.purple,
                  subtitle: 'Avg: ${NumberFormat.currency(symbol: '\$').format(propertyStats.averagePrice)}/night',
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
                  title: 'Total Properties',
                  value: propertyStats.totalProperties.toString(),
                  icon: Icons.home,
                  color: Colors.blue,
                  subtitle: 'Active: ${propertyStats.activeProperties}',
                ),
                AdminCard(
                  title: 'Verified Properties',
                  value: propertyStats.verifiedProperties.toString(),
                  icon: Icons.verified,
                  color: Colors.green,
                  subtitle: '${((propertyStats.verifiedProperties / propertyStats.totalProperties) * 100).toStringAsFixed(1)}% of total',
                ),
                AdminCard(
                  title: 'Average Rating',
                  value: propertyStats.averageRating.toString(),
                  icon: Icons.star,
                  color: Colors.orange,
                  subtitle: 'Based on all reviews',
                ),
                AdminCard(
                  title: 'Total Revenue',
                  value: NumberFormat.currency(symbol: '\$').format(propertyStats.totalRevenue),
                  icon: Icons.attach_money,
                  color: Colors.purple,
                  subtitle: 'Avg: ${NumberFormat.currency(symbol: '\$').format(propertyStats.averagePrice)}/night',
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Filters
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                const Text(
                  'Filter by:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: filters.map((filter) {
                        final isSelected = selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(filter),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                selectedFilter = filter;
                              });
                            },
                            backgroundColor: Colors.grey.shade100,
                            selectedColor: const Color(0xFFE31C5F).withOpacity(0.2),
                            checkmarkColor: const Color(0xFFE31C5F),
                            labelStyle: TextStyle(
                              color: isSelected ? const Color(0xFFE31C5F) : Colors.grey.shade700,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Properties Table
          AdminTable(
            headers: const ['Property', 'Location', 'Category', 'Host', 'Price', 'Rating', 'Bookings', 'Status', 'Actions'],
            rows: properties.map((property) {
              return [
                AdminTableCell(
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: property.imageUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(property.imageUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          color: property.imageUrl == null ? Colors.grey.shade200 : null,
                        ),
                        child: property.imageUrl == null
                            ? const Icon(Icons.home, color: Colors.grey)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              property.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                Text(
                                  property.category.emoji,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    property.category.name,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                AdminTableCell(
                  child: Text(
                    property.location,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                AdminTableCell(
                  child: Text(
                    property.category.name,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                AdminTableCell(
                  child: Text(
                    property.hostName,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                AdminTableCell(
                  child: Text(
                    NumberFormat.currency(symbol: '\$').format(property.price),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                AdminTableCell(
                  child: Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${property.rating} (${property.totalReviews})',
                          style: const TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                AdminTableCell(
                  child: Text(
                    property.totalBookings.toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                AdminTableCell(
                  child: Row(
                    children: [
                      StatusBadge(
                        status: property.isActive ? 'Active' : 'Inactive',
                        color: property.isActive ? Colors.green : Colors.red,
                      ),
                      if (property.isVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.verified, size: 16, color: Colors.green),
                      ],
                      if (property.isBlocked) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.block, size: 16, color: Colors.red),
                      ],
                    ],
                  ),
                ),
                AdminTableCell(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          _showPropertyDetails(property);
                        },
                        icon: const Icon(Icons.visibility, size: 18),
                        tooltip: 'View Details',
                      ),
                      IconButton(
                        onPressed: () {
                          _editProperty(property);
                        },
                        icon: const Icon(Icons.edit, size: 18),
                        tooltip: 'Edit Property',
                      ),
                      IconButton(
                        onPressed: () {
                          _togglePropertyStatus(property);
                        },
                        icon: Icon(
                          property.isBlocked ? Icons.check_circle : Icons.block,
                          size: 18,
                        ),
                        tooltip: property.isBlocked ? 'Unblock Property' : 'Block Property',
                      ),
                    ],
                  ),
                ),
              ];
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showPropertyDetails(Property property) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Property Details - ${property.title}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Location', property.location),
              _buildDetailRow('Category', property.category.name),
              _buildDetailRow('Host', property.hostName),
              _buildDetailRow('Price', NumberFormat.currency(symbol: '\$').format(property.price)),
              _buildDetailRow('Rating', '${property.rating} (${property.totalReviews} reviews)'),
              _buildDetailRow('Max Guests', property.maxGuests.toString()),
              _buildDetailRow('Bedrooms', property.bedrooms.toString()),
              _buildDetailRow('Bathrooms', property.bathrooms.toString()),
              _buildDetailRow('Total Bookings', property.totalBookings.toString()),
              _buildDetailRow('Total Revenue', NumberFormat.currency(symbol: '\$').format(property.totalRevenue)),
              _buildDetailRow('Created Date', DateFormat('MMM dd, yyyy').format(property.createdDate)),
              _buildDetailRow('Last Updated', DateFormat('MMM dd, yyyy').format(property.lastUpdated)),
              _buildDetailRow('Active', property.isActive ? 'Yes' : 'No'),
              _buildDetailRow('Verified', property.isVerified ? 'Yes' : 'No'),
              _buildDetailRow('Blocked', property.isBlocked ? 'Yes' : 'No'),
              const SizedBox(height: 8),
              const Text(
                'Amenities:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                children: property.amenities.map((amenity) {
                  return Chip(
                    label: Text(amenity),
                    backgroundColor: Colors.grey.shade100,
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              const Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(property.description),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
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

  void _editProperty(Property property) {
    // Handle edit property
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit property: ${property.title}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _togglePropertyStatus(Property property) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${property.isBlocked ? 'Unblock' : 'Block'} Property'),
        content: Text(
          'Are you sure you want to ${property.isBlocked ? 'unblock' : 'block'} ${property.title}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Property ${property.isBlocked ? 'unblocked' : 'blocked'} successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: property.isBlocked ? Colors.green : Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(property.isBlocked ? 'Unblock' : 'Block'),
          ),
        ],
      ),
    );
  }
}
