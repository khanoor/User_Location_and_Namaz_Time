import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

String CurrentDate = DateFormat("dd-MM-yyyy").format(DateTime.now());

class _HomeState extends State<Home> {
  void getUserLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print("Permission not given");
      LocationPermission asked = await Geolocator.requestPermission();
    } else {
      Position currentposition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      print("lat: " + currentposition.latitude.toString());
      print("lon: " + currentposition.longitude.toString());
      var lat = currentposition.latitude.toString();
      var lon = currentposition.longitude.toString();
      namaztime(lat, lon);
    }
  }

  List data = [];
  Future<String?> namaztime(lat, lon) async {
    var response = await http.get(
      Uri.parse(
          'https://api.aladhan.com/v1/calendar?latitude=$lat&longitude=$lon'),
    );
    var convert_data_to_json = json.decode(response.body);
    // var request = new http.MultipartRequest(lat, lon);
    // request.fields["latitude"] = lat;
    // request.fields["longitude"] = lon;
    setState(() {
      data = convert_data_to_json['data'];
    });
    // print(data);
  }

  Future<void> getCurrent(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      // firstDate: DateTime.now().subtract(const Duration(days: 0)),
      firstDate: DateTime(2010),
      lastDate: DateTime(3000),
    );
    if (date != null) {
      setState(() {
        CurrentDate = DateFormat("dd-MM-yyyy").format(date);
      });
    }
  }

  @override
  void initState() {
    getUserLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Location"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  getUserLocation();
                },
                child: Text("User Location")),
            SizedBox(
              height: 20,
            ),
            // IconButton(
            //   icon: Icon(
            //     Icons.calendar_month_outlined,
            //   ),
            //   onPressed: () {
            //     print(getCurrent(context));
            //     print(CurrentDate);
            //   },
            // ),
            Text(CurrentDate),
            SizedBox(
              height: 20,
            ),
            data.length > 0 ?
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Fjar:    "),
                    Text(data[0]['timings']['Fajr'].toString()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Zuhar"),
                    Text(data[0]['timings']['Dhuhr'].toString()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Asr"),
                    Text(data[0]['timings']['Asr'].toString())
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Maghrib"),
                    Text(data[0]['timings']['Maghrib'].toString())
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Isha"),
                    Text(data[0]['timings']['Isha'].toString())
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Sunrise",
                      style: TextStyle(color: Colors.red),
                    ),
                    Text(
                      data[0]['timings']['Sunrise'].toString(),
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Sunset",
                      style: TextStyle(color: Colors.red),
                    ),
                    Text(
                      data[0]['timings']['Sunset'].toString(),
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
              ],
            ) : Container(child: Text("wait"),)
          ],
        ),
      ),
    );
  }
}
