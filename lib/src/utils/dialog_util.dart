import 'package:flutter/material.dart';

Map<int, TextEditingController> _inputControllers = {
  0: TextEditingController(),
  1: TextEditingController()
};  // Controlador del texto del TextField.

void numeracionesIncorrectasAlert(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false, // Cerrar alerta con tap afuera.
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text('OJO!!! BOMERO!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.error, size: 100),
              SizedBox(height: 25),
              Text('No puedes continuar si dejas campos vacios o pones caracteres que no son numeros.', textAlign: TextAlign.justify),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: Text('Ok'),
            )
          ],
        );
      }
    );
  } 

  void numeracionesCorrectasAlert(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false, // Cerrar alerta con tap afuera.
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text('Excelente vaquero !!!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.favorite, size: 100),
              SizedBox(height: 25),
              Text('Ahora inserta las numeraciones de salida...', textAlign: TextAlign.justify),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: Text('Ok'),
            )
          ],
        );
      }
    );
  } 

  void corteExitosoAlert(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false, // Cerrar alerta con tap afuera.
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.local_atm, size: 70),
              SizedBox(height: 25),
              _inputPrice('Magna', 0), //r
              _inputPrice('Premium', 1), //r
            ],
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                // REFACTORIZAR PARA AUTOMATIZAR CODIGO.
                _loadingIndicator();
              }, 
              child: Text('Ver resultados'),
            )
          ],
        );
      }
    );
  }

Widget _loadingIndicator() {
  return Container(
    height: 400,
    padding: EdgeInsets.all(25),
    child: CircularProgressIndicator()
  );
} 

Widget _inputPrice(String combustible, int controller) {
  return Container(
    padding: EdgeInsets.only(right: 20),
    child: TextField(
        keyboardType: TextInputType.phone,
        maxLength: 30,
        autofocus: false,
        controller: _inputControllers[controller],
        decoration: InputDecoration(
          icon: Icon(Icons.attach_money, size: 30),
          border: OutlineInputBorder(),
          labelText: 'Precio de $combustible',
          counter: Text('')
        ),
      ),
  );
} 