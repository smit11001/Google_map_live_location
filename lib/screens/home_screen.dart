import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Placemark? placemark;

  requestPermission() async {
    await Permission.location.request();
  }

  @override
  initState(){
    super.initState();
    requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Task'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://media.istockphoto.com/photos/mountain-landscape-picture-id517188688?k=20&m=517188688&s=612x612&w=0&h=i38qBm2P-6V4vZVEaMy_TaTEaoCMkYhvLCysE7yJQ5Q='),
                  fit: BoxFit.cover,
                  opacity: 0.2,
                )
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/maplogo.png"),
                const SizedBox(height: 120),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    textStyle: const TextStyle(fontSize: 17,fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    Geolocator.getPositionStream().listen((Position position) {
                      setState((){
                        lat = position.latitude;
                        long = position.longitude;
                      });
                      Navigator.of(context).pushReplacementNamed('map');
                    });
                  },
                  child: const Text('Check Location'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
