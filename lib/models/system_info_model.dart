class SystemInfo {
  // Device Info
  final String manufacturer;
  final String model;
  final String deviceName;
  final String osName;
  final String osVersion;
  final String androidVersion;
  
  // Hardware Info
  final int processorCount;
  final int totalMemory;
  final int freeMemory;
  final String architecture;
  
  // Battery & Connection
  final int batteryLevel;
  final bool isBatteryLow;
  final String connectionType;
  
  // App Info
  final String appVersion;
  final String appBuildNumber;
  
  // Misc
  final String uptime;
  final String timezone;
  final String locale;

  SystemInfo({
    required this.manufacturer,
    required this.model,
    required this.deviceName,
    required this.osName,
    required this.osVersion,
    required this.androidVersion,
    required this.processorCount,
    required this.totalMemory,
    required this.freeMemory,
    required this.architecture,
    required this.batteryLevel,
    required this.isBatteryLow,
    required this.connectionType,
    required this.appVersion,
    required this.appBuildNumber,
    required this.uptime,
    required this.timezone,
    required this.locale,
  });

  int get memoryUsagePercent {
    if (totalMemory == 0) return 0;
    return ((totalMemory - freeMemory) * 100 ~/ totalMemory);
  }

  String get formattedTotalMemory => _formatBytes(totalMemory);
  String get formattedFreeMemory => _formatBytes(freeMemory);
  String get formattedUsedMemory => _formatBytes(totalMemory - freeMemory);

  static String _formatBytes(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    var i = (bytes.toString().length / 3).ceil();
    return ((bytes / pow(1024, i - 1)).toStringAsFixed(2)) + " " + suffixes[i - 1];
  }

  static num pow(num x, num y) => x == 0 ? 0 : (List.filled(y.toInt(), x).fold(1, (a, b) => a * b));
}