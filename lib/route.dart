import 'package:flutter/material.dart';

class DefaultMaterialPageRoute<T> extends MaterialPageRoute<T> {
  final Duration duration;
  DefaultMaterialPageRoute({
    required super.builder,
    this.duration = const Duration(milliseconds: 500),
    super.settings,
  });
  @override
  Duration get transitionDuration => duration;
}
