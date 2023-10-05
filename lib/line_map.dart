
import 'package:barikoi_map_demo_flutter/keys.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/mapbox_gl.dart';

class LineMap extends StatefulWidget{
  @override
  State<LineMap> createState() => _LineMapState();
}

class _LineMapState extends State<LineMap> {
  CameraPosition initialPosition = CameraPosition(
      target: LatLng(23.835677, 90.380325),
      zoom: 12); //CameraPosition object for initial location in map
  MaplibreMapController? mController;

  static const styleId = 'osm-liberty'; //barikoi map style id
  static const apiKey = BARIKOI_API_KEY; //barikoi API key, get it from https://developer.barikoi.com
  static const mapUrl = 'https://map.barikoi.com/styles/$styleId/style.json?key=$apiKey';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaplibreMap(
        initialCameraPosition: initialPosition,
        // set map initial location where map will show first
        onMapCreated: (
            MaplibreMapController mapController) { //called when map object is created
          mController =
              mapController; // use the MaplibreMapController for map operations
        },
        styleString: mapUrl, // barikoi map style url
        onStyleLoadedCallback: (){
          mController?.addLine(
              const LineOptions(
                geometry: [   //geometry of the line , in List<LatLng>> format
                  LatLng(23.87397849117633,90.4004025152986),
                  LatLng(23.860512893207584,90.4004025152986),
                  LatLng(23.837857327354314,90.41815482211757),
                  LatLng(23.82212196615106,90.42035665862238),
                  LatLng(23.812428033815493,90.40370527005587),
                  LatLng(23.762436156214207,90.39462262442248),
                ],
                lineColor: "#ff0000",   //color of the line, in hex string
                lineWidth: 5.0,     //width of the line
                lineOpacity: 0.5,   // transparency of the line
                draggable: true     //set whether line is dragabble
              )
          );
          //add line tap listner
          mController?.onLineTapped.add(_OnLineTapped);
        },
      ),
    );
  }

  void _OnLineTapped(Line line) {
      //implement line tap event here
  }
}