FoodDrop App: Tab and Drawer Navigation Implementation
This project is a Flutter demonstration designed to fulfill the requirement of implementing tab-based navigation (using a bottom bar) and drawer navigation (using a side menu) within a single application structure, presented in the context of a mock food delivery service called FoodDrop.

✨ Core Assignment Objectives Demonstrated
Navigation Type

Flutter Widget / Class

Implementation Detail

Tab-Based

MainNavigator & BottomNavigationBar

The main screen uses a BottomNavigationBar to switch between Home, Search, Orders, and Profile screens. This is the primary navigation method.

Drawer

AppDrawer

A side menu accessed via the hamburger icon (Scaffold's drawer property) on the main screen. It provides secondary navigation links like 'Payment Methods' and 'Help & Support'.

Stack (Bonus)

Named Routes (Navigator.of(context).pushNamed)

Demonstrates navigating to detailed, dedicated screens like the Restaurant Detail Screen and the Cart Screen, which sit on top of the main tab structure.

📦 Application Structure Overview
The app is built using a clear, component-based architecture:

1. Main Navigation Container
FoodDeliveryApp (Root): Initializes the application theme (Deep Orange) and defines the global named routes (/, /restaurant_detail, /cart).

MainNavigator (StatefulWidget): This is the heart of the navigation.

It maintains the _selectedIndex state for the tabs.

It hosts the AppBar, the AppDrawer (side menu), and the BottomNavigationBar (tab menu).

2. Tab Screens (Primary Content)
These are the four primary screens switched via the bottom bar:

HomeScreen: The discovery page, featuring a sticky location bar (SliverAppBar), horizontal category lists, and vertical Restaurant Cards. Tapping a card triggers Stack Navigation to the detail screen.

SearchScreen: Displays search UI elements like text fields and filter chips (Wrap widget).

OrdersScreen: Demonstrates nested Tab Navigation by using a DefaultTabController to switch between "Active" and "History" orders.

ProfileScreen: Displays mock user account information.

3. Drawer Menu (AppDrawer)
Contains a styled UserAccountsDrawerHeader with user information (Siddhant Kerkar).

Uses ListTile widgets for secondary navigation links. Actions here typically close the drawer (Navigator.pop(context)) and show a confirmation (SnackBar).

4. Stack Screens (Detail & Cart)
These are independent screens accessed via routes:

RestaurantDetailScreen: Accessed by tapping a restaurant card. It retrieves the specific Restaurant data passed to it using ModalRoute.of(context).settings.arguments.

CartScreen: Accessed from the global cart icon in the AppBar.

🛠️ Key Implementation Code Snippets
Tab-Based Navigation (Bottom Bar)
The tab items and their click handlers are defined in _MainNavigatorState:

// The array of screens corresponding to the tabs
final List<Widget> _tabScreens = <Widget>[
    const HomeScreen(),
    const SearchScreen(),
    const OrdersScreen(),
    const ProfileScreen(),
];

// ... inside the build method:
bottomNavigationBar: BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
        // ... items defined here
    ],
    currentIndex: _selectedIndex, // Tracks which tab is active
    onTap: _onItemTapped,       // Updates _selectedIndex on tap
),
body: _tabScreens.elementAt(_selectedIndex), // Shows the active screen

Drawer Navigation
The drawer is attached directly to the Scaffold in the MainNavigator:

// ... inside the MainNavigator build method:
drawer: const AppDrawer(),

This automatically provides the hamburger icon in the AppBar to open the side menu.