import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final FirebaseFirestore db = FirebaseFirestore.instance;

List<String> sliderImages = [
  "images/slider-1.png",
  "images/slider-2.png",
  "images/slider-3.png",
  "images/slider-4.png",
  "images/slider-5.png",
];
List<String> dishesDinner = [
  "images/dinner-dish-1.png",
  "images/dinner-dish-2.png",
  "images/dinner-dish-3.png",
  "images/dinner-dish-4.png",
  "images/dish-0.png",
];
List<String> dishesLunch = [
  "images/lunch-dish-1.png",
  "images/lunch-dish-2.png",
  "images/lunch-dish-3.png",
  "images/lunch-dish-4.png",
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}

/// Listens to Firebase Auth state and routes accordingly.
/// - Not signed in → LoginPage
/// - Signed in     → RestaurantHomePage
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // While Firebase checks auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF181818),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFD5AE33)),
            ),
          );
        }

        // User is signed in
        if (snapshot.hasData && snapshot.data != null) {
          return const RestaurantHomePage();
        }

        // User is NOT signed in
        return const LoginPage();
      },
    );
  }
}

class RestaurantHomePage extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const RestaurantHomePage({super.key, this.userData});

  @override
  _RestaurantHomePageState createState() => _RestaurantHomePageState();
}

class _RestaurantHomePageState extends State<RestaurantHomePage> {
  int index = 0;
  int pageIndex = 0;
  Timer? T;

  Map<String, dynamic>? _userData;
  bool _loadingUser = false;

  @override
  void initState() {
    super.initState();
    startTimer();
    _userData = widget.userData;
  }

  void startTimer() {
    T?.cancel();
    T = Timer.periodic(const Duration(seconds: 3), (_) {
      setState(() {
        index = (index + 1) % sliderImages.length;
      });
    });
  }

  @override
  void dispose() {
    T?.cancel();
    super.dispose();
  }

