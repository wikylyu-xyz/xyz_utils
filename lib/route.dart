import 'package:flutter/material.dart';

class DefaultMaterialPageRoute<T> extends MaterialPageRoute<T> {
  final Duration duration;
  DefaultMaterialPageRoute({
    required WidgetBuilder builder,
    this.duration = const Duration(milliseconds: 500),
    RouteSettings? settings,
  }) : super(builder: builder, settings: settings);
  @override
  Duration get transitionDuration => duration;
}
