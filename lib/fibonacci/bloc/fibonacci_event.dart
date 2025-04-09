import '../model/fibonacci_model.dart';

abstract class FibonacciEvent {}

class GenerateFibonacci extends FibonacciEvent {
  final int count;
  GenerateFibonacci({required this.count});
}

class SelectFibonacciItem extends FibonacciEvent {
  final FibonacciModel item;

  SelectFibonacciItem({required this.item});
}

class UnSelectFibonacciItem extends FibonacciEvent {
  final FibonacciModel item;

  UnSelectFibonacciItem({required this.item});
}