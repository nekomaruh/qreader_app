import 'package:flutter/material.dart';
import 'package:qreader_app/src/bloc/scans_bloc.dart';
import 'package:qreader_app/src/models/scan_model.dart';
import 'package:qreader_app/src/utils/utils.dart' as utils;

class AddressPage extends StatelessWidget {
  final scansBloc = new ScansBloc();
  @override
  Widget build(BuildContext context) {
    scansBloc.getScans();
    return StreamBuilder<List<ScanModel>>(
      stream: scansBloc.scansStreamHttp,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot){
        if(snapshot.hasData){
          final scans = snapshot.data;
          if(scans.length==0) {
            return Center(child: Text('No hay información que mostrar'));
          }
          return ListView.builder(
              itemCount: scans.length,
              itemBuilder: (context, i) => Dismissible(
                key: UniqueKey(),
                background: Container(color: Colors.red,),
                onDismissed: (direction) => scansBloc.deleteScan(scans[i].id),
                child: ListTile(
                  onTap: () => utils.openScan(context, scans[i]),
                  leading: Icon(Icons.link, color: Theme.of(context).primaryColor,),
                  title: Text(scans[i].value),
                  subtitle: Text("ID: ${scans[i].id}"),
                  trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
                ),
              )

          );
        }else{
          return Center(child: CircularProgressIndicator());
        }
      },

    );
  }
}
