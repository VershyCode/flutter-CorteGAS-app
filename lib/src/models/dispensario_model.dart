class Dispensario{
  Map<String, double> numeracionesDeEntrada = {};
  Map<String, double> numeracionesDeSalida = {};

  Dispensario({this.numeracionesDeEntrada, this.numeracionesDeSalida}); // Constructor que recibe las numeraciones(Entrada & Salida).

  double litrosVendidos(double numEntrada, double numSalida) => numEntrada - numSalida; // Metodo para calcular los litros vendidos.
  double totalPorLitros(double litros, double precio) => litros * precio; // Metodo para calcular el total de los litros en pesos.
}