import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/providers/category_provider.dart';
import 'package:restaurent/providers/food_provider.dart';
import 'package:restaurent/providers/menu_provider.dart';
import 'package:restaurent/screens/order_food/food_detail_screen.dart';
import 'package:restaurent/screens/splash/splash.dart';
import 'package:restaurent/widgets/custom_bottombar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderFood extends ConsumerStatefulWidget {
  const OrderFood({super.key});

  @override
  ConsumerState<OrderFood> createState() => _OrderFoodState();
}

class _OrderFoodState extends ConsumerState<OrderFood> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final categoryAsync = ref.watch(catListProvider);
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);
    final foodItems = ref.watch(foodListProvider(selectedCategoryId));

    final categoriesAsync = ref.watch(menuCategoriesProvider);
    final breakfastAsync = ref.watch(breakfastItemsProvider);
    final recommendedAsync = ref.watch(recommendedBreakfastsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage:
                    AssetImage('assets/select_category/profile.png'),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Deliver to",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    "Palazhi, Calicut",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                color: Color.fromRGBO(38, 38, 45, 1),
                thickness: 1.5,
                indent: MediaQuery.of(context).size.width * 0.05,
                endIndent: MediaQuery.of(context).size.width * 0.05,
              ),
              _buildSearchBar(),
              SizedBox(height: 10),
              _buildPromoBanner(),
              _buildPageIndicator(),
              SizedBox(height: 20),
              categoryAsync.when(
                data: (categories) {
                  final categoryNames =
                      categories.map((cat) => cat["name"] as String).toList();
                  final categoryIds =
                      categories.map((cat) => cat["id"] as String).toList();
                  print('catet gaertet >> $selectedCategoryId');

                  if (selectedCategoryId == null && categoryIds.isNotEmpty) {
                    ref.read(selectedCategoryIdProvider.notifier).state =
                        categoryIds[0];
                    print(
                        'Setting default selectedCategoryId: ${categoryIds[0]}');
                  }

                  return SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoryNames.length,
                      itemBuilder: (context, index) {
                        final isSelected =
                            categoryIds[index] == selectedCategoryId;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: InkWell(
                            onTap: () {
                              ref
                                  .read(selectedCategoryIdProvider.notifier)
                                  .state = categoryIds[index];
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.orange
                                    : Colors.grey[900],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                categoryNames[index],
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey[400],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text("Error: $error"),
              ),
              SizedBox(height: 20),
              foodItems.when(
                data: (foods) {
                  if (foods.isEmpty) {
                    return Center(child: Text('No food items available'));
                  }

                  return SizedBox(
                    height: 230,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: foods.length,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      itemBuilder: (context, index) {
                        final food = foods[index];
                        return Container(
                          width: 170,
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color.fromARGB(255, 58, 20, 6)
                                    .withOpacity(0.7),
                                const Color.fromARGB(255, 58, 20, 6)
                                    .withOpacity(0.7),
                                Colors.black.withOpacity(0.5),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FoodDetailScreens(food: food),
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12)),
                                  child: Image.network(
                                    food['image_url'] ?? '',
                                    height: 140,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      height: 140,
                                      color: Colors.grey[800],
                                      child: Icon(Icons.fastfood,
                                          color: Colors.grey[600]),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      food['name'] ?? '',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.king_bed,
                                              color: Colors.grey,
                                              size: 20,
                                            ),
                                            Text(
                                              '5 kcal',
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 10),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.label,
                                              color: Colors.grey,
                                              size: 20,
                                            ),
                                            Text(
                                              '300 gm',
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '₹${food['price']}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FoodDetailScreens(
                                                        food: food),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade600,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text("Error: $err")),
              ),
              SizedBox(height: 20),
              SizedBox(
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
                              border:
                                  Border.all(color: Colors.white30, width: 1),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                category['image_url'],
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  width: 70,
                                  height: 70,
                                  color: Colors.grey[800],
                                  child:
                                      Icon(Icons.image, color: Colors.white54),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            category['name'],
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                  ),
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (err, stack) =>
                      Text('Error: $err', style: TextStyle(color: Colors.red)),
                ),
              ),
              Text(
                "Combination Breakfast",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 400,
                child: breakfastAsync.when(
                  data: (foodItems) => ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: foodItems.length,
                    itemBuilder: (context, index) {
                      final food = foodItems[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                food['image_url'],
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    food['name'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.king_bed,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                          Text(
                                            '5 kcal',
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.label,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                          Text(
                                            '300 gm',
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '₹${food['price']}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade600,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text("Error: $err")),
                ),
              ),
              Text(
                "Recommended Breakfast",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 270,
                child: recommendedAsync.when(
                  data: (foodItems) => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: foodItems.length,
                    itemBuilder: (context, index) {
                      final food = foodItems[index];
                      return Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipOval(
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    color: Colors.transparent,
                                    child: Image.network(
                                      food['image_url'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              food['name'],
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 4),
                            Text(
                              '₹24',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 2),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.king_bed,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    Text(
                                      '5 kcal',
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.label,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    Text(
                                      '300 gm',
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 2),
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade600,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text("Error: $err")),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final supabase = Supabase.instance.client;
    await supabase.auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Splash()),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20, right: 50),
          filled: true,
          fillColor: Colors.grey[900],
          suffixIcon: Icon(
            Icons.search,
            color: Colors.white,
            size: 25,
          ),
          hintText: "Search...",
          hintStyle: TextStyle(color: Colors.white60),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // 🔹 Promo Banner (Carousel)
  Widget _buildPromoBanner() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: 200,
        child: PageView(
          controller: _pageController,
          children: [
            _buildPromoCard("assets/select_category/banner.png"),
            _buildPromoCard("assets/select_category/banner.png"),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoCard(String imagePath) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Center(
        child: SmoothPageIndicator(
          controller: _pageController,
          count: 2,
          effect: ScrollingDotsEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: Colors.white,
            dotColor: Colors.grey,
          ),
        ),
      ),
    );
  }
}
