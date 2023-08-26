import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SoSPage extends StatelessWidget {
  SoSPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Safety',
          style: Theme.of(context).textTheme.headline6?.copyWith(
                color: Colors.white,
              ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.grey.shade900,
            child: ClipRect(
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  // width: 100, // Adjust the width as desired
                  height: 100, // Adjust the height as desired
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset(
                      'assets/images/ambul.gif',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey.shade900,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Emergency Assistance',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton.icon(
                    onPressed: () => launch('tel:102'),
                    icon: const Icon(Icons.local_hospital_outlined),
                    label: const Text(
                      'Call Ambulance',
                      style: TextStyle(fontSize: 24.0),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red.shade800,
                      onPrimary: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 24.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  FutureBuilder(
                    future: Permission.location.status,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == PermissionStatus.granted) {
                        return ElevatedButton.icon(
                          onPressed: () async {
                            Position position =
                                await Geolocator.getCurrentPosition(
                              desiredAccuracy: LocationAccuracy.high,
                            );

                            String message =
                                'I am in an Emergency at: https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}&zoom=15&ll=${position.latitude},${position.longitude}&markers=color:blue%7Clabel:S%7C${position.latitude},${position.longitude}';
                            String encodedMessage =
                                Uri.encodeComponent(message);
                            String url = 'sms:?body=$encodedMessage';
                            launchUrlString(url);
                          },
                          icon: const Icon(Icons.location_on_outlined),
                          label: const Text(
                            'Share Location via SMS',
                            style: TextStyle(fontSize: 24.0),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green.shade800,
                            onPrimary: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 24.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        );
                      } else {
                        return ElevatedButton.icon(
                          onPressed: () async {
                            var status = await Permission.location.request();
                            if (status == PermissionStatus.granted) {
                              Position position =
                                  await Geolocator.getCurrentPosition(
                                desiredAccuracy: LocationAccuracy.high,
                              );

                              String message =
                                  'I am in an Emergency at: https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}&zoom=15&ll=${position.latitude},${position.longitude}&markers=color:blue%7Clabel:S%7C${position.latitude},${position.longitude}';
                              String encodedMessage =
                                  Uri.encodeComponent(message);
                              String url = 'sms:?body=$encodedMessage';
                              launchUrlString(url);
                            }
                          },
                          icon: const Icon(Icons.location_on_outlined),
                          label: const Text(
                            'Share Location via SMS',
                            style: TextStyle(fontSize: 24.0),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orange.shade800,
                            onPrimary: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 24.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 40.0),
                  // Guide at the bottom
                  const Text(
                    'You can use the SoS feature to call an ambulance or send a text to your family members with your location.',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
