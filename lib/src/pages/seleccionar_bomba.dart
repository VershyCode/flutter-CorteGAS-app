import 'package:corte_gas/src/pages/home_page.dart';
import 'package:corte_gas/src/providers/dispensarios_provider.dart';
import 'package:flutter/material.dart';

class DataExporter{
  int pistolas;
  List<dynamic> types;
  DataExporter(this.pistolas, this.types);
}
class SeleccionarBomba extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GasData args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
       appBar: AppBar(
         backgroundColor: Colors.green,
         title: Text('Dispensario'),
         actions: <Widget>[
           Padding(
             padding: EdgeInsets.all(10.0),
             child: FloatingActionButton(
               onPressed: (){
                 _helpButton(context);
               },
               child: Icon(Icons.help),
               backgroundColor: Colors.red,
             ),
           )
         ],
       ),
       body: FutureBuilder(
         future: dispensariosProvider.cargarGasolineras(args.data),
         initialData: [],
         builder: (BuildContext context, AsyncSnapshot snapshot) {
           return ListView(
             children: _dispensarios(snapshot.data, context),
           );
         },
       ),
       backgroundColor: Colors.redAccent[100],
    );
  }

  Future<dynamic> _helpButton(BuildContext context){
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text('Necesitas ayuda? !'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.live_help, size: 60.0),
              SizedBox(height: 30.0,),
              Text('Has seleccionado una gasolinera y a continuacion te muestro que dispensarios tiene disponibles, selecciona el dispensario correcto para que comiences a hacer tu corte!'),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Mas ayuda'),
              onPressed: (){
                Navigator.of(context).pop();
              }, 
            ),
            FlatButton(
              child: Text('Ok, gracias!'),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  List<Widget>_dispensarios(List<dynamic> data, BuildContext context) {
    /// Creamos una lista temporal, y con un forEach barremos cada
    /// una de los dispensarios obtenidos de la gasolinera seleccionada.
    /// Donde [e] contiene la informacion de cada dispensario disponible.
    List<Widget> tempList = [];
    int i = 0;
    data.forEach((e) {
      final int pistolas = e['bomba${i+1}']['pistolas'];
      List<dynamic> types = e['bomba${i+1}']['tipos'];
      tempList.add(
        Card(
          elevation: 20.0,
          child: ListTile(
            title: Text('Dispensario #${i+1}', style: TextStyle(fontSize: 18.0, letterSpacing: 0.5)),
            subtitle: Text('${e['bomba${i+1}']['descripcion']}\n(${e['bomba${i+1}']['pistolas']} pistolas).'),
            leading: Icon(Icons.monetization_on, size: 50.0),
            trailing: Icon(Icons.mode_edit, size: 30.0, color: Colors.blueGrey),
            contentPadding: EdgeInsets.all(20.0),
            onTap: (){
              Navigator.pushNamed(context, 'establecer_numeraciones', arguments: DataExporter(pistolas, types));
            },
          ),
        )
      );
      i++; // Aumentamos el iterador para ir por el siguiente dispensario.
    });
    return tempList;
  }
}