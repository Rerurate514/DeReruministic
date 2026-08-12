import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';

class UiPageWrapper extends StatefulWidget {
  const UiPageWrapper({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(16),
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  @override
  State<UiPageWrapper> createState() => _UiPageWrapperState();
}

class _UiPageWrapperState extends State<UiPageWrapper>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: SafeArea(
        child: AnimatedBackground(
          behaviour: RandomParticleBehaviour(
            options: const ParticleOptions(baseColor: Colors.red),
          ),
          vsync: this,
          child: Padding(
            key: const Key('page_wrapper_padding'),
            padding: widget.padding,
            child: widget.child,
          ),
        ),
      ),
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}