  /// Signs the user out and returns to LoginPage via AuthGate
  Future<void> _signOut() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(235, 235, 230, 1),
      body: pages(pageIndex),
    );
  }

  Widget homePage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildNavbar(),
          buildSlider(),
          Container(height: 20, color: const Color(0xFFD5AE33)),
          Container(
            color: Color(0xFF181818),
            height: 70,
            child: Row(
              children: [
                _buildTab(const Text("Home", style: TextStyle(fontFamily: "Alura", fontSize: 20, color: Color(0xFFD5AE33))), 0),
                _buildTab(const Text("Offers", style: TextStyle(fontFamily: "Alura", fontSize: 20, color: Color(0xFFD5AE33))), 1),
                _buildTab(const Text("Profile", style: TextStyle(fontFamily: "Alura", fontSize: 20, color: Color(0xFFD5AE33))), 2),
                _buildTab(const Text("About", style: TextStyle(fontFamily: "Alura", fontSize: 20, color: Color(0xFFD5AE33))), 3),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildReserveBlock(),
          const SizedBox(height: 20),
          Container(height: 3, decoration: const BoxDecoration(color: Color(0xFFD5AE33))),
          Container(
            height: 70,
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(color: Color(0xFF221919)),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                height: 100,
                child: Text("   Dinner", style: TextStyle(color: Color(0xFFD5AE33), fontWeight: FontWeight.normal, fontSize: 40, fontFamily: "Alura")),
              ),
            ),
          ),
          _buildDishMenu(dishesDinner),
          Container(height: 20, color: const Color(0xFFD5AE33)),
          const SizedBox(height: 40),
          Container(height: 3, decoration: const BoxDecoration(color: Color(0xFFD5AE33))),
          Container(
            height: 70,
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(color: Color(0xFF221919)),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                height: 100,
                child: Text("   Lunch", style: TextStyle(color: Color(0xFFD5AE33), fontWeight: FontWeight.normal, fontSize: 40, fontFamily: "Alura")),
              ),
            ),
          ),
          _buildDishMenu(dishesLunch),
          Container(height: 20, color: const Color(0xFFD5AE33)),
          const SizedBox(height: 40),
          Container(height: 3, decoration: const BoxDecoration(color: Color(0xFFD5AE33))),
          Container(
            height: 70,
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(color: Color(0xFF221919)),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                height: 100,
                child: Text("   Breakfast", style: TextStyle(color: Color(0xFFD5AE33), fontWeight: FontWeight.normal, fontSize: 40, fontFamily: "Alura")),
              ),
            ),
          ),
          _buildDishMenu(dishesLunch),
          Container(height: 20, color: const Color(0xFFD5AE33)),
          const SizedBox(height: 50),
          _buildChefSpecial(),
          const SizedBox(height: 20),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget profilePage() {
    final user = FirebaseAuth.instance.currentUser;

    // Pull fields from Firestore doc, fallback to Firebase Auth or placeholder
    final String displayName = _userData?['name'] ?? _userData?['fullName'] ?? user?.displayName ?? 'Guest';
    final String email = _userData?['email'] ?? user?.email ?? '';
    final String phone = _userData?['phone'] ?? _userData?['phoneNumber'] ?? '—';
    final String city = _userData?['city'] ?? _userData?['location'] ?? '—';
    final String memberSince = _userData?['memberSince'] ?? _userData?['createdAt'] ?? '—';
    final int reservations = (_userData?['reservations'] as num?)?.toInt() ?? 0;
    final int offersUsed = (_userData?['offersUsed'] as num?)?.toInt() ?? 0;
    final int favourites = (_userData?['favourites'] as num?)?.toInt() ?? 0;

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildNavbar(),
          Container(
            color: const Color(0xFF181818),
            height: 70,
            child: Row(
              children: [
                _buildTab(const Text("Home", style: TextStyle(fontFamily: "Alura", fontSize: 20, color: Color(0xFFD5AE33))), 0),
                _buildTab(const Text("Offers", style: TextStyle(fontFamily: "Alura", fontSize: 20, color: Color(0xFFD5AE33))), 1),
                _buildTab(const Text("Profile", style: TextStyle(fontFamily: "Alura", fontSize: 20, color: Color(0xFFD5AE33))), 2),
                _buildTab(const Text("About", style: TextStyle(fontFamily: "Alura", fontSize: 20, color: Color(0xFFD5AE33))), 3),
              ],
            ),
          ),

          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 25),
            color: const Color(0xFF181818),
            child: const Center(
              child: Text(
                "My Profile",
                style: TextStyle(fontFamily: "Alura", fontSize: 42, color: Color(0xFFD5AE33)),
              ),
            ),
          ),

          Container(height: 3, color: const Color(0xFFD5AE33)),

          // Avatar + Name
          Container(
            color: const Color(0xFF181818),
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: _loadingUser
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFD5AE33)))
                : Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFFD5AE33).withOpacity(0.15),
                  child: const Icon(Icons.account_circle, size: 90, color: Color(0xFFD5AE33)),
                ),
                const SizedBox(height: 16),
                Text(
                  displayName,
                  style: const TextStyle(fontFamily: "Alura", fontSize: 30, color: Color(0xFFD5AE33)),
                ),
                const SizedBox(height: 6),
                Text(
                  email,
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                ),
              ],
            ),
          ),

          Container(height: 3, color: const Color(0xFFD5AE33)),

          // Account Info Section
          Container(
            height: 70,
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(color: Color(0xFF221919)),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("   Account Info",
                  style: TextStyle(color: Color(0xFFD5AE33), fontSize: 40, fontFamily: "Alura")),
            ),
          ),

          Container(
            color: const Color(0xFF181818),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: _loadingUser
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFD5AE33)))
                : Column(
              children: [
                _buildProfileInfoRow(Icons.person, "Full Name", displayName),
                const SizedBox(height: 15),
                _buildProfileInfoRow(Icons.email, "Email", email),
                const SizedBox(height: 15),
                _buildProfileInfoRow(Icons.phone, "Phone", phone),
                const SizedBox(height: 15),
                _buildProfileInfoRow(Icons.location_on, "City", city),
                const SizedBox(height: 15),
                _buildProfileInfoRow(Icons.cake, "Member Since", memberSince),
              ],
            ),
          ),

          Container(height: 3, color: const Color(0xFFD5AE33)),

          // My Activity Section
          Container(
            height: 70,
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(color: Color(0xFF221919)),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("   My Activity",
                  style: TextStyle(color: Color(0xFFD5AE33), fontSize: 40, fontFamily: "Alura")),
            ),
          ),

          Container(
            color: const Color(0xFF181818),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard(reservations.toString(), "Reservations"),
                _buildStatCard(offersUsed.toString(), "Offers Used"),
                _buildStatCard(favourites.toString(), "Favourites"),
              ],
            ),
          ),

          Container(height: 20, color: const Color(0xFFD5AE33)),
          const SizedBox(height: 40),

          // Sign Out button
          GestureDetector(
            onTap: _signOut,
            child: Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF221919),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xFFD5AE33), width: 1.5),
              ),
              child: const Center(
                child: Text("Sign Out",
                    style: TextStyle(fontFamily: "Alura", fontSize: 22, color: Color(0xFFD5AE33))),
              ),
            ),
          ),

          const SizedBox(height: 40),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildProfileInfoRow(IconData icon, String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF221919),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD5AE33), width: 1.5),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFD5AE33).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFFD5AE33), size: 22),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: "Alura",
                  fontSize: 20,
                  color: Color(0xFFD5AE33),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String count, String label) {
    return Container(
      width: 100,
      height: 90,
      decoration: BoxDecoration(
        color: const Color(0xFF221919),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD5AE33), width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count,
            style: const TextStyle(
              fontFamily: "Alura",
              fontSize: 32,
              color: Color(0xFFD5AE33),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget offersPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildNavbar(),
          Container(
            color: const Color(0xFF181818),
            height: 70,
            child: Row(
              children: [
                _buildTab(const Text("Home", style: TextStyle(fontFamily: "Alura", fontSize: 20, color: Color(0xFFD5AE33))), 0),
                _buildTab(const Text("Offers", style: TextStyle(fontFamily: "Alura", fontSize: 20, color: Color(0xFFD5AE33))), 1),
                _buildTab(const Text("Profile", style: TextStyle(fontFamily: "Alura", fontSize: 20, color: Color(0xFFD5AE33))), 2),
                _buildTab(const Text("About", style: TextStyle(fontFamily: "Alura", fontSize: 20, color: Color(0xFFD5AE33))), 3),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 25),
            color: const Color(0xFF181818),
            child: const Center(
              child: Text(
                "Today's Offers",
                style: TextStyle(fontFamily: "Alura", fontSize: 42, color: Color(0xFFD5AE33)),
              ),
            ),
          ),
          Container(height: 3, color: const Color(0xFFD5AE33)),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("  Special Discounts", style: TextStyle(fontFamily: "Alura", fontSize: 30, color: Color(0xFFD5AE33))),
                const SizedBox(height: 15),
                _buildOfferCard("Dinner for Two", "Get 20% off any two dinner dishes every Monday & Tuesday.", "20% OFF"),
                const SizedBox(height: 15),
                _buildOfferCard("Lunch Special", "Enjoy a free dessert with every lunch order above 200 EGP.", "FREE DESSERT"),
                const SizedBox(height: 15),
                _buildOfferCard("Weekend Brunch", "30% off on all breakfast items every Friday morning.", "30% OFF"),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Container(height: 3, color: const Color(0xFFD5AE33)),
          Container(
            height: 70,
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(color: Color(0xFF221919)),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("   Meal Deals", style: TextStyle(color: Color(0xFFD5AE33), fontSize: 40, fontFamily: "Alura")),
            ),
          ),
          Container(
            color: const Color(0xFFEBEBE6),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildMealDealRow("Dinner for 2", "images/dinner-dish-1.png", "2 mains + 1 dessert + drinks\nOnly 350 EGP"),
                const SizedBox(height: 15),
                _buildMealDealRow("Family Feast", "images/dinner-dish-2.png", "4 mains + 2 sides + bread\nOnly 700 EGP"),
                const SizedBox(height: 15),
                _buildMealDealRow("Lunch Combo", "images/lunch-dish-1.png", "1 main + soup + soft drink\nOnly 180 EGP"),
              ],
            ),
          ),
          Container(height: 20, color: const Color(0xFFD5AE33)),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () => setState(() => pageIndex = 5),
            child: Container(
              width: 220,
              height: 55,
              decoration: BoxDecoration(
                color: const Color(0xFFD5AE33),
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
              ),
              child: const Center(
                child: Text("Reserve a Table", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "Alura")),
              ),
            ),
          ),
          const SizedBox(height: 40),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget aboutPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildNavbar(),
          Container(
            color: const Color(0xFF181818),
            height: 70,
            child: Row(
              children: [
                _buildTab(const Text("Home", style: TextStyle(fontFamily: "Alura", fontSize: 20, color: Color(0xFFD5AE33))), 0),
                _buildTab(const Text("Offers", style: TextStyle(fontFamily: "Alura", fontSize: 20, color: Color(0xFFD5AE33))), 1),
                _buildTab(const Text("Profile", style: TextStyle(fontFamily: "Alura", fontSize: 20, color: Color(0xFFD5AE33))), 2),
                _buildTab(const Text("About", style: TextStyle(fontFamily: "Alura", fontSize: 20, color: Color(0xFFD5AE33))), 3),
              ],
            ),
          ),

          // ── HERO BANNER ──
          Stack(
            children: [
              Container(
                height: 240,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/special-bg.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.35),
                      Colors.black.withOpacity(0.80),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 240,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Blackwood",
                      style: TextStyle(
                        fontFamily: "Alura",
                        fontSize: 52,
                        color: Color(0xFFD5AE33),
                        letterSpacing: 3,
                        shadows: [Shadow(color: Colors.black, blurRadius: 12)],
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Fine Dining • Cairo • Since 2010",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _AboutDividerDot(),
                        SizedBox(width: 8),
                        Text("Est. 2010", style: TextStyle(color: Color(0xFFD5AE33), fontSize: 13)),
                        SizedBox(width: 8),
                        _AboutDividerDot(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── STATS ROW ──
          Container(
            color: const Color(0xFF221919),
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAboutStat("15+", "Years Open"),
                _buildAboutStatDivider(),
                _buildAboutStat("200+", "Menu Items"),
                _buildAboutStatDivider(),
                _buildAboutStat("50K+", "Happy Guests"),
                _buildAboutStatDivider(),
                _buildAboutStat("4.9★", "Rating"),
              ],
            ),
          ),

          Container(height: 3, color: const Color(0xFFD5AE33)),

          // ── OUR STORY ──
          _buildAboutSectionHeader("Our Story"),
          Container(
            color: const Color(0xFF181818),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              children: [
                const Text(
                  "Blackwood was born from a passion for fine dining and warm hospitality. "
                      "Founded in 2010 in the heart of Downtown Cairo, we have spent over a decade "
                      "crafting unforgettable experiences for our guests.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.85),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    border: Border(left: BorderSide(color: const Color(0xFFD5AE33), width: 3)),
                    color: const Color(0xFF221919),
                  ),
                  child: const Text(
                    "\"Every dish tells a story — rooted in tradition, elevated by innovation.\"",
                    style: TextStyle(
                      color: Color(0xFFD5AE33),
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(height: 3, color: const Color(0xFFD5AE33)),

          // ── TIMELINE ──
          _buildAboutSectionHeader("Our Journey"),
          Container(
            color: const Color(0xFF181818),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                _buildTimelineItem("2010", "Blackwood opens its first location in Downtown Cairo with just 12 tables."),
                _buildTimelineItem("2013", "Awarded \"Best Fine Dining\" by Cairo Food Critics Association."),
                _buildTimelineItem("2017", "Expanded to a second floor, doubling capacity to serve more guests."),
                _buildTimelineItem("2021", "Launched our signature Chef's Tasting Menu — a sold-out experience weekly."),
                _buildTimelineItem("2024", "Introduced our digital ordering app for a seamless modern experience."),
              ],
            ),
          ),

          Container(height: 3, color: const Color(0xFFD5AE33)),

          // ── OUR VALUES ──
          _buildAboutSectionHeader("Our Values"),
          Container(
            color: const Color(0xFF181818),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                _buildValueCard(Icons.star_rounded, "Quality", "Only the freshest ingredients make it to your plate."),
                const SizedBox(height: 15),
                _buildValueCard(Icons.favorite_rounded, "Passion", "Every recipe is crafted with love and dedication."),
                const SizedBox(height: 15),
                _buildValueCard(Icons.people_rounded, "Hospitality", "You are family the moment you walk through our doors."),
                const SizedBox(height: 15),
                _buildValueCard(Icons.eco_rounded, "Sustainability", "We source locally and cook responsibly."),
              ],
            ),
          ),

          Container(height: 3, color: const Color(0xFFD5AE33)),

          // ── MEET THE TEAM ──
          _buildAboutSectionHeader("Meet The Team"),
          Container(
            color: const Color(0xFF181818),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                _buildTeamCard(Icons.restaurant, "Chef Omar Khalil", "Executive Chef", "15 years of culinary mastery across Egypt, France & Italy."),
                const SizedBox(height: 14),
                _buildTeamCard(Icons.manage_accounts, "Nour El-Sayed", "Restaurant Manager", "Ensures every guest leaves with a smile and a full heart."),
                const SizedBox(height: 14),
                _buildTeamCard(Icons.wine_bar, "Karim Adel", "Head Sommelier", "Curates our world-class beverage and mocktail collection."),
              ],
            ),
          ),

          Container(height: 3, color: const Color(0xFFD5AE33)),

          // ── VISIT US ──
          _buildAboutSectionHeader("Visit Us"),
          Container(
            color: const Color(0xFF181818),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              children: [
                _buildInfoRow(Icons.location_on, "Downtown Cairo, Egypt"),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.access_time, "Open Daily  •  10 AM – 12 AM"),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.phone, "+20 100 000 0000"),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.email, "hello@blackwood.eg"),
                const SizedBox(height: 28),
                // Map placeholder
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF221919),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFD5AE33), width: 1.5),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map_outlined, color: Color(0xFFD5AE33), size: 40),
                      SizedBox(height: 10),
                      Text("Downtown Cairo", style: TextStyle(color: Color(0xFFD5AE33), fontFamily: "Alura", fontSize: 18)),
                      SizedBox(height: 4),
                      Text("Tap to open in Maps", style: TextStyle(color: Colors.white38, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(height: 3, color: const Color(0xFFD5AE33)),
          const SizedBox(height: 36),

          // ── RESERVE BUTTON ──
          GestureDetector(
            onTap: () {
              setState(() {
                pageIndex = 5;
              });
            },
            child: Container(
              width: 240,
              height: 58,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD5AE33), Color(0xFFB8922A)],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(color: Color(0x55D5AE33), blurRadius: 14, offset: Offset(0, 6)),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.table_restaurant, color: Colors.black, size: 20),
                  SizedBox(width: 10),
                  Text(
                    "Reserve a Table",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Alura",
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 44),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildAboutSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: const BoxDecoration(color: Color(0xFF221919)),
      child: Row(
        children: [
          Container(width: 4, height: 32, color: const Color(0xFFD5AE33)),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFD5AE33),
              fontSize: 30,
              fontFamily: "Alura",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: "Alura",
            fontSize: 26,
            color: Color(0xFFD5AE33),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 11),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAboutStatDivider() {
    return Container(width: 1, height: 40, color: const Color(0xFFD5AE33).withOpacity(0.3));
  }

  Widget _buildTimelineItem(String year, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 48,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFD5AE33),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    year,
                    style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(width: 2, height: 36, color: const Color(0xFFD5AE33).withOpacity(0.3)),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                description,
                style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamCard(IconData icon, String name, String role, String bio) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF221919),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD5AE33).withOpacity(0.5), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFD5AE33).withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD5AE33), width: 1.5),
            ),
            child: Icon(icon, color: const Color(0xFFD5AE33), size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Color(0xFFD5AE33), fontFamily: "Alura", fontSize: 18)),
                const SizedBox(height: 2),
                Text(role, style: const TextStyle(color: Colors.white54, fontSize: 12, fontStyle: FontStyle.italic)),
                const SizedBox(height: 8),
                Text(bio, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueCard(IconData icon, String title, String description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF221919),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD5AE33), width: 1.5),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFD5AE33).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFFD5AE33), size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: "Alura",
                    fontSize: 24,
                    color: Color(0xFFD5AE33),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFD5AE33).withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFFD5AE33), size: 22),
        ),
        const SizedBox(width: 16),
        Text(
          text,
          style: const TextStyle(color: Colors.white70, fontSize: 15),
        ),
      ],
    );
  }

  Widget pages(int pageindex) {
    if (pageindex == 0) return homePage();
    else if (pageindex == 1) return offersPage();
    else if (pageindex == 2) return profilePage();
    else if (pageindex == 3) return aboutPage();
    else return const Center(child: Text("Invalid page", style: TextStyle(fontSize: 42)));
  }

  Widget _buildNavbar() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF181818),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Profile avatar — tapping goes to profile page
                  GestureDetector(
                    onTap: () => setState(() => pageIndex = 2),
                    child: const CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFFD5AE33),
                      child: Icon(Icons.account_circle, size: 40, color: Color(0xFF181818)),
                    ),
                  ),
                  const Center(
                    child: Text("Blackwood", style: TextStyle(fontFamily: "Alura", fontSize: 50, color: Color(0xFFD5AE33))),
                  ),
                  const SizedBox(width: 56),
                ],
              ),
            ),
            Container(height: 2, decoration: const BoxDecoration(color: Color(0xFFD5AE33))),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(Text title, int tabIndex) {
    bool isSelected = pageIndex == tabIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => pageIndex = tabIndex),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? const Color(0xFFD5AE33) : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Center(child: title),
        ),
      ),
    );
  }

  Widget buildSlider() {
    return SizedBox(
      height: 420,
      child: Stack(
        children: [
          ClipRRect(
            child: Image.asset(
              sliderImages[index],
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.75), Colors.transparent],
              ),
            ),
          ),
          const Positioned(
            left: 25,
            bottom: 35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Luxury Dining", style: TextStyle(color: Color(0xFFD5AE33), fontSize: 42, fontFamily: "Alura")),
                SizedBox(height: 8),
                Text("Experience elegance in every meal", style: TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReserveBlock() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Experience the finest dining in the heart of the city. Join us for an unforgettable evening.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFFD5AE33), fontWeight: FontWeight.bold, fontSize: 35, fontFamily: "Alura"),
          ),
          const SizedBox(height: 25),
          GestureDetector(
            onTap: () => setState(() => pageIndex = 5),
            child: Container(
              width: 220,
              height: 55,
              decoration: BoxDecoration(
                color: const Color(0xFFD5AE33),
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
              ),
              child: const Center(
                child: Text("Reserve a Table", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "Alura")),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDishMenu(List<String> dishes) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("images/wood_texture.png"), fit: BoxFit.cover),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (int i = 0; i < dishes.length; i++)
                Container(
                  margin: const EdgeInsets.all(8),
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
                  ),
                  child: Image.asset(dishes[i], fit: BoxFit.cover),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChefSpecial() {
    return Column(
      children: [
        Container(
          width: 500,
          height: 100,
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("images/special-bg.png"), fit: BoxFit.cover),
          ),
          child: const Center(
            child: Text("Today's Chef's Special", textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFD5AE33), fontSize: 40, fontFamily: "Alura")),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(width: 200, child: Image(image: const AssetImage("images/dish-0.png"), fit: BoxFit.cover)),
        const SizedBox(height: 10),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: 150, child: Image(image: const AssetImage("images/dinner-dish-1.png"), fit: BoxFit.cover)),
              SizedBox(width: 150, child: Image(image: const AssetImage("images/dinner-dish-3.png"), fit: BoxFit.cover)),
              SizedBox(width: 150, child: Image(image: const AssetImage("images/lunch-dish-2.png"), fit: BoxFit.cover)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => setState(() => pageIndex = 5),
          child: Container(
            width: 220,
            height: 55,
            decoration: BoxDecoration(
              color: const Color(0xFFD5AE33),
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
            ),
            child: const Center(
              child: Text("Reserve a Table", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "Alura")),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOfferCard(String title, String description, String badge) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF221919),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD5AE33), width: 1.5),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontFamily: "Alura", fontSize: 24, color: Color(0xFFD5AE33))),
                const SizedBox(height: 6),
                Text(description, style: const TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: const Color(0xFFD5AE33), borderRadius: BorderRadius.circular(20)),
            child: Text(badge, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildMealDealRow(String title, String imagePath, String details) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF221919),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD5AE33), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontFamily: "Alura", fontSize: 24, color: Color(0xFFD5AE33))),
              const SizedBox(height: 4),
              Text(details, style: const TextStyle(color: Colors.white70, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("images/leaves_bg.png"), fit: BoxFit.cover),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.75)),
        child: Column(
          children: [
            const Text("Blackwood Restaurant",
                style: TextStyle(color: Color(0xFFD5AE33), fontSize: 36, fontFamily: "Alura", fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(width: 120, height: 2, color: const Color(0xFFD5AE33)),
            const SizedBox(height: 20),
            const Text("Open Daily • 10 AM - 12 AM", style: TextStyle(color: Colors.white70, fontSize: 15)),
            const SizedBox(height: 8),
            const Text("Downtown Cairo, Egypt", style: TextStyle(color: Colors.white54, fontSize: 13)),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _footerIcon(Icons.facebook),
                const SizedBox(width: 18),
                _footerIcon(Icons.camera_alt),
                const SizedBox(width: 18),
                _footerIcon(Icons.music_note),
                const SizedBox(width: 18),
                _footerIcon(Icons.language),
              ],
            ),
            const SizedBox(height: 30),
            const Text("© 2026 Blackwood Restaurant", style: TextStyle(color: Colors.white38, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _footerIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFD5AE33).withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: const Color(0xFFD5AE33)),
    );
  }
}

class _AboutDividerDot extends StatelessWidget {
  const _AboutDividerDot();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: Color(0xFFD5AE33),
        shape: BoxShape.circle,
      ),
    );
  }
}