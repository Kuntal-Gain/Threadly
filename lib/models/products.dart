/* 

{productId , title , description , price , snapshots , ratings , Reviews , Sold , Category , Price , Size}

*/

import 'package:appwrite/models.dart';

class ProductModel {
  final String productId;
  final String title;
  final String description;
  final num price;
  num discountValue;
  final List<String> snapshots;
  final List<double> ratings;
  final List<String> reviews;
  final int soldUnits;
  final String category;
  final List<String> sizes;
  final List<String> colors; // for future use

  ProductModel({
    required this.productId,
    required this.title,
    required this.description,
    required this.price,
    required this.snapshots,
    required this.ratings,
    required this.reviews,
    required this.soldUnits,
    required this.category,
    required this.sizes,
    required this.colors,
    this.discountValue = 0,
  });

  factory ProductModel.fromDocument(Document doc) {
    final map = doc.data;

    return ProductModel(
      productId: doc.$id, // 👈 grabs the primary key
      title: map['title'],
      description: map['description'],
      price: map['price'],
      snapshots: List<String>.from(map['snapshots']),
      ratings: List<double>.from(map['ratings']),
      reviews: List<String>.from(map['reviews']),
      soldUnits: map['soldUnits'],
      category: map['category'],
      sizes: List<String>.from(map['sizes']),
      colors: List<String>.from(map['colors']),
      discountValue: map['discountValue'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'description': description,
      'price': price,
      'snapshots': snapshots,
      'ratings': ratings,
      'reviews': reviews,
      'soldUnits': soldUnits,
      'category': category,
      'sizes': sizes,
      'colors': colors,
      'discountValue': discountValue,
    };
  }
}
