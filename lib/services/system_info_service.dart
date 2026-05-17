import 'package:device_info_plus/device_info_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../models/system_info_model.dart';

class SystemInfoService {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  static final Battery _battery = Battery();
  static final Connectivity _connectivity = Connectivity();

  static Future<SystemInfo> getSystemInfo() async {
    try {
      if (Platform.isIOS) {
        return await _getIOSSystemInfo();
      } else if (Platform.isAndroid) {
        return await _getAndroidSystemInfo();
      } else {
        throw UnsupportedError('Platform not supported');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<SystemInfo> _getIOSSystemInfo() async {
    final iosInfo = await _deviceInfo.iosInfo;
    final batteryLevel = await _battery.batteryLevel;
    final connectionType = await _getConnectionType();
    final packageInfo = await PackageInfo.fromPlatform();

    return SystemInfo(
      manufacturer: 'Apple',
      model: iosInfo.model ?? 'Unknown',
      deviceName: iosInfo.name ?? 'Unknown',
      osName: iosInfo.systemName ?? 'iOS',
      osVersion: iosInfo.systemVersion ?? 'Unknown',
      androidVersion: '',
      processorCount: _getProcessorCount(),
      totalMemory: _getTotalMemory(),
      freeMemory: _getFreeMemory(),
      architecture: iosInfo.utsname.machine ?? 'Unknown',
      batteryLevel: batteryLevel,
      isBatteryLow: batteryLevel < 20,
      connectionType: connectionType,
      appVersion: packageInfo.version,
      appBuildNumber: packageInfo.buildNumber,
      uptime: _getUptime(),
      timezone: DateTime.now().timeZoneName,
      locale: Intl.defaultLocale ?? 'Unknown',
    );
  }

  static Future<SystemInfo> _getAndroidSystemInfo() async {
    final androidInfo = await _deviceInfo.androidInfo;
    final batteryLevel = await _battery.batteryLevel;
    final connectionType = await _getConnectionType();
    final packageInfo = await PackageInfo.fromPlatform();

    return SystemInfo(
      manufacturer: androidInfo.manufacturer ?? 'Unknown',
      model: androidInfo.model ?? 'Unknown',
      deviceName: androidInfo.device ?? 'Unknown',
      osName: 'Android',
      osVersion: androidInfo.version.release ?? 'Unknown',
      androidVersion: 'API ${androidInfo.version.sdkInt}',
      processorCount: _getProcessorCount(),
      totalMemory: _getTotalMemory(),
      freeMemory: _getFreeMemory(),
      architecture: androidInfo.supported64Bit == true ? 'ARM64' : 'ARM32',
      batteryLevel: batteryLevel,
      isBatteryLow: batteryLevel < 20,
      connectionType: connectionType,
      appVersion: packageInfo.version,
      appBuildNumber: packageInfo.buildNumber,
      uptime: _getUptime(),
      timezone: DateTime.now().timeZoneName,
      locale: Intl.defaultLocale ?? 'Unknown',
    );
  }

  static Future<String> _getConnectionType() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (result.contains(ConnectivityResult.wifi)) return 'WiFi';
      if (result.contains(ConnectivityResult.mobile)) return 'Mobile';
      if (result.contains(ConnectivityResult.ethernet)) return 'Ethernet';
      if (result.contains(ConnectivityResult.vpn)) return 'VPN';
      if (result.contains(ConnectivityResult.bluetooth)) return 'Bluetooth';
      return 'Unknown';
    } catch (e) {
      return 'Unknown';
    }
  }

  static int _getProcessorCount() {
    try {
      return Platform.numberOfProcessors;
    } catch (e) {
      return 0;
    }
  }

  static int _getTotalMemory() {
    // Diese Werte sind Annäherungen für Demo-Zwecke
    // Echte Werte benötigen native Code
    if (Platform.isAndroid) {
      return 8 * 1024 * 1024 * 1024; // 8GB Beispiel
    } else if (Platform.isIOS) {
      return 6 * 1024 * 1024 * 1024; // 6GB Beispiel
    }
    return 0;
  }

  static int _getFreeMemory() {
    // Auch hier Annäherung
    return (_getTotalMemory() / 2).toInt();
  }

  static String _getUptime() {
    try {
      final uptime = DateTime.now().difference(
        DateTime.now().subtract(Duration(milliseconds: 1000000)),
      );
      final days = uptime.inDays;
      final hours = uptime.inHours % 24;
      final minutes = uptime.inMinutes % 60;
      return '$days days, $hours hours, $minutes minutes';
    } catch (e) {
      return 'Unknown';
    }
  }
}

extension DateTimeExtension on DateTime {
  String get timeZoneName {
    final now = DateTime.now();
    final offset = DateTime.now().timeZoneOffset;
    final hours = offset.inHours;
    final minutes = offset.inMinutes % 60;
    return 'UTC${hours >= 0 ? '+' : ''}${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}