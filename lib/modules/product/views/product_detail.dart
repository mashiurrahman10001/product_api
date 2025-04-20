import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../../../data/models/product_model.dart';

class ProductDetailView extends StatelessWidget {
  final Product product = Get.arguments;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: product.images.length,
                    itemBuilder: (context, index) {
                      return Hero(
                        tag: 'product-${product.id}',
                        child: CachedNetworkImage(
                          imageUrl: product.images[index],
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: product.images.length,
                        effect: WormEffect(
                          dotHeight: 6,
                          dotWidth: 6,
                          activeDotColor: AppColors.primary,
                          dotColor: Colors.grey[300]!,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: AppTextStyles.headline,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      SizedBox(width: 4),
                      Text('${product.rating}'),
                      Spacer(),
                      if (product.discountPercentage > 0)
                        Text(
                          '\$${(product.price * (1 + product.discountPercentage/100)).toStringAsFixed(2)}',
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                      SizedBox(width: 8),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: AppTextStyles.priceLarge,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Description',
                    style: AppTextStyles.subtitle,
                  ),
                  SizedBox(height: 8),
                  Text(
                    product.description,
                    style: AppTextStyles.body,
                  ),
                  SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        label: Text(product.category),
                        backgroundColor: AppColors.primary.withOpacity(0.2),
                      ),
                      if (product.brand.isNotEmpty)
                        Chip(
                          label: Text(product.brand),
                          backgroundColor: AppColors.accent.withOpacity(0.2),
                        ),
                      if (product.stock > 0)
                        Chip(
                          label: Text('${product.stock} in stock'),
                          backgroundColor: AppColors.success.withOpacity(0.2),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: () {},
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {},
                child: Text(
                  'Add to Cart',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}