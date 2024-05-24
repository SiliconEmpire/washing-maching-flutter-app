import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:washing_machine_app_v2/keyvalues.dart';
import 'package:washing_machine_app_v2/providers/ble_provider.dart';
import 'package:washing_machine_app_v2/providers/config_provider.dart';

import '../style/style.dart';

class MainPage extends StatelessWidget {
  MainPage({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  int _circlesValue = 0;

  @override
  Widget build(BuildContext context) {
    var ble_prov = Provider.of<BleProvider>(context);

    _circlesValue = ble_prov.prefIntGetter(circleskeyValue);

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/icons/dashboard.png'), fit: BoxFit.fill),
      ),
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: height * 0.06,
            ),
            Center(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/icons/logo.png'),
                      fit: BoxFit.fill),
                ),
                height: height * 0.06,
                width: width * 0.3,
              ),
            ),
            Text("Smart Washing Machine App", style: subtitleStyle()),
            SizedBox(
              height: height * 0.06,
            ),
            Column(
              children: [
                Container(
                  height: height * 0.15,
                  width: width * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 15.0,
                        color: Colors.grey.shade500,
                        offset: Offset(4.0, 4.0),
                        spreadRadius: 1.0,
                      ),
                      const BoxShadow(
                        blurRadius: 15.0,
                        color: Colors.white,
                        offset: Offset(-4.0, -4.0),
                        spreadRadius: 1.0,
                      )
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Circles:",
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w300,
                              fontSize: 20),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "${_circlesValue}",
                              style: TextStyle(
                                  color: color10,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 30),
                            ),
                            Text(
                              "${ble_prov.remainingCircles ?? 0}",
                              style: TextStyle(
                                color: color10,
                                fontWeight: FontWeight.w500,
                                fontSize: 30,
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   height: height * 0.002,
                        // )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.keyboard_arrow_left),
                    NumberPicker(
                      selectedTextStyle: TextStyle(
                          color: const Color.fromRGBO(168, 65, 6, 0.7),
                          fontWeight: FontWeight.bold,
                          fontSize: 40),
                      axis: Axis.horizontal,
                      textStyle: titleStyle(),
                      value: _circlesValue,
                      minValue: 0,
                      maxValue: 100,
                      step: 1,
                      haptics: true,
                      onChanged: (value) {
                        ble_prov.prefIntSetters(circleskeyValue, value);
                      },
                      // itemHeight: height * 0.03,
                      itemWidth: width * .15,
                    ),
                    Icon(Icons.keyboard_arrow_right),
                  ],
                ),
                Container(
                  height: height * 0.2,
                  width: width * 0.4,
                  margin: EdgeInsets.all(100.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 15.0,
                        color: Colors.grey.shade500,
                        offset: Offset(4.0, 4.0),
                        spreadRadius: 1.0,
                      ),
                      BoxShadow(
                        blurRadius: 15.0,
                        color: Colors.white,
                        offset: Offset(-4.0, -4.0),
                        spreadRadius: 1.0,
                      )
                    ],
                  ),
                  child: Center(
                    child: ble_prov.status
                        ? InkWell(
                            splashColor: color30,
                            onLongPress: () {
                              ble_prov.sendData(false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Paused'),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.pause_circle,
                              color: const Color.fromRGBO(168, 65, 6, 0.7),
                              size: width * 0.3,
                            ),
                          )
                        : InkWell(
                            splashColor: color30,
                            onLongPress: () {
                              ble_prov.sendData(true);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Play'),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.play_circle,
                              color: const Color.fromRGBO(168, 65, 6, 0.7),
                              size: width * 0.3,
                            ),
                          ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
