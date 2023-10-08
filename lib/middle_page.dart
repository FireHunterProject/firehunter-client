import 'package:fire_hunter/const.dart';
import 'package:fire_hunter/report_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MiddlePage extends StatefulWidget {
  const MiddlePage({super.key});

  @override
  State<MiddlePage> createState() => _MiddlePageState();
}

class _MiddlePageState extends State<MiddlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade900,
      appBar: AppBar(        
        title: Text('Register Emergency'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 50,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 90,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // Define a cor vermelha
                ),
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute<ReportPage>(
                    builder: (BuildContext context) {
                      return ReportPage(userLastlcoation: Constants.mockLocation);
                    },
                  ));
                },
                child: Text('Forest Fire', style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 30,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 90,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange, // Define a cor vermelha
                ),
                onPressed: () {
                  // Button click action
                },
                child: Text('Agricultural Fire', style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 30,),
             Container(
              width: MediaQuery.of(context).size.width,
              height: 90,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red.shade300, // Define a cor vermelha
                ),
                onPressed: () {
                  // Button click action
                },
                child: Text('Fire with possible victim', style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 30,),
             Container(
              width: MediaQuery.of(context).size.width,
              height: 90,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange.shade300, // Define a cor vermelha
                ),
                onPressed: () {
                  // Button click action
                },
                child: Text('Roadside Fire', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
