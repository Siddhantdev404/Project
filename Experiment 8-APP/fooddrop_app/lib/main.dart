import 'package:flutter/material.dart';

// --- MAIN APPLICATION STARTUP ---
void main() {
  runApp(const FoodDeliveryApp());
}

// Mock data structure for restaurants
class Restaurant {
  final String name;
  final String cuisine;
  final String rating;
  final String deliveryTime;
  final Color color;

  Restaurant({
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.deliveryTime,
    required this.color,
  });
}

// Mock list of restaurants
final List<Restaurant> mockRestaurants = [
  Restaurant(
    name: 'The Italian Bistro',
    cuisine: 'Pasta, Pizza',
    rating: '4.7',
    deliveryTime: '30-40 min',
    color: Colors.blueGrey,
  ),
  Restaurant(
    name: 'Spicy Wok House',
    cuisine: 'Chinese, Asian',
    rating: '4.5',
    deliveryTime: '20-30 min',
    color: Colors.red,
  ),
  Restaurant(
    name: 'Burger King',
    cuisine: 'Fast Food',
    rating: '4.1',
    deliveryTime: '45-55 min',
    color: Colors.orange,
  ),
  Restaurant(
    name: 'Healthy Greens',
    cuisine: 'Salads, Bowls',
    rating: '4.9',
    deliveryTime: '15-25 min',
    color: Colors.green,
  ),
  Restaurant(
    name: 'Mexican Fiesta',
    cuisine: 'Tacos, Burritos',
    rating: '4.6',
    deliveryTime: '35-45 min',
    color: Colors.teal,
  ),
];

// --- MAIN WIDGET ---
class FoodDeliveryApp extends StatelessWidget {
  const FoodDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodDrop Assignment Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.deepOrange,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
      ),
      // Define named routes for Stack Navigation
      initialRoute: '/',
      routes: {
        '/': (context) => const MainNavigator(),
        '/restaurant_detail': (context) => const RestaurantDetailScreen(),
        '/cart': (context) => const CartScreen(),
        // Note: '/settings' or other Drawer links can also be added here.
      },
    );
  }
}

// --- MAIN NAVIGATION CONTAINER (Handles Tabs and Drawer) ---
class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0;

  // List of primary screens for the Bottom Tab Bar
  final List<Widget> _tabScreens = <Widget>[
    const HomeScreen(),
    const SearchScreen(),
    const OrdersScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FoodDrop',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Global Cart Action (Accessible from all tabs)
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Demonstrates global stack navigation
              Navigator.of(context).pushNamed('/cart');
            },
          ),
        ],
      ),

      // 1. DRAWER NAVIGATION IMPLEMENTATION (Secondary Links)
      drawer: const AppDrawer(),

      // 2. TAB-BASED NAVIGATION IMPLEMENTATION (Screen Content)
      body: _tabScreens.elementAt(_selectedIndex),

      // 3. TAB-BASED NAVIGATION IMPLEMENTATION (Bottom Bar)
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// --- DRAWER WIDGET (The Side Menu - Secondary Navigation) ---
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _showSnackbar(BuildContext context, String message) {
    Navigator.pop(context); // Close the drawer first
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // UPDATED: Name and Email set to Siddhant Kerkar
          const UserAccountsDrawerHeader(
            accountName: Text(
              'Siddhant Kerkar',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text('siddhant.kerkar.dev@email.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.restaurant, color: Colors.deepOrange, size: 40),
            ),
            decoration: BoxDecoration(color: Colors.deepOrange),
          ),

          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Payment Methods'),
            onTap: () =>
                _showSnackbar(context, 'Navigating to Payment Settings...'),
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Saved Addresses'),
            onTap: () => _showSnackbar(context, 'Navigating to Addresses...'),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            onTap: () =>
                _showSnackbar(context, 'Navigating to Support Center...'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Log Out', style: TextStyle(color: Colors.red)),
            onTap: () => _showSnackbar(context, 'Successfully logged out!'),
          ),
        ],
      ),
    );
  }
}

