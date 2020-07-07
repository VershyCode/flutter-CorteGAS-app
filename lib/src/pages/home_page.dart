import 'package:corte_gas/src/providers/menu_provider.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class GasData{
  String data = 'NO DATA';
  GasData(this.data);
}

class _HomepageState extends State<Homepage> {
  TextStyle decoracionTitulo = new TextStyle(fontSize: 27, letterSpacing: 1, fontWeight: FontWeight.w800);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: _content(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _helpButton(context);
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.help, size: 50),
      ),
    );
  }

  Future<dynamic> _helpButton(BuildContext context){
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text('Hola despachador !'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.pan_tool, size: 40.0),
              SizedBox(height: 30.0,),
              Text('Esta herramienta fue creada para realizar el corte de cierre de turno en las diferentes estaciones de gasolineras rubios, todo esto acorde la numeracion proporcionada por el dispensario.'),
            ],
          ),
          actions: <Widget>[
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

  Widget _content(){
    return Center(
      child: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 50),
              Container(
                child: Card(
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  color: Colors.green,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text('Elija una estacion', style: decoracionTitulo, textAlign: TextAlign.center)),
                      ),
                      Icon(Icons.keyboard_arrow_down, size: 50.0)
                    ],
                  ),
                ),
              ),
              _menuGasolineras(),
            ],
          ),
      ),
    );
  }

  Widget _menuGasolineras() {
    return FutureBuilder(
      future: menuProvider.cargarGasolineras(),
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot){
        return Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Column(
            children: _listaGasolineras(snapshot.data, context),
          ),
        );
      },
    );
  }

  List<Widget> _listaGasolineras(List<dynamic> gasolineras, BuildContext context) {
    return gasolineras.map((gasolinera)=> Container(
      child: Column(
        children: <Widget>[
          Card(
            elevation: 5.0,
            child: ListTile(
              contentPadding: EdgeInsets.all(20.0),
              title: Text('${gasolinera['nombre_gasolinera']}', style: TextStyle(fontSize: 18, letterSpacing: 0.5)),
              subtitle: Text(gasolinera['descripcion']),
              trailing: Icon(Icons.mode_edit, color: Color.fromARGB(255, 255, 113, 80)),
              leading: Icon(Icons.local_gas_station, color: Colors.blueAccent, size: 50.0,),
              onTap: (){
                Navigator.pushNamed(context, 'seleccionar_bomba', arguments: GasData(gasolinera['ruta']));
              },
            ),
          ),
        ],
      ),
    )).toList();
  }

}