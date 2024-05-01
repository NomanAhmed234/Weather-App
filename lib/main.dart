import 'dart:convert';
import 'dart:ui';

import 'package:api/colors.dart';
import 'package:api/current_date.dart';
import 'package:api/current_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String iconBaseUrl = 'http://openweathermap.org/img/wn/';
  String getIconUrl(String iconCode) {
    return '$iconBaseUrl$iconCode.png';
  }

  TextEditingController _controller = TextEditingController();
  Future<Map<String, dynamic>> getPostApi(String cityName) async {
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=3ef5d9be34fcfcffe80e3f3d4c82f93a');

    var response = await http.get(url);
    var responseBody = jsonDecode(response.body);
    return responseBody;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.darkgrey,
      appBar: AppBar(
          backgroundColor: CustomColors.darkgrey,
          title: Column(
            children: [
              // CurrentDateWidget(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: SearchBar(
                    backgroundColor: MaterialStateProperty.all<Color?>(
                      CustomColors
                          .mediumgrey, // Set the background color you want
                    ),
                    hintText: "Search city here",
                    leading: Icon(
                      Icons.location_on,
                      color: CustomColors.darkgrey,
                    ),
                    onSubmitted: (cityName) {
                      setState(() {
                        String cityName = _controller.text.trim();
                        var weatherData = getPostApi(cityName);
                      });
                    },
                    controller: _controller,
                  ),
                ),
              ),
            ],
          )),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage('assets/images/rainy_weather.png'),
              //   fit: BoxFit.cover,
              // ),
              ),
          child: FutureBuilder<Map<String, dynamic>>(
            future: _controller.text.isEmpty
                ? getPostApi(
                    'Karachi') // Default to 'Karachi' if text field is empty
                : getPostApi(_controller.text), // Pass cityName from text field
            builder: (context, snapshot) {
              // Icon code from the API response

              // Constructing the URL for the icon image

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.green,
                ));
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final weatherData = snapshot.data!['main'];
                final weatherDataName = snapshot.data!['name'];
                final country = snapshot.data!['sys']['country'];
                final weather = snapshot.data!['weather'];
                final wind = snapshot.data!['wind'];
                final pressure = snapshot.data!['main'];
                String iconCode = weather[0]['icon'];
                String iconUrl =
                    "http://openweathermap.org/img/wn/$iconCode@4x.png";

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: SearchBar(
                        //     hintText: "Search city here",
                        //     leading: Icon(
                        //       Icons.location_on,
                        //       color: Colors.white,
                        //     ),
                        //     onSubmitted: (cityName) {
                        //       setState(() {
                        //         String cityName = _controller.text.trim();
                        //         var weatherData = getPostApi(cityName);
                        //         cityName = '';
                        //         // Pass cityName as an argument
                        //       });
                        //     },
                        //     controller: _controller,
                        //   ),
                        // ),

                        SizedBox(height: 20),
                        Container(
                          child: Image.network(
                            iconUrl,
                            width: 200,
                            height: 200,
                            //color: Colors.white,
                            fit: BoxFit.contain,
                            // You can add other properties like alignment, etc.
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${weatherDataName},${country}',
                              style: TextStyle(
                                  color: CustomColors.greylight,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Card(
                              elevation: 0, // Remove shadow
                              color: Colors
                                  .transparent, // Make the card transparent
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 5.0, sigmaY: 5.0),
                                  child: Container(
                                    padding: EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      border: Border.all(
                                          width: 0.50, color: Colors.green),
                                      color: CustomColors.mediumgrey
                                          .withOpacity(
                                              0.4), // Adjust opacity as needed
                                    ),
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              '${weather[0]['description']}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            Text(
                                              '${(weatherData['temp'] - 273.15).toInt()}°',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 60,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.opacity,
                                                      color: CustomColors
                                                          .greylight,
                                                      size: 20,
                                                    ),
                                                    Text(
                                                      weatherData['humidity']
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: CustomColors
                                                              .greylight,
                                                          fontSize: 17),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.speed,
                                                      color: CustomColors
                                                          .greylight,
                                                      size: 20,
                                                    ),
                                                    Text(
                                                      '${(wind['speed'] * 3.6).toStringAsFixed(2)}km/h',
                                                      style: TextStyle(
                                                          color: CustomColors
                                                              .greylight,
                                                          fontSize: 17),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.thermostat_outlined,
                                                      color: CustomColors
                                                          .greylight,
                                                      size: 20,
                                                    ),
                                                    Text(
                                                      pressure['pressure']
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: CustomColors
                                                              .greylight,
                                                          fontSize: 17),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Card(
                          elevation: 0, // Remove shadow
                          color:
                              Colors.transparent, // Make the card transparent
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                              child: Container(
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  border: Border.all(
                                      width: 0.50, color: Colors.green),
                                  color: CustomColors.mediumgrey.withOpacity(
                                      0.4), // Adjust opacity as needed
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          children: [
                                            // SvgPicture.asset(
                                            //   'assets/images/08_wet_line.svg',
                                            //   width: 20,
                                            //   height: 20,
                                            // ),
                                            Text(
                                              'Min ${(weatherData['temp_min'] - 273.15).toInt()}°',
                                              style: TextStyle(
                                                  color: CustomColors.greylight,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            // SvgPicture.asset(
                                            //   'assets/images/38_sandstorm_line.svg',
                                            //   width: 20,
                                            //   height: 20,
                                            // ),
                                            Text(
                                              'Feel like ${(weatherData['feels_like'] - 273.15).toInt()}°',
                                              style: TextStyle(
                                                  color: CustomColors.greylight,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            // Icon(
                                            //   Icons.thermostat_outlined,
                                            //   color: Colors.white,
                                            //   size: 20,
                                            // ),
                                            Text(
                                              'Max ${(weatherData['temp_max'] - 273.15).toInt()}°',
                                              style: TextStyle(
                                                  color: CustomColors.greylight,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