// --- TAB SCREEN 1: HOME SCREEN (Showcases Discoverability) ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // 1. Sticky Search/Location Bar
        SliverAppBar(
          automaticallyImplyLeading: false,
          pinned: true,
          toolbarHeight: 80,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red),
                const SizedBox(width: 8),
                const Text(
                  'Deliver to: 123 Main St.',
                  style: TextStyle(fontSize: 16),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Change',
                    style: TextStyle(color: Colors.deepOrange),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 2. Categories List (Horizontal Scrolling)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              'Top Categories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                _buildCategoryCard(Icons.local_pizza, 'Pizza', Colors.orange),
                _buildCategoryCard(Icons.ramen_dining, 'Asian', Colors.green),
                _buildCategoryCard(Icons.local_cafe, 'Coffee', Colors.brown),
                _buildCategoryCard(Icons.fastfood, 'Burgers', Colors.red),
                _buildCategoryCard(Icons.icecream, 'Dessert', Colors.pink),
              ],
            ),
          ),
        ),

        // 3. Popular Restaurants List (Vertical Scrolling)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Popular Near You',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final restaurant = mockRestaurants[index];
            return _buildRestaurantCard(context, restaurant);
          }, childCount: mockRestaurants.length),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 50),
        ), // Extra space at bottom
      ],
    );
  }

  Widget _buildCategoryCard(IconData icon, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Icon(icon, size: 40, color: color),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildRestaurantCard(BuildContext context, Restaurant restaurant) {
    return InkWell(
      onTap: () {
        // Demonstrates stack navigation within the tab
        Navigator.of(
          context,
        ).pushNamed('/restaurant_detail', arguments: restaurant);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mock Image Placeholder
            Container(
              height: 150,
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: restaurant.color.withOpacity(0.2),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.restaurant_menu,
                  size: 50,
                  color: restaurant.color,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant.cuisine,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(
                        ' ${restaurant.rating} • ',
                        style: TextStyle(fontSize: 14),
                      ),
                      Icon(Icons.timer, color: Colors.deepOrange, size: 16),
                      Text(
                        ' ${restaurant.deliveryTime}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- TAB SCREEN 2: SEARCH SCREEN (Showcases Filters and Search UI) ---
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          const TextField(
            decoration: InputDecoration(
              labelText: 'Search for dishes or restaurants',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Trending Searches',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Trending Chips
          Wrap(
            spacing: 8.0,
            children: [
              _buildChip('Pizza', Icons.local_pizza),
              _buildChip('Vegan', Icons.eco),
              _buildChip('Fast Food', Icons.fastfood),
              _buildChip('Dessert', Icons.cake),
            ],
          ),
          const SizedBox(height: 20),

          const Text(
            'Recommended Cuisines',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildCuisineTile('Chinese', '120+ restaurants'),
                _buildCuisineTile('Italian', '95+ restaurants'),
                _buildCuisineTile('Indian', '80+ restaurants'),
                _buildCuisineTile('Japanese', '60+ restaurants'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, color: Colors.deepOrange, size: 18),
      label: Text(label),
      // ignore: deprecated_member_use
      backgroundColor: Colors.deepOrange.withOpacity(0.1),
    );
  }

  Widget _buildCuisineTile(String title, String subtitle) {
    return ListTile(
      leading: const Icon(Icons.restaurant, color: Colors.deepOrange),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}

// --- TAB SCREEN 3: ORDERS SCREEN (Nested Top Tabs) ---
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: TabBar(
            indicatorColor: Colors.deepOrange,
            labelColor: Colors.deepOrange,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Active (1)', icon: Icon(Icons.timer)),
              Tab(text: 'History (5)', icon: Icon(Icons.check_circle)),
            ],
          ),
        ),
        body: TabBarView(
          children: [_buildActiveOrders(), _buildOrderHistory()],
        ),
      ),
    );
  }

  // Mock Active Orders List
  Widget _buildActiveOrders() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Card(
          color: Colors.yellow.shade100,
          elevation: 4,
          child: ListTile(
            leading: const Icon(Icons.motorcycle, color: Colors.black),
            title: const Text(
              'Order #12345',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              'Spicy Wok House - Estimated arrival in 15 min',
            ),
            trailing: TextButton(
              onPressed: () {},
              child: const Text('Track Live'),
            ),
          ),
        ),
        const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Text(
              'You have 1 active delivery.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  // Mock Order History List
  Widget _buildOrderHistory() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildOrderHistoryTile(
          'The Italian Bistro',
          'Delivered 2 days ago',
          '₹ 850.00',
        ),
        _buildOrderHistoryTile(
          'Burger King',
          'Delivered 5 days ago',
          '₹ 420.00',
        ),
        _buildOrderHistoryTile(
          'Healthy Greens',
          'Delivered 1 week ago',
          '₹ 1100.00',
        ),
        _buildOrderHistoryTile(
          'Mexican Fiesta',
          'Delivered 2 weeks ago',
          '₹ 930.00',
        ),
      ],
    );
  }

  Widget _buildOrderHistoryTile(String restaurant, String date, String price) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.restore, color: Colors.grey),
        title: Text(restaurant),
        subtitle: Text(date),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 20),
              ),
              child: const Text(
                'Reorder',
                style: TextStyle(color: Colors.deepOrange),
              ),
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}

