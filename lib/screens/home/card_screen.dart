import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomCard extends StatelessWidget {
  final Item item;

  const CustomCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      item.description,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        launch(item.redirectLink);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 24.0,
                        ),
                      ),
                      child: const Text(
                        'Learn More',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 120.0,
                height: 120.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  image: DecorationImage(
                    image: AssetImage(
                      item.imageAssetPath,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Item {
  final String title;
  final String description;
  final String redirectLink;
  final String imageAssetPath;

  Item({
    required this.title,
    required this.description,
    required this.redirectLink,
    required this.imageAssetPath,
  });
}
