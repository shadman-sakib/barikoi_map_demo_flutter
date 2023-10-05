

import 'package:barikoi_map_demo_flutter/keys.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/mapbox_gl.dart';




class CameraMap extends StatefulWidget {

  @override
  State createState() => _CameraMapState();
}

class _CameraMapState extends State<CameraMap> {
  CameraPosition initialPosition= CameraPosition(target: LatLng(23.835677, 90.380325), zoom: 12);   //CameraPosition object for initial location in map
  MaplibreMapController? mController;

  static const styleId = 'osm-liberty' ;    //barikoi map style id
  static const apiKey=BARIKOI_API_KEY;   //barikoi API key, get it from https://developer.barikoi.com
  static const mapUrl= 'https://map.barikoi.com/styles/$styleId/style.json?key=$apiKey';

  var actionList = [
    DropdownMenuEntry<MapAction>(value: MapAction(name: "New CameraPosition", function: _setCameraPosition), label: "New CameraPosition"),
    DropdownMenuEntry<MapAction>(value: MapAction(name: "New LatLng", function: _setNewLatlng), label: "New LatLng"),
    DropdownMenuEntry<MapAction>(value: MapAction(name: "New LatLng Zoom", function: _setNewLatlngZoom), label: "New LatLng Zoom" ),
    DropdownMenuEntry<MapAction>(value: MapAction(name: "Scroll by", function: _scrollby), label: "Scroll by"),
    DropdownMenuEntry<MapAction>(value: MapAction(name: "Zoom by", function: _zoomBy), label: "Zoom by"),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(padding: EdgeInsets.all(8.0),
          child: DropdownMenu<MapAction>(
          label: const Text('Choose an Option'),
          dropdownMenuEntries: actionList,
          onSelected: (MapAction? action) {
            action?.function(mController);
          }
          )
        ),
        Expanded(

        child:
          MaplibreMap(
            onMapCreated: (MaplibreMapController mapController){
              mController = mapController;
            },
            initialCameraPosition: const CameraPosition(target: LatLng(0.0, 0.0)),
            styleString: mapUrl,
          ),
        )


      ],
    );
  }


}

void _setCameraPosition(MaplibreMapController? mController){
  //set new CameraPostion for map
  mController?.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(
          bearing: 270.0, //bearing of the map view, value range 0- 360
          target: LatLng(23.3160895, 90.81294527),   // LatLng position of the location
          tilt: 30.0, // tilt the map by degree
          zoom: 17.0, // zoom level of the map
        ),
      )
  );
}

void _setNewLatlng(MaplibreMapController? mController){
  //animate camera to the Latlng position
  mController?.animateCamera(
      CameraUpdate.newLatLng(
        const LatLng(23.824775, 90.360954),   // LatLng position of the location
      ),
      duration: const Duration(seconds: 3),     // map camera animation duration
    ).then((result) => debugPrint("mController?.animateCamera() returned $result"));
}

void _setNewLatlngZoom( MaplibreMapController? mController){
  //animate camera to the Latlng position with zoom level
  mController?.animateCamera(
    CameraUpdate.newLatLngZoom(const LatLng(23.774506, 90.444063), 7),
    duration: const Duration(milliseconds: 300),
  );
}

void _setlatlngBounds(MaplibreMapController? mController){
  //animate camera to the Latlng bounds with 2 Latlng points, the southwest and northeast corner position of the map viewport
  mController?.animateCamera(
    CameraUpdate.newLatLngBounds(
      LatLngBounds(
          southwest: const LatLng(23.878921, 90.345552),
          northeast: const LatLng(23.736799, 90.451606)
      ),
      left: 10,  // padding in 4 directions
      top: 5,
      bottom: 25,
      right: 10
    ),
  );
}

void _scrollby(MaplibreMapController? mController){
  //scroll the map programatically in x and y axis
  mController?.animateCamera(
    CameraUpdate.scrollBy(150.0, -225.0),
  );
}

void _zoomBy( MaplibreMapController? mController){
  //zoom in/out the map in current position, negative values for zoom out , positive for zoom in
  mController?.animateCamera(
    CameraUpdate.zoomBy(-0.5),
  );
}

class MapAction{
  final String name;
  final Function(MaplibreMapController? mapController) function;

  MapAction({required this.name, required this.function} );
}