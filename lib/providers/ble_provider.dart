import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:washing_machine_app_v2/keyvalues.dart';
import 'dart:io' show Platform;

// import 'package:intl/intl.dart';
import 'package:washing_machine_app_v2/models/ble_model.dart';
import 'package:washing_machine_app_v2/sharedPreferences/shared_references.dart';

class BleProvider extends ChangeNotifier {
  late Uuid _SERV_UUID = Uuid.parse("0000FF13-0000-1000-8000-00805F9B34FB");
  Uuid _CHAR_UUID = Uuid.parse("0000FF14-0000-1000-8000-00805F9B34FB");
  Uuid _CHAR_UUID_WRITE = Uuid.parse("0000FF15-0000-1000-8000-00805F9B34FB");

  late final FlutterReactiveBle flutterReactiveBle;

  List<DiscoveredDevice> _foundBleUARTDevices = [];
  // late DiscoveredDevice _uniqueDevice;

  late StreamSubscription<DiscoveredDevice> _scanStream;
  late Stream<ConnectionStateUpdate> _currentConnectionStream;
  late StreamSubscription<ConnectionStateUpdate> _connection;
  late QualifiedCharacteristic _txCharacteristic;
  late QualifiedCharacteristic _rxCharacteristic;
  late Stream<List<int>> _receivedDataStream;
  late TextEditingController _dataToSendText;
  bool _scanning = false;
  bool _connected = false;
  bool _connecting = false;

  late bool _blePowerdOff = false;
  late bool _bleAuthorized = true;
  late bool _bleSupported = true;
  late bool _locationServiceEnabled = true;

  bool _status = true;
  int _remainingCircles = 0;

  bool get status => _status;
  int get remainingCircles => _remainingCircles;

  String _logTexts = "";
  List<String> _receivedData = [];
  int _numberOfMessagesReceived = 0;

  bool get scanning => _scanning;
  bool get connected => _connected;
  bool get connecting => _connecting;

  bool get blePowerdOff => _blePowerdOff;
  bool get bleAuthorized => _bleAuthorized;
  bool get bleSupported => _bleSupported;
  bool get locationServiceEnabled => _locationServiceEnabled;

  List<String> prefData = [];

  void initBle() {
    flutterReactiveBle = FlutterReactiveBle();
    // prefs = SharedPreferences.getInstance();
  }

  Future<void> prefIntSetters(String key, int value) async {
    DataSharedPreferences.setIntData(key, value);
    notifyListeners();
  }

  Future<void> prefBoolSetters(String key, bool value) async {
    DataSharedPreferences.setBoolData(key, value);
    notifyListeners();
  }

  int prefIntGetter(String key) {
    return DataSharedPreferences.getsIntData(key);
  }

  bool prefBoolGetter(String key) {
    return DataSharedPreferences.getsBoolData(key);
  }

  void _stopScan() async {
    await _scanStream.cancel();
    print('stopping scan......');
    _scanning = false;

    // print('scanning');
    // print(_scanning);
    // print('connected');
    // print(_connected);
    notifyListeners();
    // refreshScreen();
  }

  void _disconnect() async {
    await _connection.cancel();
    _foundBleUARTDevices = [];
    _connected = false;
    // refreshScreen();
    notifyListeners();
  }

  void onNewReceivedData(List<int> data) {
    _numberOfMessagesReceived += 1;
    _receivedData
        .add("$_numberOfMessagesReceived: ${String.fromCharCodes(data)}");
    if (_receivedData.length > 5) {
      _receivedData.removeAt(0);
    }
    // print("Hello--------------");
    _receivedData.forEach(
      (element) {
        print(element);
      },
    );
    notifyListeners();
    // refreshScreen();
  }

  void sendData(bool v) async {
    int circles = DataSharedPreferences.getsIntData(circleskeyValue);
    int pausePeriod = DataSharedPreferences.getsIntData(pKeyValue);
    int ccwPeriod = DataSharedPreferences.getsIntData(ccwKeyValue);
    int ccPeriod = DataSharedPreferences.getsIntData(ccPKeyValue);
    bool status = v;

    // Create MyData object
    OutData myData = OutData(circles, pausePeriod, ccwPeriod, ccPeriod, status);

    // Convert to JSON
    Map<String, dynamic> jsonData = myData.toJson();
    String jsonString = jsonEncode(jsonData);

    print(jsonString);

    await flutterReactiveBle.writeCharacteristicWithResponse(_rxCharacteristic,
        value: jsonString.codeUnits);
  }

