import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';

class ApiService extends GetxService {
  static const String _baseUrl = 'https://dummyjson.com/products';

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?limit=100'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['products'] as List).map((e) => Product.fromJson(e)).toList();
      }
      throw Exception('Failed to load products: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to load products: ${e.toString()}');
    }
  }

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/categories'));
      if (response.statusCode == 200) {
        final List<dynamic> categoryNames = json.decode(response.body);
        return categoryNames.map((name) => Category(
          slug: name,
          name: _formatCategoryName(name),
          url: '$_baseUrl/category/$name',
        )).toList();
      }
      throw Exception('Failed to load categories: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to load categories: ${e.toString()}');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/search?q=$query'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['products'] as List).map((e) => Product.fromJson(e)).toList();
      }
      throw Exception('Failed to search products: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to search products: ${e.toString()}');
    }
  }

  Future<List<Product>> fetchProductsByCategory(String category) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/category/$category'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['products'] as List).map((e) => Product.fromJson(e)).toList();
      }
      throw Exception('Failed to load products by category: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to load products by category: ${e.toString()}');
    }
  }

  String _formatCategoryName(String name) {
    return name.replaceAll('-', ' ').split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}