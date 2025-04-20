part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const PRODUCT_LIST = _Paths.PRODUCT_LIST;
  static const PRODUCT_DETAIL = _Paths.PRODUCT_DETAIL;
}

abstract class _Paths {
  _Paths._();
  static const PRODUCT_LIST = '/product-list';
  static const PRODUCT_DETAIL = '/product-detail';
}