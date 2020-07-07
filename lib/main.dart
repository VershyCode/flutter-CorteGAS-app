import 'package:flutter/material.dart';
import 'package:corte_gas/src/pages/establecer_numeraciones.dart';
import 'package:corte_gas/src/pages/home_page.dart';
import 'package:corte_gas/src/pages/seleccionar_bomba.dart';

main() => runApp(CorteGas());

class CorteGas extends StatelessWidget {
  const CorteGas({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Corte Gas',
      initialRoute: '/',
      routes: {
        '/' : (BuildContext context) => Homepage(),
        'seleccionar_bomba': (BuildContext context) => SeleccionarBomba(),
        'establecer_numeraciones': (BuildContext context) => EstablecerNumeraciones(),
      },
    );
  }
}