import 'package:fire_hunter/main.dart';
import 'package:fire_hunter/middle_page.dart';
import 'package:fire_hunter/report_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fire Hunter"),
      ),
      backgroundColor: Colors.brown.shade900,
      body: Padding(
        padding: EdgeInsets.only(top: 32),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                    color: Colors.red.shade400,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: () {
                        Navigator.of(context)
                            .push(new MaterialPageRoute<ReportPage>(
                          builder: (BuildContext context) {
                            return MiddlePage();
                          },
                        ));
                      },
                      child: SizedBox(
                        width: 160,
                        height: 160,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fireplace_outlined,
                              color: Colors.white,
                              size: 100,
                            ),
                            Text(
                              "Emmergency",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25))),
                Card(
                    color: Colors.deepOrange.shade400,
                    child: SizedBox(
                      width: 160,
                      height: 160,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.question_answer,
                            color: Colors.white,
                            size: 100,
                          ),
                          Text(
                            "Contribute",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )
                        ],
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)))
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Card(
                      color: Colors.blueGrey.shade200,
                      child: SizedBox(
                        width: 160,
                        height: 160,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.water_drop,
                              color: Colors.white,
                              size: 100,
                            ),
                            Text(
                              "Safety",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                  Card(
                      color: Colors.blueGrey.shade800,
                      child: SizedBox(
                        width: 160,
                        height: 160,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.map,
                              color: Colors.white,
                              size: 100,
                            ),
                            Text(
                              "Impacts",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                    color: Colors.yellow.shade800,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: () {
                        Navigator.of(context)
                            .push(new MaterialPageRoute<MyHomePage>(
                          builder: (BuildContext context) {
                            return MyHomePage(
                              title: "",
                            );
                          },
                        ));
                      },
                      child: SizedBox(
                        width: 160,
                        height: 160,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fmd_good_sharp,
                              color: Colors.white,
                              size: 100,
                            ),
                            Text(
                              "Fire Spots",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25))),
                Card(
                    color: Colors.yellow.shade200,
                    child: SizedBox(
                      width: 160,
                      height: 160,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.question_mark,
                            color: Colors.black,
                            size: 100,
                          ),
                          Text(
                            "Other Infos",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )
                        ],
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)))
              ],
            )
          ],
        ),
      ),
    );
  }
}
