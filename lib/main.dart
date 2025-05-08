import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() => runApp(MaterialApp(home: WeatherApp()));

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String city = "Tangerang"; // Ubah sesuai lokasi
  String apiKey = "025c2b06325e1999940076fbe5ba06b1"; // Ganti dengan API key kamu
  double temperature = 0.0;
  String description = "";
  double minTemp = 0.0;
  double maxTemp = 0.0;
  String _time = '';

  @override
  void initState() {
    super.initState();
    fetchWeather();
    _updateTime();
  }

  void _updateTime() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final formattedTime = DateFormat('HH:mm:ss').format(now);
      setState(() {
        _time = formattedTime;
      });
    });
  }

  Future<void> fetchWeather() async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        temperature = data['main']['temp'];
        description = data['weather'][0]['description'];
        minTemp = data['main']['temp_min'];
        maxTemp = data['main']['temp_max'];
      });
    } else {
      print("Failed to fetch weather data");
    }
  }

  String getFormattedDate() {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, MMMM d, yyyy');
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF80DEEA), Color(0xFF0288D1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              city,
              style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              getFormattedDate(),
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            Text(
              _time,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 40),
            Text(
              '${temperature.toStringAsFixed(1)}°C',
              style: TextStyle(fontSize: 80, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Divider(color: Colors.white70, indent: 80, endIndent: 80),
            SizedBox(height: 20),
            Text(
              '${description[0].toUpperCase()}${description.substring(1)}',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              '${minTemp.toStringAsFixed(1)}°C / ${maxTemp.toStringAsFixed(1)}°C',
              style: TextStyle(fontSize: 20, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
