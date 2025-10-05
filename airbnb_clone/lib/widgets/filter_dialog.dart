import 'package:flutter/material.dart';
import '../models/filter.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({
    super.key,
    required this.filter,
    required this.onApply,
  });

  final FilterModel filter;
  final ValueChanged<FilterModel> onApply;

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late RangeValues _priceRange;
  late List<String> _propertyTypes;
  late List<String> _amenities;
  late int _guestCount;

  @override
  void initState() {
    super.initState();
    _priceRange = widget.filter.priceRange;
    _propertyTypes = List.from(widget.filter.propertyTypes);
    _amenities = List.from(widget.filter.amenities);
    _guestCount = widget.filter.guestCount;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Size screenSize = MediaQuery.of(context).size;
    final bool isMobile = screenSize.width < 768;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: isMobile ? screenSize.width * 0.9 : 600,
        height: isMobile ? screenSize.height * 0.8 : 700,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Price Range
                    _buildPriceRange(),
                    const SizedBox(height: 32),

                    // Property Types
                    _buildPropertyTypes(),
                    const SizedBox(height: 32),

                    // Amenities
                    _buildAmenities(),
                    const SizedBox(height: 32),

                    // Guest Count
                    _buildGuestCount(),
                  ],
                ),
              ),
            ),

            // Footer Buttons
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: _clearAllFilters,
                  child: const Text('Clear all'),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Show results'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRange() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Price range',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 1000,
          divisions: 20,
          onChanged: (RangeValues values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('\$${_priceRange.start.round()}'),
            Text('\$${_priceRange.end.round()}'),
          ],
        ),
      ],
    );
  }

  Widget _buildPropertyTypes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Property type',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: PropertyType.all.map((type) {
            final bool isSelected = _propertyTypes.contains(type.id);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _propertyTypes.remove(type.id);
                  } else {
                    _propertyTypes.add(type.id);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  color: isSelected ? Colors.black : Colors.white,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      type.icon,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      type.name,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAmenities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Amenities',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: Amenity.all.map((amenity) {
            final bool isSelected = _amenities.contains(amenity.id);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _amenities.remove(amenity.id);
                  } else {
                    _amenities.add(amenity.id);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  color: isSelected ? Colors.black : Colors.white,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      amenity.icon,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      amenity.name,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGuestCount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Guests',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            IconButton(
              onPressed: _guestCount > 1
                  ? () => setState(() => _guestCount--)
                  : null,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            const SizedBox(width: 16),
            Text(
              '$_guestCount guest${_guestCount > 1 ? 's' : ''}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: () => setState(() => _guestCount++),
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ],
    );
  }

  void _clearAllFilters() {
    setState(() {
      _priceRange = const RangeValues(0, 1000);
      _propertyTypes.clear();
      _amenities.clear();
      _guestCount = 1;
    });
  }

  void _applyFilters() {
    final FilterModel newFilter = widget.filter.copyWith(
      priceRange: _priceRange,
      propertyTypes: _propertyTypes,
      amenities: _amenities,
      guestCount: _guestCount,
    );
    widget.onApply(newFilter);
    Navigator.of(context).pop();
  }
}
