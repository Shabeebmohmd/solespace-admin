import 'package:flutter/material.dart';

class CustomGridView extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int crossAxisCount;
  final double childAspectRatio;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;

  const CustomGridView({
    super.key,
    required this.children,
    this.spacing = 10.0,
    this.runSpacing = 10.0,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.0,
    this.padding,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding ?? const EdgeInsets.all(16.0),
      physics: physics ?? const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}