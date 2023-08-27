import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  Uint8List? markerIcon;
  late String _darkMapStyle; 

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(12.840738491239273, 80.15339126033456),
    zoom: 14,
  );

  List<String> images = [
    'assets/images/3448436.png',
  ];

  final List<Marker> _markers = <Marker>[];

  final List<LatLng> _latLang = <LatLng>[
    const LatLng(12.8496091277555, 80.15448915392965),
    const LatLng(12.85007219063799, 80.14166343035889),
    const LatLng(12.902598990948494, 80.15847617410229),
    const LatLng(12.898777606179255, 80.20596499331037),
    const LatLng(12.925420080357393, 80.11420372826137),
    const LatLng(12.795994301253048, 80.21581466700889),
  ];

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    super.initState();
    _loadMapStyles();
    loadData();
  }

  Future<void> _loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString('assets/json/dark_theme.json');
  }

  void loadData() async {
    markerIcon = await getBytesFromAssets(images[0], 150);

    for (int i = 0; i < _latLang.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: _latLang[i],
          infoWindow: InfoWindow(
            title: "Hospital ${i + 1}",
          ),
          icon: BitmapDescriptor.fromBytes(markerIcon!),
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Hospitals"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: GoogleMap(
          initialCameraPosition: _initialCameraPosition,
          markers: Set<Marker>.of(_markers),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            controller.setMapStyle(_darkMapStyle);
          },
          myLocationEnabled: true,
        ),
      ),
    );
  }
}
