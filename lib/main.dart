import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/utils/theme.dart';
import 'feature/presentation/bloc/custom_navbar/custom_navbar_bloc.dart';
import 'feature/presentation/pages/screen_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: BlocProvider(
        create: (_) => CustomNavbarBloc(),
        child: const ScreenHomePage(),
      ),
    );
  }
}
