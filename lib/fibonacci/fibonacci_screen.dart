import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/fibonacci_bloc.dart';
import 'bloc/fibonacci_event.dart';
import 'bloc/fibonacci_state.dart';
import 'model/fibonacci_model.dart';

class FibonacciScreen extends StatefulWidget {
  const FibonacciScreen({super.key, required this.title});
  final String title;

  @override
  State<FibonacciScreen> createState() => _FibonacciScreenState();
}

class _FibonacciScreenState extends State<FibonacciScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<FibonacciBloc>().add(GenerateFibonacci(count: 40));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: BlocListener<FibonacciBloc, FibonacciState>(
        listenWhen: (previous, current) =>
        current is FibonacciLoaded &&
            current.currentlyUnSelectedItem != null &&
            current.currentlyUnSelectedItem !=
                (previous as FibonacciLoaded?)?.currentlyUnSelectedItem,
        listener: (context, state) {
          if (state is FibonacciLoaded &&
              state.currentlyUnSelectedItem != null) {
            final item = state.currentlyUnSelectedItem!;
            final index =
            state.fibonacciList.indexWhere((e) => e == item);
            if (index != -1) {
              _scrollController.animateTo(
                index * 40.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          }
        },
        child: BlocBuilder<FibonacciBloc, FibonacciState>(
          builder: (context, state) {
            if (state is FibonacciLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FibonacciLoaded) {
              return ListView.builder(
                controller: _scrollController,
                itemCount: state.fibonacciList.length,
                itemBuilder: (context, index) {
                  final item = state.fibonacciList[index];
                  final isRecentlyUnselected =
                      item == state.currentlyUnSelectedItem;

                  return Container(
                    color: isRecentlyUnselected
                        ? Colors.red.withOpacity(0.2)
                        : null,
                    child: ListTile(
                      trailing: Icon(item.icon),
                      title: Text(
                          'Fibonacci(${item.originalIndex + 1}) = ${item.value}'),
                      onTap: () {
                        context
                            .read<FibonacciBloc>()
                            .add(SelectFibonacciItem(item: item));

                        Future.delayed(
                            const Duration(milliseconds: 100), () {
                          final state = context.read<FibonacciBloc>().state
                          as FibonacciLoaded;
                          List<FibonacciModel> selectedList;
                          switch (item.type) {
                            case FibonacciType.prime:
                              selectedList = state.selectedPrimeList;
                              break;
                            case FibonacciType.even:
                              selectedList = state.selectedEvenList;
                              break;
                            case FibonacciType.odd:
                            default:
                              selectedList = state.selectedOddList;
                              break;
                          }

                          final currentlySelected =
                              state.currentlySelectedItem;

                          showModalBottomSheet(
                            context: context,
                            builder: (_) => StatefulBuilder(
                              builder: (context, setModalState) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: selectedList.map((e) {
                                      final isCurrent =
                                          e == currentlySelected;
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: isCurrent
                                              ? Colors.green
                                              .withOpacity(0.2)
                                              : null,
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: ListTile(
                                          trailing: Icon(e.icon),
                                          title: Text(
                                              'Fibonacci(${e.originalIndex + 1}) = ${e.value}'),
                                          onTap: () {
                                            context
                                                .read<FibonacciBloc>()
                                                .add(UnSelectFibonacciItem(
                                                item: e));
                                            Navigator.pop(context);
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              },
                            ),
                          );
                        });
                      },
                    ),
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}