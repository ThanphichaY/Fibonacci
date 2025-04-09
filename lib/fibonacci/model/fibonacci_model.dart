import 'package:flutter/material.dart';

class FibonacciModel {
  final int value;
  final IconData icon;
  final FibonacciType type;
  final int originalIndex;

  FibonacciModel({required this.value, required this.icon, required this.type, required this.originalIndex});

  List<Object> get props => [value, type, originalIndex];
}

enum FibonacciType { odd, even, prime }