// --- TAB SCREEN 4: PROFILE SCREEN (Showcases Account Details) ---
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Profile Header
        const Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.deepOrange,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              SizedBox(height: 10),
              // UPDATED: Name set to Siddhant Kerkar
              Text(
                'Siddhant Kerkar',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'Loyalty Member since 2023',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        const Divider(height: 40),

        // Loyalty Points Card
        Card(
          color: Colors.deepOrange.shade50,
          child: const ListTile(
            leading: Icon(Icons.star_rate, color: Colors.deepOrange, size: 30),
            title: Text('Loyalty Points'),
            subtitle: Text(
              'Current Balance: 1,500 points (Claim Free Dessert!)',
            ),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
        const SizedBox(height: 20),

        // Account Details List
        const Text(
          'Account Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ListTile(
          leading: const Icon(Icons.email),
          // UPDATED: Email set to Siddhant's mock email
          title: const Text('siddhant.kerkar.dev@email.com'),
          subtitle: const Text('Email Address'),
          trailing: const Icon(Icons.edit),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.phone),
          title: const Text('+91 98765 43210'),
          subtitle: const Text('Phone Number'),
          trailing: const Icon(Icons.edit),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.credit_card),
          title: const Text('Manage Payment Info'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
      ],
    );
  }
}

// --- STACK NAVIGATION TARGET 1: RESTAURANT DETAIL SCREEN ---
class RestaurantDetailScreen extends StatelessWidget {
  const RestaurantDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the passed argument (Restaurant object)
    final restaurant = ModalRoute.of(context)!.settings.arguments as Restaurant;

    return Scaffold(
      appBar: AppBar(title: Text(restaurant.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mock Restaurant Banner
            Container(
              height: 200,
              // ignore: deprecated_member_use
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: restaurant.color.withOpacity(0.5),
              ),
              child: Center(
                child: Text(
                  'Restaurant Banner Image\n(Simulated)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant.cuisine,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.deepOrange,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      Text(' ${restaurant.rating} Rating • '),
                      Icon(Icons.timer, color: Colors.deepOrange, size: 20),
                      Text(' ${restaurant.deliveryTime}'),
                    ],
                  ),
                  const Divider(height: 30),

                  // Menu Section
                  const Text(
                    'Popular Dishes',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  _buildMenuItem(
                    'Signature Pasta',
                    'Creamy sauce, fresh basil.',
                    '₹ 450',
                  ),
                  _buildMenuItem(
                    'Classic Margherita',
                    'Tomato, mozzarella, olive oil.',
                    '₹ 380',
                  ),
                  _buildMenuItem(
                    'Garlic Breadsticks',
                    'Side order, served with marinara.',
                    '₹ 150',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Added to Cart! Navigating to Cart...'),
              ),
            );
            // Simulating adding to cart and navigating to cart screen
            Navigator.of(context).pushNamed('/cart');
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 55),
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'View Cart (3 items) - ₹ 1,280',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String name, String description, String price) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: Text(
          price,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
        onTap: () {},
      ),
    );
  }
}

// --- STACK NAVIGATION TARGET 2: CART SCREEN ---
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart, size: 100, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'This is the Cart Screen',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const Text(
              'Demonstrates Stack Navigation from the AppBar.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Return to the previous screen (Home/Detail Screen)
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }
}
