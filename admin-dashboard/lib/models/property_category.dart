class PropertyCategory {
  const PropertyCategory({
    required this.id,
    required this.name,
    required this.emoji,
  });

  final String id;
  final String name;
  final String emoji;

  static const List<PropertyCategory> all = <PropertyCategory>[
    PropertyCategory(id: 'all', name: 'All', emoji: '🏠'),
    PropertyCategory(id: 'beach', name: 'Beach', emoji: '🏖️'),
    PropertyCategory(id: 'mountain', name: 'Mountain', emoji: '🏔️'),
    PropertyCategory(id: 'city', name: 'City', emoji: '🏙️'),
    PropertyCategory(id: 'countryside', name: 'Countryside', emoji: '🏡'),
    PropertyCategory(id: 'lakefront', name: 'Lakefront', emoji: '🏞️'),
    PropertyCategory(id: 'desert', name: 'Desert', emoji: '🏜️'),
    PropertyCategory(id: 'tropical', name: 'Tropical', emoji: '🌺'),
    PropertyCategory(id: 'flats', name: 'Flats', emoji: '🏢'),
    PropertyCategory(id: 'resort', name: 'Resort', emoji: '🏝️'),
    PropertyCategory(id: 'alpine', name: 'Alpine', emoji: '⛷️'),
    PropertyCategory(id: 'castle', name: 'Castle', emoji: '🏰'),
  ];

  static PropertyCategory fromId(String id) {
    return all.firstWhere((category) => category.id == id);
  }
}
