import 'package:flutter/material.dart';
import 'app_widget.dart';
import 'providers/network_data_provider.dart';

void main() async {
  await NetworkDataProvider().initialize();
  runApp(const MyApp());
}