  void _startScan() async {
    print("starting scan");
    bool goForIt = false;
    PermissionStatus permission;

    if (Platform.isAndroid) {
      permission = await LocationPermissions().requestPermissions();
      if (permission == PermissionStatus.granted) {
        goForIt = true;
      } else if (permission == PermissionStatus.denied ||
          permission == PermissionStatus.restricted) {
        LocationPermissions().openAppSettings();
      }
    } else if (Platform.isIOS) {
      goForIt = true;
    }

    // isBluetoothOn = await flutterReactiveBle.isAdapterOn();
    // if (isBluetoothOn == false) {
    //   print(
    //       "your device bluetooth is of\nbluetooth is required for this app to work");
    //   goForIt = false;
    // }

    if (goForIt) {
      flutterReactiveBle.statusStream.listen(
        (status) {
          //code for handling status update
          if (status == BleStatus.poweredOff) {
            _blePowerdOff = true;
            print("Bluetooth is powered off");
          } else if (status == BleStatus.ready) {
            _blePowerdOff = false;
            _locationServiceEnabled = true;
            print("Bluetooth is powered on");
          } else if (status == BleStatus.unauthorized) {
            _bleAuthorized = false;
            print("Bluetooth is not Authorized on this device");
          } else if (status == BleStatus.unsupported) {
            _blePowerdOff = true;
            _bleAuthorized = false;
            _bleSupported = false;
            print("Bluetooth is not Supported on this device");
          } else if (status == BleStatus.locationServicesDisabled) {
            _locationServiceEnabled = false;
            print("location Services is Disabled");
          }
          print("/////////////////////////////////////");
        },
      );

      //TODO replace True with permission == PermissionStatus.granted is for IOS test
      _foundBleUARTDevices = [];
      _scanning = true;
      notifyListeners();
      // refreshScreen();
      _scanStream = flutterReactiveBle.scanForDevices(
        withServices: <Uuid>[],
        scanMode: ScanMode.lowLatency,
      ).listen(
        (device) {
          if (_foundBleUARTDevices
                  .every((element) => element.id != device.id) &&
              device.name.contains("Smart Washing Machine")) {
            _foundBleUARTDevices.add(device);
            // refreshScreen();
            print("device added notifying listeners...");
            notifyListeners();
          }
        },
        onError: (Object error) {
          _logTexts = "${_logTexts}ERROR while scanning:$error \n";
          // refreshScreen();
        },
      );
      for (DiscoveredDevice ble_device in _foundBleUARTDevices) {
        print(
            "${ble_device.serviceUuids}---${ble_device.name}-R--${ble_device.id}---${ble_device.serviceData}---${ble_device.rssi}");
      }
    } else {
      // await showNoPermissionDialog();
      print("No location permission granted.");
      print("Location permission is required for BLE to function.");
    }
  }

  void get startScanGetter => _startScan();
  void get stopScanGetter => _stopScan();
  void get disconnectGetter => _disconnect();

  List<DiscoveredDevice> get foundBlDevicesGetter => _foundBleUARTDevices;

  Future<void> onConnectDevice(index) async {
    _currentConnectionStream = flutterReactiveBle.connectToAdvertisingDevice(
      id: _foundBleUARTDevices[index].id,
      prescanDuration: const Duration(seconds: 1),
      withServices: <Uuid>[],
    );
    _logTexts = "";

    // _SERV_UUID = _foundBleUARTDevices[index].serviceUuids[0];

    // _CHAR_UUID = ;

    // refreshScreen();
    notifyListeners();
    _connection = await _currentConnectionStream.listen((event) async {
      var id = event.deviceId.toString();

      await flutterReactiveBle.requestMtu(deviceId: event.deviceId, mtu: 517);

      print(event.connectionState);
      switch (event.connectionState) {
        case DeviceConnectionState.connecting:
          {
            _connecting = true;
            notifyListeners();
            _logTexts = "${_logTexts}Connecting to $id\n";
            break;
          }
        case DeviceConnectionState.connected:
          {
            _connecting = false;
            _connected = true;
            notifyListeners();
            _logTexts = "${_logTexts}Connected to $id\n";
            _numberOfMessagesReceived = 0;
            _receivedData = [];

            _txCharacteristic = QualifiedCharacteristic(
                serviceId: _SERV_UUID,
                characteristicId: _CHAR_UUID,
                deviceId: event.deviceId);
            _receivedDataStream =
                flutterReactiveBle.subscribeToCharacteristic(_txCharacteristic);

            // prefData = PlotDataSharedPreferences.getPlotData("plotData") ?? [];

            _receivedDataStream.listen(
              (data) async {
                Map<String, dynamic> decodedData =
                    jsonDecode(String.fromCharCodes(data));
                WasingMachineData wMData =
                    WasingMachineData.fromJson(decodedData);

                _status = wMData.status;
                _remainingCircles = wMData.remainingCircles;
                print("----------------------");

                notifyListeners();
              },
              onError: (dynamic error) {
                _logTexts = "${_logTexts}Error:$error$id\n";
              },
            );
            _rxCharacteristic = QualifiedCharacteristic(
                serviceId: _SERV_UUID,
                characteristicId: _CHAR_UUID_WRITE,
                deviceId: event.deviceId);
            break;
          }
        case DeviceConnectionState.disconnecting:
          {
            _connected = false;
            notifyListeners();
            _logTexts = "${_logTexts}Disconnecting from $id\n";
            break;
          }
        case DeviceConnectionState.disconnected:
          {
            _connected = false;
            notifyListeners();
            _logTexts = "${_logTexts}Disconnected from $id\n";
            break;
          }
      }
      // refreshScreen();
    });
  }
}
// {circles: 30, status: false, remainingCircles: 30, pausePeriod: 0, ccwPeriod: 0, ccPeriod: 0}