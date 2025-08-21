import 'package:flutter/material.dart';
import 'package:github_pr_explorer/app/app_view.dart';
import 'package:github_pr_explorer/core/di/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await configureDependencies();

  // Run the application
  runApp(const AppView());
}
