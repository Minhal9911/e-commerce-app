class ProductModel {
  final int id;
  final String title;
  final String thumbnail;
  final double price;
  final String category;
  final double? rating;
  final int? stock;

  ProductModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.price,
    required this.category,
    this.rating,
    this.stock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: int.tryParse(json['id'].toString())??0,
      title: json['title']??'',
      thumbnail: json['thumbnail']??'',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      category: json['category']??'',
      rating: (json['rating'] as num?)?.toDouble(),
      stock: json['stock'] as int?,
      // price: (json['price'] as num?)?.toDouble()??0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnail': thumbnail,
      'price': price,
      'category': category,
      'rating': rating,
      'stock': stock,
    };
  }
}
