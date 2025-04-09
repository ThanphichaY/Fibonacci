import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/fibonacci_model.dart';
import 'fibonacci_event.dart';
import 'fibonacci_state.dart';


class FibonacciBloc extends Bloc<FibonacciEvent, FibonacciState> {
  FibonacciBloc() : super(FibonacciInitial()) {
    on<GenerateFibonacci>(_onGenerateFibonacci);
    on<SelectFibonacciItem>(_onSelectFibonacciItem);
    on<UnSelectFibonacciItem>(_onUnSelectFibonacciItem);
  }

  void _onGenerateFibonacci(
      GenerateFibonacci event, Emitter<FibonacciState> emit) {
    emit(FibonacciLoading());

    final sequence = _generateFibonacci(event.count)
        .asMap()
        .entries
        .map((entry) => _createFibonacciModel(entry.value, entry.key))
        .toList();

    emit(FibonacciLoaded(sequence, [], [], [], null, null));
  }

  void _onSelectFibonacciItem(
      SelectFibonacciItem event, Emitter<FibonacciState> emit) {
    if (state is FibonacciLoaded) {
      final current = state as FibonacciLoaded;
      final item = event.item;
      final updatedMainList = List<FibonacciModel>.from(current.fibonacciList)
        ..remove(item);
      final updatedOdd = List<FibonacciModel>.from(current.selectedOddList);
      final updatedEven = List<FibonacciModel>.from(current.selectedEvenList);
      final updatedPrime = List<FibonacciModel>.from(current.selectedPrimeList);
      switch (item.type) {
        case FibonacciType.prime:
          updatedPrime.add(item);
          break;
        case FibonacciType.even:
          updatedEven.add(item);
          break;
        case FibonacciType.odd:
          updatedOdd.add(item);
          break;
      }

      emit(FibonacciLoaded(
        updatedMainList,
        updatedOdd,
        updatedEven,
        updatedPrime,
        item,
        current.currentlyUnSelectedItem
      ));
    }
  }

  void _onUnSelectFibonacciItem(
      UnSelectFibonacciItem event, Emitter<FibonacciState> emit) {
    if (state is FibonacciLoaded) {
      final current = state as FibonacciLoaded;
      final item = event.item;
      final updatedMainList = List<FibonacciModel>.from(current.fibonacciList)
        ..add(item);
      updatedMainList.sort((a, b) => a.originalIndex.compareTo(b.originalIndex));
      final updatedOdd = List<FibonacciModel>.from(current.selectedOddList);
      final updatedEven = List<FibonacciModel>.from(current.selectedEvenList);
      final updatedPrime = List<FibonacciModel>.from(current.selectedPrimeList);
      switch (item.type) {
        case FibonacciType.prime:
          updatedPrime.remove(item);
          break;
        case FibonacciType.even:
          updatedEven.remove(item);
          break;
        case FibonacciType.odd:
          updatedOdd.remove(item);
          break;
      }
      emit(FibonacciLoaded(
        updatedMainList,
        updatedOdd,
        updatedEven,
        updatedPrime,
        current.currentlySelectedItem,
        item
      ));
    }
  }

  List<int> _generateFibonacci(int count) {
    if (count <= 0) return [];
    if (count == 1) return [0];
    List<int> fib = [0, 1];
    while (fib.length < count) {
      fib.add(fib[fib.length - 1] + fib[fib.length - 2]);
    }
    return fib;
  }

  bool _isPrime(int number) {
    if (number < 2) return false;
    for (int i = 2; i <= number ~/ 2; i++) {
      if (number % i == 0) return false;
    }
    return true;
  }

  FibonacciModel _createFibonacciModel(int value, int index) {
    final type = _getType(value);
    final icon = _getIcon(type);

    return FibonacciModel(
      value: value,
      icon: icon,
      type: type,
      originalIndex: index
    );
  }

  FibonacciType _getType(int number) {
    if (_isPrime(number)) return FibonacciType.prime;
    if (number % 2 == 0) return FibonacciType.even;
    return FibonacciType.odd;
  }

  IconData _getIcon(FibonacciType type) {
    switch (type) {
      case FibonacciType.prime:
        return Icons.close;
      case FibonacciType.even:
        return Icons.square;
      case FibonacciType.odd:
        return Icons.circle;
    }
  }
}