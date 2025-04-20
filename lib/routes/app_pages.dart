import 'package:get/get_navigation/src/routes/get_route.dart';

import '../modules/product/bindings/product_binding.dart';
import '../modules/product/views/product_detail.dart';
import '../modules/product/views/product_list.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.PRODUCT_LIST;

  static final routes = [
    GetPage(
      name: _Paths.PRODUCT_LIST,
      page: () => ProductListView(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAIL,
      page: () => ProductDetailView(),
    ),
  ];
}