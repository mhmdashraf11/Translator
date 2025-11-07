import 'package:flutter/material.dart';

BoxDecoration cardDecoration() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.shade300,
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ],
);
