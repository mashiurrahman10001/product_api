import 'package:get/get.dart';

import '../../../data/models/category_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';

class ProductController extends GetxController {
  final ProductRepository _repository = Get.find();

  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  final RxList<Category> categories = <Category>[].obs;
  final RxString selectedCategory = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = true.obs;
  final RxBool isError = false.obs;

  @override
  void onInit() {
    fetchProducts();
    fetchCategories();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      isError(false);
      final result = await _repository.getProducts();
      products.assignAll(result);
      filteredProducts.assignAll(result);
    } catch (e) {
      isError(true);
      Get.snackbar('Error', 'Failed to load products');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchCategories() async {
    try {
      final result = await _repository.getCategories();
      categories.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load categories');
    }
  }

  Future<void> searchProducts(String query) async {
    try {
      isLoading(true);
      searchQuery.value = query;
      if (query.isEmpty) {
        if (selectedCategory.isEmpty) {
          filteredProducts.assignAll(products);
        } else {
          await filterByCategory(selectedCategory.value);
        }
      } else {
        final result = await _repository.searchProducts(query);
        if (selectedCategory.isNotEmpty) {
          filteredProducts.assignAll(
              result.where((p) => p.category.toLowerCase() ==
                  selectedCategory.value.toLowerCase()).toList()
          );
        } else {
          filteredProducts.assignAll(result);
        }
      }
    } catch (e) {
      isError(true);
      Get.snackbar('Error', 'Failed to search products');
    } finally {
      isLoading(false);
    }
  }
  Future<void> filterByCategory(String categorySlug) async {
    try {
      isLoading(true);
      selectedCategory.value = categorySlug;
      if (categorySlug.isEmpty) {
        // If "All" is selected, show all products or filtered by search
        if (searchQuery.isEmpty) {
          filteredProducts.assignAll(products);
        } else {
          await searchProducts(searchQuery.value);
        }
      } else {
        final result = await _repository.getProductsByCategory(categorySlug);
        // If there's a search query, filter category results by search
        if (searchQuery.isNotEmpty) {
          filteredProducts.assignAll(
              result.where((p) => p.title.toLowerCase()
                  .contains(searchQuery.value.toLowerCase())).toList()
          );
        } else {
          filteredProducts.assignAll(result);
        }
      }
    } catch (e) {
      isError(true);
      Get.snackbar('Error', 'Failed to filter products');
    } finally {
      isLoading(false);
    }
  }
}