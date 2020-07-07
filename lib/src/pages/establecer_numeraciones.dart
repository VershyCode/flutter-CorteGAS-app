import 'package:corte_gas/src/pages/seleccionar_bomba.dart';
import 'package:flutter/material.dart';

class EstablecerNumeraciones extends StatefulWidget {
  EstablecerNumeraciones({Key key}) : super(key: key);

  @override
  _EstablecerNumeracionesState createState() => _EstablecerNumeracionesState();
}

class _EstablecerNumeracionesState extends State<EstablecerNumeraciones> {
  int indexes = 0; // Total pistolas despues de init. (Se establece acorde ala iteracion del for que crea los inputs).
  var _iconInput = Icons.line_style;
  var _colorInput = Colors.grey;
  Map<int, FocusNode> _inputFocus = {}; // Focus del TextField.
  Map<int, TextEditingController> _inputControllers = {};  // COntrolador del texto del TextField.

  @override
  void initState() {
    _makeMappers(5); // Creamos los Focus y los controllers.
    super.initState();
  }
  @override
  void dispose() {
    /// Barremos los [_inputControllers] & [_inputFocus] y hacemos el dispose de cada uno.
    for(int i = 0; i < indexes; i++){
      _inputControllers[i].dispose();
      _inputFocus[i].dispose();
    }
    indexes = 0 ;
    super.dispose();
  }
  void _makeMappers(int pistolas){
    /// Creamos los focus y los controllers acorde el numero de pistolas recibido[pistolas].
    for(int i = 0; i < pistolas; i++){
      _inputFocus.addAll({i: FocusNode()});
      _inputControllers.addAll({i: TextEditingController()});
    }
  }
  @override
  Widget build(BuildContext context) {
    final DataExporter args = ModalRoute.of(context).settings.arguments; // Obtenemos el numero de pistolas enviado desde seleccionar bomba.
    return Scaffold(
      backgroundColor: Colors.redAccent[100],
      appBar: AppBar(
        elevation: 10.0,
        leading: Icon(Icons.touch_app, size: 40.0),
        title: Text('Numeraciones de entrada'),
        backgroundColor: Colors.teal,
      ),
      body: _generarFields(args.pistolas), // Enviamos a generarFields las pistolas de la bomba seleccionada.
    );
  }
  Widget _alerta(){
    // Alerta en error de un input.
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text('Que paso mi despachador? !'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.warning, size: 50.0),
          SizedBox(height: 20.0),
          Text('Asegurate de solo introducir numeros y puntos decimales para poder realizar los calculos.'),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: Text('Ok'),
        )
      ],
    );
  }

   bool _isNumeric(String str) {
    // Evalua si el str es numerico.
    if(str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  void changeIcon(int inputIndex){
    // Evalua el texto del controlador del input.
    if(_isNumeric(_inputControllers[inputIndex].text) && _inputControllers[inputIndex].text.contains('.')){
      _iconInput = Icons.check_circle;
      _colorInput = Colors.green;
    }else{
      _iconInput = Icons.cancel;
      _colorInput = Colors.red;
      showDialog(
        barrierDismissible: false,
        context: context,
        child: _alerta(),
      );
    }
  }
    Widget _generarFields(int pistolas) {
    /// [tempList] guardara un input por cada pistola de la bomba seleccionada.
    List<Widget> tempList = [];
    for(int i = 0; i < pistolas; i++){
      tempList.add(
        /// Agregamos un container decorado que a su vez tiene un child [ClipRRect]
        /// donde recortamos las orillas de los bordes, y que a su vez tiene un child
        /// que viene siendo el input.
       Container(
         margin: EdgeInsets.all(5.0),
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(20.0),
           color: Colors.white,
           boxShadow: <BoxShadow>[
             BoxShadow(
               color: Colors.black26,
               blurRadius: 10.0,
               spreadRadius: 1.0,
             )
           ]
         ),
         child: ClipRRect(
           borderRadius: BorderRadius.circular(30.0),
           child: _inputNumeral(i),
         ),
       )
      );
    }
    tempList.add(
      /// Agregamos un Row extra despues de haber generado los inputs
      /// este row Contendra un boton al final de los inputs para continuar
      /// a la siguiente pagina que serian las numeraciones de salida.
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 10.0, top: 5.0, right: 20.0, left: 20.0),
              child: FlatButton(
                padding: EdgeInsets.all(10.0),
                color: Colors.white,
                onPressed: (){},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.keyboard_tab),
                    Text('Continuar...')
                  ],
                )
              ),
            ),
          )
        ],
      )
    );
    return ListView(
      children: tempList,
    );
  }

  Widget _inputNumeral(int inputIndex){
    /// El input es un container que tiene como child un [TextField].
    /// aqui recibimos el [inputIndex] que viene siendo el iterador del for (cuantas pistolas son).
    indexes = inputIndex;
    return  Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 1.0, right: 5.0, left: 5.0),
      padding: EdgeInsets.all(3.0),
      color: Colors.white,
      child: TextField(
        keyboardType: TextInputType.phone,
        maxLength: 30,
        autofocus: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Inserte aqui numeracion',
          suffixIcon: Icon(_iconInput, color: _colorInput),
          icon: Icon(Icons.format_list_numbered, size: 20.0),
          helperText: 'Inserte acorde hoja de corte.',
          counter: Text('')
        ),
        /// Acorde los [_inputControllers] asignamos el controller de acuerdo al [inputIndex]
        /// el cual nos va permitir seleccionar un [TextEditingController] de la lista para utilizarlo como controlador.
        controller: _inputControllers[inputIndex],
        focusNode: _inputFocus[inputIndex],
        onEditingComplete: (){
          setState(() {
            changeIcon(inputIndex);
            _inputFocus[inputIndex+1].requestFocus();
          });
        },
      ),
    );
  }

}