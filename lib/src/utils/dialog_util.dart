import 'package:flutter/material.dart';

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