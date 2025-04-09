import 'package:fibonacci_demo/fibonacci/model/fibonacci_model.dart';

abstract class FibonacciState {}

class FibonacciInitial extends FibonacciState {}

class FibonacciLoading extends FibonacciState {}

class FibonacciLoaded extends FibonacciState {
  final List<FibonacciModel> fibonacciList;
  final List<FibonacciModel> selectedOddList;
  final List<FibonacciModel> selectedEvenList;
  final List<FibonacciModel> selectedPrimeList;
  final FibonacciModel? currentlySelectedItem;
  final FibonacciModel? currentlyUnSelectedItem;

  FibonacciLoaded(this.fibonacciList, this.selectedOddList, this.selectedEvenList, this.selectedPrimeList, this.currentlySelectedItem, this.currentlyUnSelectedItem);
}