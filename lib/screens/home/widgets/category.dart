import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/widgets/custom_sizebox.dart';
import 'package:restaurent/widgets/custom_text.dart';

class CategoryListImageTitle extends ConsumerWidget {
  final AsyncValue<List<Map<String, dynamic>>> categoriesAsync;

  const CategoryListImageTitle({Key? key, required this.categoriesAsync})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 250,
      child: categoriesAsync.when(
        data: (categories) => GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white30, width: 1),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      category['image_url'],
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 70,
                        height: 70,
                        color: Colors.grey[800],
                        child: Icon(Icons.image, color: Colors.white54),
                      ),
                    ),
                  ),
                ),
                CustomSizedBox.h5,
                CustomText(
                  text: category['name'],
                  fontSize: 16,
                  color: AppColors.white,
                ),
              ],
            );
          },
        ),
        loading: () => Center(child: CircularProgressIndicator(color: Colors.orange,)),
        error: (err, stack) =>
            Text('Error: $err', style: TextStyle(color: Colors.red)),
      ),
    );
  }
}
