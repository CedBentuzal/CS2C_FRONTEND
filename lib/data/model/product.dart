class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  final String? description;
  final String userId;
  final DateTime createdAt;
  final double? rating;
  final List<String>? sizes;
  final List<String>? colors;
  final String? sellerUsername;  // Added
  final String? demographic;     // <-- Added

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.description,
    required this.userId,
    DateTime? createdAt,
    this.rating,
    this.sizes,
    this.colors,
    this.sellerUsername,  // Added
    this.demographic,     // <-- Added
  }) : createdAt = createdAt ?? DateTime.now();

  factory Product.fromJson(Map<String, dynamic> json) {
    final priceValue = json['price'];
    double priceParsed;
    if (priceValue == null || priceValue.toString().isEmpty) {
      priceParsed = 0.0;
    } else {
      priceParsed = double.tryParse(priceValue.toString()) ?? 0.0;
    }
    return Product(
      id: json['id'].toString(),
      name: json['name'].toString(),
      price: priceParsed,
      imageUrl: json['image_url'].toString(),
      category: json['category']?.toString() ?? 'Uncategorized',
      description: json['description']?.toString(),
      userId: json['user_id'].toString(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : null,
      rating: json['rating'] != null
          ? double.tryParse(json['rating'].toString())
          : null,
      sizes: json['sizes'] != null
          ? List<String>.from(json['sizes'])
          : null,
      colors: json['colors'] != null
          ? List<String>.from(json['colors'])
          : null,
      sellerUsername: json['seller_username']?.toString(),  // Added
      demographic: json['demographic']?.toString(),         // <-- Added
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
    'image_url': imageUrl,
    'category': category,
    'description': description,
    'user_id': userId,
    'rating': rating,
    'sizes': sizes,
    'colors': colors,
    'seller_username': sellerUsername,  // Added
    'demographic': demographic,         // <-- Added
  };

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String get shortDescription =>
      description != null && description!.length > 50
          ? '${description!.substring(0, 50)}...'
          : description ?? 'No description';
}