class WasingMachineData {
  final bool status;
  final int remainingCircles;

  // {circles: 30, status: false, remainingCircles: 30, pausePeriod: 0, ccwPeriod: 0, ccPeriod: 0}

  WasingMachineData({
    required this.status,
    required this.remainingCircles,
  });

  factory WasingMachineData.fromJson(Map<String, dynamic> json) {
    return WasingMachineData(
      status: json['status'] as bool,
      remainingCircles: json['remainingCircles'] as int,
    );
  }
}

class OutData {
  int circles;
  int pausePeriod;
  int ccwPeriod;
  int ccPeriod;
  bool status;

  OutData(this.circles, this.pausePeriod, this.ccwPeriod, this.ccPeriod,
      this.status);

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'circles': circles,
      'pausePeriod': pausePeriod,
      'ccwPeriod': ccwPeriod,
      'ccPeriod': ccPeriod,
      'status': status
    };
  }
}
