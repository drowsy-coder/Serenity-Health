import 'package:serenity/models/home_carousel_item.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class MyCarouselSlider extends StatelessWidget {
  final List<CarouselItem> carouselItems;

  MyCarouselSlider({required this.carouselItems});

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
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 6.0,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              item.imageAssetPath,
                              height: 200.0,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber[900],
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  item.description,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              launch(item.redirectLink);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.purple,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(24.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 24.0,
                              ),
                            ),
                            child: const Text(
                              'Learn More',
                              style: TextStyle(fontSize: 16.0),
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
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 6.0,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        item.imageAssetPath,
                        height: 100.0,
                        width: 100.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber[900],
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            item.description,
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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