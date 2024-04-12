import 'package:flutter/material.dart';

class MyAppBar extends AppBar {

  MyAppBar(String customTitle, {super.key}):super(
    title: Center(
      child: Text(
        customTitle,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        )
      ),
    )
  );
}