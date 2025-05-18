class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String? description;
  final String userId;
  final DateTime? createdAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.description,
    required this.userId,
    this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      imageUrl: json['image_url'],
      description: json['description'],
      userId: json['user_id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
    'image_url': imageUrl,
    'description': description,
    'user_id': userId,
  };
}