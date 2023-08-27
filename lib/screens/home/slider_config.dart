import 'package:serenity/models/home_carousel_item.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class MyCarouselSlider extends StatelessWidget {
  final List<CarouselItem> carouselItems;

  const MyCarouselSlider({super.key, required this.carouselItems});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: carouselItems.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        final item = carouselItems[index];
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  content: SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 12.0,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 250.0,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20.0)),
                              image: DecorationImage(
                                image: AssetImage(item.imageAssetPath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontSize: 28.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  item.description,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                ElevatedButton(
                                  onPressed: () {
                                    launch(item.redirectLink);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purple,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14.0,
                                      horizontal: 28.0,
                                    ),
                                  ),
                                  child: const Text(
                                    'Learn More',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 10.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      item.imageAssetPath,
                      height: 120.0,
                      width: 120.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          item.description,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 200.0,
        initialPage: 0,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) {},
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
