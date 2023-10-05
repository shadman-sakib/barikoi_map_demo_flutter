import 'package:barikoi_map_demo_flutter/keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maplibre_gl/mapbox_gl.dart';

class LayerMap extends StatefulWidget{
  @override
  State<LayerMap> createState() => _LayerMapState();
}

class _LayerMapState extends State<LayerMap>{
  CameraPosition initialPosition= CameraPosition(target: LatLng(23.835677, 90.380325), zoom: 12);   //CameraPosition object for initial location in map
  MaplibreMapController? mController;

  static const styleId = 'osm-liberty' ;    //barikoi map style id
  static const apiKey=BARIKOI_API_KEY;   //barikoi API key, get it from https://developer.barikoi.com
  static const mapUrl= 'https://map.barikoi.com/styles/$styleId/style.json?key=$apiKey';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaplibreMap(
        initialCameraPosition: initialPosition,   // set map initial location where map will show first
        onMapCreated: (MaplibreMapController mapController){  //called when map object is created
          mController= mapController;   // use the MaplibreMapController for map operations
        },
        styleString: mapUrl , // barikoi map style url
        onStyleLoadedCallback: (){
          addVideo(mController);
          //addVector(mController);
          addGeojsonCluster(mController!!);
        },
      ),
    );
  }

  static Future<void> addVideo(MaplibreMapController? controller) async {
    await controller?.addSource(
        "video",
        const VideoSourceProperties(urls: [
          'https://static-assets.mapbox.com/mapbox-gl-js/drone.mp4',
          'https://static-assets.mapbox.com/mapbox-gl-js/drone.webm'
        ], coordinates: [
          [ 23.869613196331258, 90.30682295412356],
          [ 23.768577101413, 90.30682295412356],
          [23.768577101413, 90.50677547528488],
          [23.869613196331258, 90.50677547528488]
        ]));

    await controller?.addRasterLayer(
      "video",
      "video",
      const RasterLayerProperties(),
    );
  }

  static Future<void> addVector(MaplibreMapController? controller) async {
    await controller?.addSource(
        "terrain",
        const VectorSourceProperties(
          url: "https://demotiles.maplibre.org/tiles/tiles.json",
        ));

    await controller?.addLayer(
        "terrain",
        "contour",
        const LineLayerProperties(
          lineColor: "#ff69b4",
          lineWidth: 1,
          lineCap: "round",
          lineJoin: "round",
        ),
        sourceLayer: "countries");
  }

  static Future<void> addGeojsonCluster(
      MaplibreMapController controller) async {
    await controller.addSource(
        "earthquakes",
        const GeojsonSourceProperties(
            data:
            'https://docs.mapbox.com/mapbox-gl-js/assets/earthquakes.geojson',
            cluster: true,
            clusterMaxZoom: 14, // Max zoom to cluster points on
            clusterRadius:
            50 // Radius of each cluster when clustering points (defaults to 50)
        ));
    await controller.addLayer(
        "earthquakes",
        "earthquakes-circles",
        const CircleLayerProperties(circleColor: [
          Expressions.step,
          [Expressions.get, 'point_count'],
          '#51bbd6',
          100,
          '#f1f075',
          750,
          '#f28cb1'
        ], circleRadius: [
          Expressions.step,
          [Expressions.get, 'point_count'],
          20,
          100,
          30,
          750,
          40
        ]));
    addImageFromAsset("custom-marker", "assets/marker.png", controller).then((value) => {
      controller.addLayer(
        "earthquakes",
        "earthquakes-count",
        const SymbolLayerProperties(
          textField: [Expressions.get, 'point_count_abbreviated'],
          textSize: 12,
          iconSize: .3
        ))
    });
  }
  // Adds an asset image to the currently displayed style
  static Future<void> addImageFromAsset(String name, String assetName, MaplibreMapController mController) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mController.addImage(name, list);
  }


}
