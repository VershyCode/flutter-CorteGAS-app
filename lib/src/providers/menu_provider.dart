import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class _MenuProvider{
  List<dynamic> gasolineras = [];

  Future<List<dynamic>> cargarGasolineras()async{
    final response = await rootBundle.loadString('data/gasolineras.json');
    Map dataMaped = json.decode(response);
    gasolineras = dataMaped['gasolineras'];
    return gasolineras;
  }
}
final menuProvider = new _MenuProvider();