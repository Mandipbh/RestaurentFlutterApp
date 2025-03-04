import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/constants/colors.dart';
import 'package:restaurent/constants/images.dart';
import 'package:restaurent/constants/responsive.dart';
import 'package:restaurent/constants/strings.dart';
import 'package:restaurent/providers/auth_provider.dart';
import 'package:restaurent/providers/cart_provider.dart';
import 'package:restaurent/providers/category_provider.dart';
import 'package:restaurent/providers/food_provider.dart';
import 'package:restaurent/providers/menu_provider.dart';
import 'package:restaurent/providers/search_provider.dart';
import 'package:restaurent/providers/user_provider.dart';
import 'package:restaurent/screens/cart/cart_screen.dart';
import 'package:restaurent/screens/home/widgets/category_food_list.dart';
import 'package:restaurent/screens/home/widgets/combination_breakfast_list.dart';
import 'package:restaurent/screens/home/widgets/promo_banner.dart';
import 'package:restaurent/screens/home/widgets/recommended_breakfast_list.dart';
import 'package:restaurent/screens/home/widgets/searchbar.dart';
import 'package:restaurent/screens/order_food/search_results_counter.dart';
import 'package:restaurent/screens/reserve_table/reserve_table.dart';
import 'package:restaurent/screens/splash/splash.dart';
import 'package:restaurent/widgets/custom_divider.dart';
import 'package:restaurent/widgets/custom_sizebox.dart';
import 'package:restaurent/widgets/custom_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderFood extends ConsumerStatefulWidget {
  const OrderFood({super.key});

  @override
  ConsumerState<OrderFood> createState() => _OrderFoodState();
}

class _OrderFoodState extends ConsumerState<OrderFood> {
  @override
  Widget build(BuildContext context) {
    final categoryAsync = ref.watch(catListProvider);
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);
    final foodItems = ref.watch(foodListProvider(selectedCategoryId));
    final user = ref.watch(authProvider);
    final userDetail = ref.watch(userProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    final categoriesAsync = ref.watch(menuCategoriesProvider);
    final breakfastAsync = ref.watch(breakfastItemsProvider);
    final recommendedAsync = ref.watch(recommendedBreakfastsProvider);
    final cartItems = ref.watch(cartProvider);

    // Check if any results will be shown based on the current search
    bool hasNoResults = searchQuery.isNotEmpty && 
      foodItems.maybeWhen(
        data: (foods) => foods == null || foods.where((food) => 
          matchesSearchQuery(food['name'] ?? '', searchQuery)
        ).isEmpty,
        orElse: () => false,
      ) &&
      breakfastAsync.maybeWhen(
        data: (foods) => foods == null || foods.where((food) => 
          matchesSearchQuery(food['name'] ?? '', searchQuery)
        ).isEmpty,
        orElse: () => false,
      ) &&
      recommendedAsync.maybeWhen(
        data: (foods) => foods == null || foods.where((food) => 
          matchesSearchQuery(food['name'] ?? '', searchQuery)
        ).isEmpty,
        orElse: () => false,
      );

    Future<void> logout(BuildContext context) async {
      final supabase = Supabase.instance.client;
      await supabase.auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Splash()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReserveTable()),
                  );
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(Images.circleavatar_bg),
                ),
              ),
              SizedBox(width: 8),
              if (userDetail != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (userDetail.fullName.isNotEmpty)
                      CustomText(
                        text: userDetail.fullName,
                        fontSize: 12,
                        color: AppColors.white,
                      ),
                    if (userDetail.address.isNotEmpty)
                      CustomText(
                        text: userDetail.address,
                        fontSize: 12,
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        width: 100,
                      ),
                  ],
                ),
            ],
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: AppColors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
                },
              ),
              if (cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: badges.Badge(
                    badgeContent: Text(
                      cartItems.length.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    badgeStyle: badges.BadgeStyle(
                      badgeColor: Colors.red,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomDivider(
                color: AppColors.dividercolor,
                thickness: 1.5,
                indent: ScreenSize.width(context) * 0.05,
                endIndent: ScreenSize.width(context) * 0.05,
              ),
              SearchBarWidget(
                hintText: "Search food items...",
                backgroundColor: AppColors.searchbgcolor900,
                hintTextColor: AppColors.white60,
                iconColor: AppColors.white,
                iconSize: 25.0,
                textColor: AppColors.white,
              ),

              if (searchQuery.isNotEmpty && !hasNoResults)
                SearchResultsCounter(
                  foodItems: foodItems,
                  breakfastItems: breakfastAsync,
                  recommendedItems: recommendedAsync,
                ),
              
              // Show "No results found" message when search has no matches
              if (hasNoResults)
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(Icons.search_off, color: Colors.grey, size: 48),
                      SizedBox(height: 16),
                      Text(
                        'No results found for "$searchQuery"',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Try a different search term',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
              if (!hasNoResults) ...[
                CustomSizedBox.h10,
                PromoBannerWidget(
                  imagePaths: [
                    Images.banner,
                    Images.banner,
                    Images.banner,
                    Images.banner,
                  ],
                ),
                CustomSizedBox.h10,
                if (user != null)
                  CategoryFoodList(
                    categoryAsync: categoryAsync,
                    foodItems: foodItems,
                    user: user,
                    selectedCategoryIdProvider: selectedCategoryIdProvider,
                  ),
                CustomSizedBox.h10,
                
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: CustomText(
                    text: Strings.combinationbreakfast,
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                if (user != null)
                  CombinationBreakfastList(
                    breakfastAsync: breakfastAsync,
                    user: user,
                  ),
                Container(
                  padding: EdgeInsets.only(left: 20, bottom: 10, right: 20, top: 10),
                  child: CustomText(
                    text: Strings.recBreakfast,
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (user != null)
                  RecommendedFoodList(
                    recommendedAsync: recommendedAsync, 
                    user: user
                  )
              ],
            ],
          ),
        ),
      ),
    );
  }
}

