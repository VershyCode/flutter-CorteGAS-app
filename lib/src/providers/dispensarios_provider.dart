import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
// Tarea: refactorizar este codigo.

class DispensariosProvider{
  List<dynamic> gasolineras = [];
  List<dynamic> dispensariosData = [];

  Future<List<dynamic>> cargarGasolineras(String gasolinera)async{
    final response = await rootBundle.loadString('data/gasolineras.json');
    Map dataMaped = json.decode(response);
    gasolineras = dataMaped['gasolineras']; /// Obtenemos el objeto [gasolineras] del JSON.
    for(int i = 0; i < gasolineras.length; i++){
      /// Barremos todos los objetos que contenga el objeto literal extraido del JSON.
      /// Si en el objeto hay una ruta que coincida con la buscada entonces extraemos
      /// los datos de los dispensarios[info_bombas] y los colocamos en [dispensariosData].
      if(gasolineras[i]['ruta'] == gasolinera){
        dispensariosData = gasolineras[i]['info_bombas'];
        break;
      }else{
        continue;
      }
    }
    return dispensariosData;
  }
}
final dispensariosProvider = new DispensariosProvider();