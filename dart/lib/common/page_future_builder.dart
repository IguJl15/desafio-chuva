import 'package:flutter/material.dart';

class PageBuilder<A, T> extends StatefulWidget {
  const PageBuilder({
    required this.arg,
    required this.builder,
    required this.future,
    super.key,
  });

  final A arg;
  final Future<T> Function(A arg) future;
  final Widget Function(BuildContext context, T data) builder;

  @override
  State<PageBuilder> createState() => _PageBuilderState<A, T>();
}

class _PageBuilderState<A, T> extends State<PageBuilder<A, T>> {
  T? data;
  bool finished = false;

  @override
  void initState() {
    super.initState();

    executeFuture();
  }

  void executeFuture() {
    widget.future(widget.arg).then((value) => setState(() {
          data = value;
          finished = true;
        }));
  }

  @override
  void didUpdateWidget(covariant PageBuilder<A, T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.arg != widget.arg) {
      finished = false;
      executeFuture();
    }
  }

  @override
  Widget build(BuildContext context) {
    return finished
        ? widget.builder(context, data as T)
        : Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
  }
}
