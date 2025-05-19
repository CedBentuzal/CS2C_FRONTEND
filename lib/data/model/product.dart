// model/product.dart
class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  final String? description;
  final String userId;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.description,
    required this.userId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(), // Ensure string conversion
      name: json['name'].toString(),
      price: double.parse(json['price'].toString()),
      imageUrl: json['image_url'].toString(),
      category: json['category']?.toString() ?? 'Uncategorized',
      description: json['description']?.toString(),
      userId: json['user_id'].toString(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
    'image_url': imageUrl,
    'category': category,
    'description': description,
    'user_id': userId,
  };

  // Helper getters
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String get shortDescription =>
      description != null && description!.length > 50
          ? '${description!.substring(0, 50)}...'
          : description ?? 'No description';
}