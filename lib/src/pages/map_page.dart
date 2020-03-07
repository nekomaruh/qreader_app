import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qreader_app/src/models/scan_model.dart';

class MapPage extends StatefulWidget {

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _mapController = new MapController();

  String _mapType = 'streets';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              _mapController.move(scan.getLatLng(), 15);
            },
          )
        ],
      ),
      body: _createFlutterMap(scan),
      floatingActionButton: _createFab(context),
    );
  }

  _createFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 10,
      ),
      layers: [
        _createMap(),
        _createMarkers(scan),
      ],
    );
  }

  _createMap() {
    return TileLayerOptions(
        urlTemplate: 'https://api.mapbox.com/v4/'
            '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
        additionalOptions: {
          'accessToken':
              'pk.eyJ1IjoibmVrb21hcnVoIiwiYSI6ImNrNzU0anA0aTAwYXgzbHFpdmEwNXprYjUifQ.nRtSY09PhIK5tjvlZUKuUg',
          'id': 'mapbox.$_mapType'
        });
  }

  _createMarkers(ScanModel scan) {
    return MarkerLayerOptions(markers: <Marker>[
      Marker(
          width: 100,
          height: 100,
          point: scan.getLatLng(),
          builder: (context) => Container(
            child: Icon(
                  Icons.location_on,
                  size: 45,
                  color: Theme.of(context).primaryColor,
                ),
          ))
    ]);
  }

  _createFab(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: (){
        if(_mapType=='streets'){
          _mapType = 'dark';
        }else if(_mapType=='dark'){
          _mapType = 'light';
        }else if(_mapType=='light'){
          _mapType = 'outdoors';
        }else if(_mapType=='outdoors'){
          _mapType = 'satellite';
        }else if(_mapType=='satellite'){
          _mapType = 'streets';
        }
        setState(() {});
      },
    );
  }
}
