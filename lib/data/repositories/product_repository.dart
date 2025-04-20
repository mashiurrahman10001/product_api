import 'package:get/get.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';

class ProductRepository {
  final ApiService _apiService = Get.find();

  Future<List<Product>> getProducts() async {
    return await _apiService.fetchProducts();
  }

  Future<List<Category>> getCategories() async {
    return await _apiService.fetchCategories();
  }

  Future<List<Product>> searchProducts(String query) async {
    return await _apiService.searchProducts(query);
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    return await _apiService.fetchProductsByCategory(category);
  }
}