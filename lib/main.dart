import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RestaurantHomePage(),
    );
  }
}

class RestaurantHomePage extends StatefulWidget {
  const RestaurantHomePage({super.key});

  @override
  _RestaurantHomePageState createState() => _RestaurantHomePageState();
}

class _RestaurantHomePageState extends State<RestaurantHomePage> {
  int index = 0;
  int pageIndex = 0;
  Timer? T;
  bool timerEnabled = false;

  @override
  void initState() {
    super.initState();
    startTimer();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color.fromRGBO(235, 235, 230, 1),

      body: pages(pageIndex),
    );
  }

  Widget homePage()
  {
    return  SingleChildScrollView(
      child: Column(
        children: [
          _buildNavbar(),
          buildSlider(),
          Container(height: 20,color: const Color(0xFFD5AE33),),
          Container(
            color: Color(0xFF181818) ,height: 70,
            child: Row(
              children: [

                _buildTab(const Text("Home", style: TextStyle(fontFamily: "Alura", fontSize: 20, color: Color(0xFFD5AE33)),), 0),

                _buildTab(const Text("Offers", style: TextStyle(fontFamily: "Alura", fontSize: 20, color: Color(0xFFD5AE33)) ), 1),

                _buildTab(const Text("Profile", style: TextStyle(fontFamily: "Alura", fontSize: 20, color: Color(0xFFD5AE33)) ), 2),

                _buildTab(const Text("About", style: TextStyle(fontFamily: "Alura",fontSize: 20, color: Color(0xFFD5AE33)) ), 3),

              ],
            ),
          ),
           SizedBox(height: 20),
          _buildReserveBlock(),
           SizedBox(height: 20),
        Container(
          height: 3,

          decoration: BoxDecoration(
           color: Color(0xFFD5AE33),
                        )
        ),
          Container(
            height: 70,
            alignment: Alignment.centerLeft,
            decoration:  BoxDecoration(color: Color(0xFF221919)),
            child:  Padding(
              padding:  EdgeInsets.all(8.0),
              child: SizedBox(height: 100,

                child: Text("   Dinner", style: TextStyle(
                    color: Color(0xFFD5AE33),
                    fontWeight: FontWeight.normal,
                    fontSize: 40,
                    fontFamily: "Alura"
                ),),),
            ),
          ),
          _buildDishMenu(dishesDinner),
          Container(height: 20,color:  Color(0xFFD5AE33),),
          SizedBox(height: 40,),
          Container(
              height: 3,

              decoration: BoxDecoration(
                color: Color(0xFFD5AE33),
              )
          ),
          Container(
            height: 70,
            alignment: Alignment.centerLeft,
            decoration:  BoxDecoration(color: Color(0xFF221919)),
            child:  Padding(
              padding:  EdgeInsets.all(8.0),
              child: SizedBox(height: 100,

                child: Text("   Lunch", style: TextStyle(
                    color: Color(0xFFD5AE33),
                    fontWeight: FontWeight.normal,
                    fontSize: 40,
                    fontFamily: "Alura"
                ),),),
            ),
          ),
          _buildDishMenu(dishesLunch),
          Container(height: 20,color:  Color(0xFFD5AE33),),
          SizedBox(height: 40,),
          Container(
              height: 3,

              decoration: BoxDecoration(
                color: Color(0xFFD5AE33),
              )
          ),
          Container(
            height: 70,
            alignment: Alignment.centerLeft,
            decoration:  BoxDecoration(color: Color(0xFF221919)),
            child:  Padding(
              padding:  EdgeInsets.all(8.0),
              child: SizedBox(height: 100,

                child: Text("   Break fast", style: TextStyle(
                    color: Color(0xFFD5AE33),
                    fontWeight: FontWeight.normal,
                    fontSize: 40,
                    fontFamily: "Alura"
                ),),),
            ),
          ),
          _buildDishMenu(dishesLunch),
          Container(height: 20,color:  Color(0xFFD5AE33),),
          SizedBox(height: 50,),
          _buildChefSpecial(),
           SizedBox(height: 20,),
          _buildFooter(),
        ],
      ),
    );
  }
  Widget profilePage()
  {
    return Column(
      children: [
        _buildNavbar(),
        Container(
          color: Color(0xFF181818) ,height: 70,
          child: Row(
            children: [

              _buildTab(const Text("Home", style: TextStyle(fontFamily: "Alura", fontSize: 20, color: Color(0xFFD5AE33)),), 0),

              _buildTab(const Text("Offers", style: TextStyle(fontFamily: "Alura", fontSize: 20, color: Color(0xFFD5AE33)) ), 1),

              _buildTab(const Text("Profile", style: TextStyle(fontFamily: "Alura", fontSize: 20, color: Color(0xFFD5AE33)) ), 2),

              _buildTab(const Text("About", style: TextStyle(fontFamily: "Alura",fontSize: 20, color: Color(0xFFD5AE33)) ), 3),

            ],
          ),
        ),
        const Center(
          child: Text(
            "profile Page",
            style: TextStyle(
              fontSize: 42,
              color: Color(0xFFD5AE33),
            ),
          ),
        ),
      ],
    );
  }
  Widget offersPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildNavbar(),
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

          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 25),
            color: const Color(0xFF181818),
            child: const Center(
              child: Text(
                "Today's Offers",
                style: TextStyle(
                  fontFamily: "Alura",
                  fontSize: 42,
                  color: Color(0xFFD5AE33),
                ),
              ),
            ),
          ),

          Container(height: 3, color: const Color(0xFFD5AE33)),

          const SizedBox(height: 25),

          // Discount Cards Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "  Special Discounts",
                  style: TextStyle(
                    fontFamily: "Alura",
                    fontSize: 30,
                    color: Color(0xFFD5AE33),
                  ),
                ),
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

          // Meal Deals Section
          Container(
            height: 70,
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(color: Color(0xFF221919)),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "   Meal Deals",
                style: TextStyle(
                  color: Color(0xFFD5AE33),
                  fontSize: 40,
                  fontFamily: "Alura",
                ),
              ),
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

          // Reserve button
          GestureDetector(
            onTap: () {
              setState(() {
                pageIndex = 5;
              });
            },
            child: Container(
              width: 220,
              height: 55,
              decoration: BoxDecoration(
                color: const Color(0xFFD5AE33),
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  )
                ],
              ),
              child: const Center(
                child: Text(
                  "Reserve a Table",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Alura",
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),
          _buildFooter(),
        ],
      ),
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
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFD5AE33),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              badge,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
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
                details,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget aboutPage()
  {
    return Column(
      children: [
        _buildNavbar(),
        Container(
          color: Color(0xFF181818) ,height: 70,
          child: Row(
            children: [

              _buildTab(const Text("Home", style: TextStyle(fontFamily: "Alura", fontSize: 20, color: Color(0xFFD5AE33)),), 0),

              _buildTab(const Text("Offers", style: TextStyle(fontFamily: "Alura", fontSize: 20, color: Color(0xFFD5AE33)) ), 1),

              _buildTab(const Text("Profile", style: TextStyle(fontFamily: "Alura", fontSize: 20, color: Color(0xFFD5AE33)) ), 2),

              _buildTab(const Text("About", style: TextStyle(fontFamily: "Alura",fontSize: 20, color: Color(0xFFD5AE33)) ), 3),

            ],
          ),
        ),
        const Center(
          child: Text(
            "about",
            style: TextStyle(
              fontSize: 42,
              color: Color(0xFFD5AE33),
            ),
          ),
        ),
        _buildFooter()
      ],
    );
  }
  Widget pages(int pageindex) {

    if (pageindex == 0) {
      return homePage();
    }

    else if (pageindex == 1) {
      return offersPage();
    }

    else if (pageindex == 2) {
      return profilePage();
    }
    else if (pageindex == 3) {
      return aboutPage();
    }
    else {
      return const Center(
        child: Text(
          "Invalid page",
          style: TextStyle(
            fontSize: 42,
          ),
        ),
      );
    }
  }
  Widget _buildNavbar() {
    return Container(
      width: double.infinity,

      decoration: const BoxDecoration(
        color: Color(0xFF181818),

        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 2),
          )
        ],
      ),

      child: SafeArea(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),

              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFFD5AE33),
                    child: Icon(Icons.account_circle , size: 40, color: Color(0xFF181818),),

                  ),
                  Center(child: Text("Blackwood", style: TextStyle(fontFamily: "Alura", fontSize: 50, color: Color(0xFFD5AE33)) )),
                  Container(
                    padding: const EdgeInsets.all(8),

                    decoration: BoxDecoration(
                      color: Color(0xFFD5AE33),
                      borderRadius:
                      BorderRadius.circular(12),
                    ),

                    child:  Icon(
                      Icons.menu, size: 40,
                      color: Color(0xFF181818),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 2,

              decoration: BoxDecoration(
                color: Color(0xFFD5AE33),
              ),


            ),
          ],
        ),
      ),
    );
  }
  Widget _buildTab(Text title, int tabIndex) {

    bool isSelected = pageIndex == tabIndex;

    return Expanded(
      child: GestureDetector(

        onTap: () {
          pageIndex = tabIndex;
          setState(() {});
        },

        child: Container(

          decoration: BoxDecoration(

            border: Border(

              bottom: BorderSide(

                color: isSelected
                    ? const Color(0xFFD5AE33)
                    : Colors.transparent,

                width: 3,
              ),
            ),
          ),

          child: Center(
              child: title
          ),
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

                colors: [
                  Colors.black.withOpacity(0.75),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // TEXT
          const Positioned(
            left: 25,
            bottom: 35,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  "Luxury Dining",
                  style: TextStyle(
                    color: Color(0xFFD5AE33),
                    fontSize: 42,
                    fontFamily: "Alura",
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  "Experience elegance in every meal",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
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
            "Experience the finest dining in the heart of the city. "
                "Join us for an unforgettable evening.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFD5AE33),
              fontWeight: FontWeight.bold,
              fontSize: 35,
              fontFamily: "Alura",

            ),
          ),

          const SizedBox(height: 25),

          GestureDetector(
            onTap: () {
              setState(() {
                pageIndex = 5;
              });
            },
            child: Container(
              width: 220,
              height: 55,
              decoration: BoxDecoration(
                color: const Color(0xFFD5AE33),
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  )
                ],
              ),
              child: const Center(
                child: Text(
                  "Reserve a Table",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Alura",
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget _buildDishMenu(List<String> dishes) {
    return Container(
      height: 200,
      width: double.infinity,

      decoration:  const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/wood_texture.png"),
          fit: BoxFit.cover,
        ),
      ),

      child: Padding(
        padding:  const EdgeInsets.all(10),

        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,

          child: Row(
            children: [
              for (int i = 0; i < dishes.length; i++)
                Container(
                  margin:  const EdgeInsets.all(8),
                  width: 120,
                  height: 120,

                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow:  [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Image.asset(
                    dishes[i],
                    fit: BoxFit.cover,
                  ),
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
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/special-bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Text(
              "Today's Chef's Special",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFD5AE33),
                fontSize: 40,
                fontFamily: "Alura",
              ),
            ),
          ),
        ),

        const SizedBox(height: 15),

        Container(width: 200, child: Image(image: AssetImage("images/dish-0.png"), fit: BoxFit.cover)),
        SizedBox(height: 10,),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(width: 150, child: Image(image: AssetImage("images/dinner-dish-1.png"), fit: BoxFit.cover)),
              Container(width: 150, child: Image(image: AssetImage("images/dinner-dish-3.png"), fit: BoxFit.cover)),
              Container(width: 150, child: Image(image: AssetImage("images/lunch-dish-2.png"), fit: BoxFit.cover)),

            ],
          ),
        ),
        SizedBox(height: 10,),
        GestureDetector(
          onTap: () {
            setState(() {
              pageIndex = 5;
            });
          },
          child: Container(
            width: 220,
            height: 55,
            decoration: BoxDecoration(
              color:  Color(0xFFD5AE33),
              borderRadius: BorderRadius.circular(30),
              boxShadow:  [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                )
              ],
            ),
            child:  Center(
              child: Text(
                "Reserve a Table",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Alura",
                ),
              ),
            ),
          ),
        )

      ],
    );
  }
  Widget _buildFooter() {
    return Container(
      width: double.infinity,

      decoration:  const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/leaves_bg.png"),
          fit: BoxFit.cover,
        ),
      ),

      child: Container(
        padding:  const EdgeInsets.symmetric(vertical: 35, horizontal: 20),

        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.75),
        ),

        child: Column(
          children: [


            const Text(
              "Blackwood Restaurant",
              style: TextStyle(
                color: Color(0xFFD5AE33),
                fontSize: 36,
                fontFamily: "Alura",
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // Small line
            Container(
              width: 120,
              height: 2,
              color:  const Color(0xFFD5AE33),
            ),

            const SizedBox(height: 20),

            // Contact info
            const Text(
              "Open Daily • 10 AM - 12 AM",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Downtown Cairo, Egypt",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 25),

            // Social icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Container(
                  padding:  const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:  const Color(0xFFD5AE33).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child:  const Icon(
                    Icons.facebook,
                    color: Color(0xFFD5AE33),
                  ),
                ),

                const SizedBox(width: 18),

                Container(
                  padding:  const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:  const Color(0xFFD5AE33).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child:  const Icon(
                    Icons.camera_alt,
                    color: Color(0xFFD5AE33),
                  ),
                ),

                const SizedBox(width: 18),

                Container(
                  padding:  const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:  const Color(0xFFD5AE33).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child:  const Icon(
                    Icons.music_note,
                    color: Color(0xFFD5AE33),
                  ),
                ),

                const SizedBox(width: 18),

                Container(
                  padding:  const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:  const Color(0xFFD5AE33).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child:  const Icon(
                    Icons.language,
                    color: Color(0xFFD5AE33),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),


            const Text(
              "© 2026 Blackwood Restaurant",
              style: TextStyle(
                color: Colors.white38,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
