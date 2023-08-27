import 'package:serenity/screens/login/login_method.dart';
import 'package:serenity/widgets/buttons/sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselItem {
  final String imagePath;
  final String title;
  final String description;

  CarouselItem({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

class LoginPage extends StatelessWidget {
  final LoginMethods loginMethods = LoginMethods();

  LoginPage({super.key, Key? key1});

  @override
  Widget build(BuildContext context) {
    loginMethods.checkLoggedIn(context);

    final List<CarouselItem> carouselItems = [
      CarouselItem(
        imagePath: 'assets/images/medic.png',
        title: 'Medicine Reminder',
        description:
            'Never miss a dose again with our intuitive medicine reminder feature.',
      ),
      CarouselItem(
        imagePath: 'assets/images/medi.jpg',
        title: 'Meditate and Journal',
        description:
            'Take a moment for yourself and find inner peace with meditation and journaling. ',
      ),
      CarouselItem(
        imagePath: 'assets/images/sos.png',
        title: 'Get Support in Emergency',
        description:
            ' Connect with emergency services or reach out to your designated emergency contacts',
      ),
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue[400]!,
              Colors.green[400]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 40),
                Image.asset(
                  'assets/images/3799666.png',
                  width: 200,
                  height: 100,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Serenity',
                  style: TextStyle(
                    fontFamily: 'AlBrush',
                    fontSize: 70,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.black,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    viewportFraction: 0.8,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 2.0,
                  ),
                  items: carouselItems.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          color: Colors.white.withOpacity(0.7),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    item.imagePath,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      item.description,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 40),
                CustomSignInButton(
                  onPressed: () async {
                    await loginMethods.signInWithGoogle(context);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
