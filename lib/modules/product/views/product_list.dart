import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/app_text_styles.dart';
import '../../../data/models/category_model.dart';
import '../../../routes/app_pages.dart';
import '../controllers/product_controller.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/shimmer_product_card.dart';

class ProductListView extends GetView<ProductController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover Products', style: AppTextStyles.headline),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Failed to load products'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchProducts,
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchProducts();
            if (controller.selectedCategory.isNotEmpty) {
              await controller.filterByCategory(controller.selectedCategory.value);
            }
            if (controller.searchQuery.isNotEmpty) {
              await controller.searchProducts(controller.searchQuery.value);
            }
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (query) => controller.searchProducts(query),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      CategoryChip(
                        category: Category(slug: '', name: 'All', url: ''),
                        isSelected: controller.selectedCategory.isEmpty,
                        onTap: () => controller.filterByCategory(''),
                      ),
                      ...controller.categories.map(
                            (category) => CategoryChip(
                          category: category,
                          isSelected: controller.selectedCategory.value == category.slug,
                          onTap: () => controller.filterByCategory(category.slug),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: controller.isLoading.value
                    ? SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => ShimmerProductCard(),
                    childCount: 6,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                )
                    : controller.filteredProducts.isEmpty
                    ? SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Text(
                        'No products found',
                        style: AppTextStyles.subtitle,
                      ),
                    ),
                  ),
                )
                    : SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final product = controller.filteredProducts[index];
                      return ProductCard(
                        product: product,
                        onTap: () => Get.toNamed(
                          Routes.PRODUCT_DETAIL,
                          arguments: product,
                        ),
                      );
                    },
                    childCount: controller.filteredProducts.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
