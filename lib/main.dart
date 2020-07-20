import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_app/db_helper.dart';
import 'package:sqlite_app/db_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => DBHelper(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: DBPage(),
      ),
    ),
  );
}
