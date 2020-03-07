import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:qreader_app/src/bloc/scans_bloc.dart';
import 'package:qreader_app/src/models/scan_model.dart';
import 'package:qreader_app/src/pages/address_page.dart';
import 'package:qreader_app/src/pages/maps_page.dart';
import 'package:qreader_app/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int currentIndex = 0;
  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: (){
              scansBloc.deleteAllScans();
            },
          )
        ],
      ),
      body: _loadPage(currentIndex),
      bottomNavigationBar: _createBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _scanQR,
        child: Icon(Icons.filter_center_focus,),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _createBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index){
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas')
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.brightness_5),
            title: Text('Direcciones')
        ),
      ],
    );
  }

  _loadPage(int index) {
    switch(index){
      case 0:
      return MapsPage();
      break;
      case 1:
        return AddressPage();
        break;
      default:
        return MapsPage();
        break;
    }
  }

  _scanQR() async {
    String futureString = '';
    try{
      futureString = await BarcodeScanner.scan();

    }catch(e){
      futureString = e.toString();
    }
    print(futureString);
    if(futureString != null){
      final scan = ScanModel(value: futureString);
      scansBloc.addScan(scan);

      if(Platform.isIOS ){
        Future.delayed(Duration(milliseconds: 750), (){
          utils.openScan(context, scan);
        });
      }else{
        utils.openScan(context, scan);
      }
    }
  }
}
