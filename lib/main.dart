import 'package:flutter/material.dart';
import 'package:sqlite_app/db_page.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: DBPage(),
    ),
  );
}
