import 'package:flutter/material.dart';
import 'dart:async';
import '../models/system_info_model.dart';
import '../services/system_info_service.dart';

class SystemInfoScreen extends StatefulWidget {
  const SystemInfoScreen({Key? key}) : super(key: key);

  @override
  State<SystemInfoScreen> createState() => _SystemInfoScreenState();
}

class _SystemInfoScreenState extends State<SystemInfoScreen> {
  late Future<SystemInfo> _systemInfoFuture;
  SystemInfo? _systemInfo;
  late Timer _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadSystemInfo();
    // Aktualisiere alle 5 Sekunden
    _refreshTimer = Timer.periodic(Duration(seconds: 5), (_) {
      _loadSystemInfo();
    });
  }

  void _loadSystemInfo() {
    _systemInfoFuture = SystemInfoService.getSystemInfo();
    _systemInfoFuture.then((info) {
      setState(() {
        _systemInfo = info;
      });
    });
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Information'),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<SystemInfo>(
        future: _systemInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final info = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              _loadSystemInfo();
              await _systemInfoFuture;
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Device Section
                _buildSection(
                  title: 'Device',
                  children: [
                    _buildInfoRow('Manufacturer', info.manufacturer),
                    _buildInfoRow('Model', info.model),
                    _buildInfoRow('Device Name', info.deviceName),
                  ],
                ),
                const SizedBox(height: 16),

                // OS Section
                _buildSection(
                  title: 'Operating System',
                  children: [
                    _buildInfoRow('OS', info.osName),
                    _buildInfoRow('Version', info.osVersion),
                    if (info.androidVersion.isNotEmpty)
                      _buildInfoRow('API Level', info.androidVersion),
                  ],
                ),
                const SizedBox(height: 16),

                // Hardware Section
                _buildSection(
                  title: 'Hardware',
                  children: [
                    _buildInfoRow('Processor Cores', '${info.processorCount}'),
                    _buildInfoRow('Architecture', info.architecture),
                    _buildInfoRow('Total RAM', info.formattedTotalMemory),
                    _buildMemoryBar(info),
                    _buildInfoRow('Used Memory', info.formattedUsedMemory),
                    _buildInfoRow('Free Memory', info.formattedFreeMemory),
                  ],
                ),
                const SizedBox(height: 16),

                // Power & Connection Section
                _buildSection(
                  title: 'Power & Connection',
                  children: [
                    _buildBatteryRow(info),
                    _buildInfoRow('Connection Type', info.connectionType),
                  ],
                ),
                const SizedBox(height: 16),

                // App Info Section
                _buildSection(
                  title: 'Application',
                  children: [
                    _buildInfoRow('App Version', info.appVersion),
                    _buildInfoRow('Build Number', info.appBuildNumber),
                  ],
                ),
                const SizedBox(height: 16),

                // System Section
                _buildSection(
                  title: 'System',
                  children: [
                    _buildInfoRow('Uptime', info.uptime),
                    _buildInfoRow('Timezone', info.timezone),
                    _buildInfoRow('Locale', info.locale),
                  ],
                ),
                const SizedBox(height: 32),

                // Refresh Button
                ElevatedButton.icon(
                  onPressed: _loadSystemInfo,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh Now'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const Divider(height: 1),
          ...children.map((child) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: child,
              )),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBatteryRow(SystemInfo info) {
    final batteryColor = info.isBatteryLow ? Colors.red : Colors.green;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Battery Level',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Row(
          children: [
            Container(
              width: 40,
              height: 24,
              decoration: BoxDecoration(
                border: Border.all(color: batteryColor),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Stack(
                children: [
                  Container(
                    width: (40 * info.batteryLevel) / 100,
                    height: 24,
                    decoration: BoxDecoration(
                      color: batteryColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  Center(
                    child: Text(
                      '${info.batteryLevel}%',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              info.isBatteryLow ? 'Low' : 'Good',
              style: TextStyle(color: batteryColor),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMemoryBar(SystemInfo info) {
    final percent = info.memoryUsagePercent;
    final color = percent > 80
        ? Colors.red
        : percent > 60
            ? Colors.orange
            : Colors.green;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Memory Usage'),
            Text('${percent.toStringAsFixed(1)}%'),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percent / 100,
            minHeight: 8,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
