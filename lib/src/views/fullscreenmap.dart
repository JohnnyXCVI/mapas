import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';

class FullScreenMap extends StatefulWidget {
  @override
  _FullScreenMapState createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  static const String ACCESS_TOKEN =
      'pk.eyJ1IjoiamRjYXphbDk2IiwiYSI6ImNrczZkYTNwbDAwdG0ycXFlMWpzZ2c3dHgifQ.1nfpLb7bFz2I8Ia769RIpA';

  late MapboxMapController mapController;
  final center = LatLng(-25.397192, -57.365714);
  String selectedStyle = 'mapbox://styles/jdcazal96/cks964mm20ptm17nxujagnlsj';
  final oscuroStyle = 'mapbox://styles/jdcazal96/cks9335hr105h17o2ijwsquos';
  final streetStyle = 'mapbox://styles/jdcazal96/cks964mm20ptm17nxujagnlsj';

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _onStyleLoaded();
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/custom-icon.png");
    addImageFromUrl(
        "networkImage", Uri.parse("https://via.placeholder.com/50"));
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  Future<void> addImageFromUrl(String name, Uri uri) async {
    var response = await http.get(uri);
    return mapController.addImage(name, response.bodyBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: crearMapa(),
      floatingActionButton: botonesFlotantes(),
    );
  }

  Column botonesFlotantes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        //simbolos
        FloatingActionButton(
          child: Icon(Icons.emoji_symbols),
          onPressed: () {
            mapController.addSymbol(SymbolOptions(
              geometry: center,
              //iconSize: 3,
              iconImage: 'assetImage',
              textField: 'Nueva ubicacion',
              textOffset: Offset(0, 2),
            ));
          },
        ),
        SizedBox(height: 5),
        //zoomIn
        FloatingActionButton(
          child: Icon(Icons.zoom_in),
          onPressed: () {
            mapController.animateCamera(CameraUpdate.zoomIn());
          },
        ),
        SizedBox(height: 5),
        //zoomOut
        FloatingActionButton(
          child: Icon(Icons.zoom_out),
          onPressed: () {
            mapController.animateCamera(CameraUpdate.zoomOut());
          },
        ),
        SizedBox(height: 5),
        //cambiar estilo
        FloatingActionButton(
          child: Icon(Icons.color_lens),
          onPressed: () {
            if (selectedStyle == oscuroStyle) {
              selectedStyle = streetStyle;
            } else {
              selectedStyle = oscuroStyle;
            }
            _onStyleLoaded();
            setState(() {});
          },
        ),
      ],
    );
  }

  MapboxMap crearMapa() {
    return MapboxMap(
      accessToken: ACCESS_TOKEN,
      styleString: selectedStyle,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: center,
        zoom: 14.0,
      ),
    );
  }
}
