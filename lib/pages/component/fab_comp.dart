import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:washing_machine_app_v2/providers/ble_provider.dart';
import 'package:washing_machine_app_v2/style/style.dart';

class FAButton extends StatelessWidget {
  const FAButton({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    BleProvider prov = Provider.of<BleProvider>(context);

    return FloatingActionButton(
      backgroundColor: color10,
      onPressed: () {
        prov.disconnectGetter;
        prov.startScanGetter;

        if ((prov.blePowerdOff == true) ||
            (prov.locationServiceEnabled == false)) {
          showCupertinoDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) => AlertDialog(
              title:
                  const Text('Bluetooth and/or Location Service is turned off'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    // const Text('Bluetooth and/or Location Service is turned off'),
                    const Text(
                        'Bluetooth and Location Service is required for this app to function properly.'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        } else {
          modalBotomSheet(context).then(
            (value) {
              // Code to be executed when the modal bottom sheet is closed.
              prov.stopScanGetter;
            },
          );
        }
      },
      child: Consumer<BleProvider>(
        builder: (context, prov, child) => prov.connected
            ? Icon(
                Icons.bluetooth_connected,
                color: color60,
              )
            : Icon(
                Icons.bluetooth_disabled,
                color: color60,
              ),
      ),
    );
  }

  Future<dynamic> modalBotomSheet(
    BuildContext context,
  ) {
    return showModalBottomSheet(
      backgroundColor: Colors.white,
      enableDrag: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Consumer<BleProvider>(
                    builder: (context, prov, child) {
                      if (prov.scanning == true) {
                        return Icon(
                          Icons.wifi_protected_setup_sharp,
                          color: Colors.grey[600],
                          size: 40,
                        );
                      } else if (prov.connecting == true) {
                        return Icon(
                          Icons.bluetooth_searching_outlined,
                          color: Colors.grey[600],
                          size: 40,
                        );
                      } else if (prov.connected == true) {
                        return Icon(
                          Icons.bluetooth_connected,
                          color: Colors.grey[600],
                          size: 40,
                        );
                      } else {
                        return Icon(
                          Icons.bluetooth_disabled_outlined,
                          color: Colors.grey[600],
                          size: 40,
                        );
                      }
                    },
                  ),
                  Consumer<BleProvider>(
                    builder: (context, prov, child) {
                      if (prov.scanning == true) {
                        return Text(
                          "scanning...",
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 20),
                        );
                      } else if (prov.connecting == true) {
                        return Text(
                          "Connecting...",
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 20),
                        );
                      } else if (prov.connected == true) {
                        return Text(
                          "Connected",
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 20),
                        );
                      } else {
                        return SizedBox(
                          height: size.height * 0.0,
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Consumer<BleProvider>(
                  builder: (context, prov, child) {
                    return SizedBox(
                      height: size.height * 0.4,
                      child: ListView.builder(
                        itemCount: prov.foundBlDevicesGetter.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              prov.stopScanGetter;
                              prov.onConnectDevice(index);
                            },
                            child: ListTile(
                              leading: prov.connected
                                  ? Icon(
                                      Icons.bluetooth_connected,
                                      color: Colors.grey[600],
                                    )
                                  : Icon(
                                      Icons.bluetooth_searching,
                                      color: Colors.grey[600],
                                    ),
                              title:
                                  Text(prov.foundBlDevicesGetter[index].name),
                              subtitle: Text("Device ID: ${index + 1}"),
                              trailing: Icon(
                                Icons.keyboard_return,
                                color: color10,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
