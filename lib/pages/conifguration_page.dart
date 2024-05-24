import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:washing_machine_app_v2/keyvalues.dart';
import 'package:washing_machine_app_v2/providers/ble_provider.dart';
import 'package:washing_machine_app_v2/providers/config_provider.dart';
import 'package:washing_machine_app_v2/style/style.dart';

class ConfigPage extends StatelessWidget {
  ConfigPage({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/icons/dashboard.png'), fit: BoxFit.fill),
      ),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: height * 0.06,
              ),
              Text(
                "configure Machine parameter",
                style: TextStyle(
                    color: Colors.grey.shade900,
                    fontWeight: FontWeight.w300,
                    fontSize: 25),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              SetterWidget(
                  height: height,
                  width: width,
                  icon: Icon(Icons.pause, color: Colors.grey.shade700),
                  keyValue: pKeyValue),
              SizedBox(
                height: height * 0.03,
              ),
              SetterWidget(
                  height: height,
                  width: width,
                  icon: Icon(Icons.rotate_left, color: Colors.grey.shade700),
                  keyValue: ccwKeyValue),
              SizedBox(
                height: height * 0.04,
              ),
              SetterWidget(
                  height: height,
                  width: width,
                  icon: Icon(Icons.rotate_right, color: Colors.grey.shade700),
                  keyValue: ccPKeyValue),
            ],
          ),
        ),
      ),
    );
  }
}

class SetterWidget extends StatelessWidget {
  SetterWidget({
    super.key,
    required this.height,
    required this.width,
    required this.icon,
    required this.keyValue,
  });

  final double height;
  final double width;
  final Icon icon;
  final String keyValue;

  int _value = 0;

  @override
  Widget build(BuildContext context) {
    var ble_prov = Provider.of<BleProvider>(context);

    _value = ble_prov.prefIntGetter(keyValue);

    // prov.
    return Container(
      child: Column(
        children: [
          Container(
            height: height * 0.15,
            width: width * 0.4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.only(
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
                BoxShadow(
                  blurRadius: 15.0,
                  color: Colors.white,
                  offset: Offset(-4.0, -4.0),
                  spreadRadius: 1.0,
                )
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  icon,
                  Text(
                    "$_value",
                    style: TextStyle(
                        color: color10,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: height * 0.03,
              ),
              Icon(Icons.keyboard_arrow_left),
              NumberPicker(
                selectedTextStyle: TextStyle(
                    color: const Color.fromRGBO(168, 65, 6, 0.7),
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
                axis: Axis.horizontal,
                textStyle: titleStyle(),
                value: _value,
                minValue: 0,
                maxValue: 5,
                step: 1,
                haptics: true,
                onChanged: (value) {
                  ble_prov.prefIntSetters(keyValue, value);
                },
                // itemHeight: height * 0.03,
                itemWidth: width * .1,
              ),
              Icon(Icons.keyboard_arrow_right),
              SizedBox(
                height: height * 0.03,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
