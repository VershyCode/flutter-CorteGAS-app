import 'package:corte_gas/src/pages/seleccionar_bomba.dart';
import 'package:corte_gas/src/utils/dialog_util.dart';
import 'package:flutter/material.dart';

class EstablecerNumeraciones extends StatefulWidget {
  EstablecerNumeraciones({Key key}) : super(key: key);
  @override
  _EstablecerNumeracionesState createState() => _EstablecerNumeracionesState();
}

class _EstablecerNumeracionesState extends State<EstablecerNumeraciones> {
  int indexes = 0; // Total pistolas despues de init. (Se establece acorde ala iteracion del for que crea los inputs).
  Map<int, FocusNode> _inputFocus = {}; // Focus del TextField.
  Map<int, TextEditingController> _inputControllers = {};  // Controlador del texto del TextField.
  Map<int, IconData> _inputIcon = {}; // Icono de cada input.
  Map<int, MaterialColor> _inputColor = {}; // Color de cada input.
  Map<int, String> _inputType = {};
  Map<int, double> numeracionesDeEntrada = {};
  Map<int, double> numeracionesDeSalida = {};
  bool selected = false;
  String pageTitle = 'Numeraciones de Entrada';

  @override
  void initState() {
    _makeMappers(4); // Creamos los Focus y los controllers.
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
    selected = false;
    super.dispose();
  }

  void _makeMappers(int pistolas){
    /// Creamos los focus y los controllers acorde el numero de pistolas recibido[pistolas].
    for(int i = 0; i < pistolas; i++){
      _inputFocus.addAll({i: FocusNode()}); // Focus independiente en cada input.
      _inputControllers.addAll({i: TextEditingController()}); // Controller independiente de cada input.
      _inputIcon.addAll({i: Icons.line_style}); // Icon independiente de cada input.
      _inputColor.addAll({i: Colors.grey});
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
        title: Text(pageTitle),
        backgroundColor: Colors.teal,
      ),
      body: _generarFields(args.pistolas, args.types), // Enviamos a generarFields las pistolas de la bomba seleccionada.
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
      _inputIcon[inputIndex] = Icons.check_circle;
      _inputColor[inputIndex] = Colors.green;
    }else{
      _inputIcon[inputIndex] = Icons.cancel;
      _inputColor[inputIndex] = Colors.red;
    }
  }

  bool isFieldOnError(){
    bool error = false;
    for(int i = 0; i < _inputControllers.length; i++){
      if(_inputControllers[i].text == '' || !_isNumeric(_inputControllers[i].text)){
        ///
        /// Si el inputController esta vacio o no es numerico entonces retornamos que si esta en un error.
        ///
        error = true;
        _inputFocus[i].requestFocus();
        break;
      }
    }
    return error;
  }

  Widget _generarFields(int pistolas, List<dynamic> types) {
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
           child: _inputNumeral(i, types),
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
              // Boton al final de las numeraciones.
              child: FlatButton(
                padding: EdgeInsets.all(10.0),
                color: Colors.white,
                onPressed: (){
                  if(isFieldOnError()){ // Alguna textbox tiene error?
                    numeracionesIncorrectasAlert(context);
                  }else{
                    ///
                    /// Si las numeraciones son aceptables entonces
                    /// Guardamos las numeraciones de entrada y limpiamos los textfield.
                    /// A continuacion pediremos las de salida.
                    ///
                    if(pageTitle == 'Numeraciones de salida'){
                      print('==================================  FINALIZO  ===================================================== ');
                      for(int i = 0; i < _inputControllers.length; i++){
                        numeracionesDeSalida.addAll({i: double.parse(_inputControllers[i].text)});
                      }
                      corteExitosoAlert(context);
                    }else{
                      numeracionesCorrectasAlert(context);
                      for(int i = 0; i < _inputControllers.length; i++){
                        numeracionesDeEntrada.addAll({i: double.parse(_inputControllers[i].text)});
                        setState(() {
                          _inputControllers[i].text = '';
                          pageTitle = 'Numeraciones de salida';
                          _inputFocus[0].requestFocus();
                        });
                      }
                    }
                  }
                },
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

  Widget _inputNumeral(int inputIndex, List<dynamic> types){
    /// El input es un container que tiene como child un [TextField].
    /// aqui recibimos el [inputIndex] que viene siendo el iterador del for (cuantas pistolas son).
    indexes = inputIndex;
    if(types != null){ // Si types esta cargado con los tipos de pistolas.
      setState(() {
        ////
        /// [selected] va a manejar si ya fue seleccionada la magna o la premium donde true = prem y false = magna.
        /// 
        /// De primera selected sera false por lo tanto se seleccionara magna y se implementara al field.
        if(types.length < 3){ // Es de 2 pistolas?
          if(selected){
            _inputType.addAll({inputIndex: types[1]}); // Premium.
            selected = false; // Proxima iteracion se selecciona magna.
          }else{
            _inputType.addAll({inputIndex: types[0]}); // Magna.
            selected = true; // Proxima iteracion se selecciona premium.
          }
        }
      });
    }
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
          suffixIcon: Icon(_inputIcon[inputIndex], color: _inputColor[inputIndex]),
          icon: Icon(Icons.format_list_numbered, size: 20.0),
          helperText: 'Inserte acorde hoja de corte.',
          counter: Text(_inputType[inputIndex])
        ),
        /// Acorde los [_inputControllers] asignamos el controller de acuerdo al [inputIndex]
        /// el cual nos va permitir seleccionar un [TextEditingController] de la lista para utilizarlo como controlador.
        controller: _inputControllers[inputIndex],
        focusNode: _inputFocus[inputIndex],
        onChanged: (value){
          setState(() {
            changeIcon(inputIndex); // Validamos los datos introducidos.
          });
        },
        onEditingComplete: (){
          _inputFocus[inputIndex+1].requestFocus(); // Hacemosfocus al Focus con el index +1 para seleccionar el siguiente.
        },
      ),
    );
  }
}