import 'package:get/get.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/services/api_service.dart';
import '../controllers/product_controller.dart';

class ProductBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiService());
    Get.lazyPut(() => ProductRepository());
    Get.lazyPut(() => ProductController());
  }
}