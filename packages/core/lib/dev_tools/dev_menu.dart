import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../utils/app_logger.dart';
import '../performance/performance_monitor.dart';
import '../performance/frame_monitor.dart';
import '../performance/memory_manager.dart';

/// Developer menu for accessing debug tools
/// Only available in debug mode
class DevMenu extends StatefulWidget {
  final Widget child;
  final AppConfig config;

  const DevMenu({
    super.key,
    required this.child,
    required this.config,
  });

  @override
  State<DevMenu> createState() => _DevMenuState();
}

class _DevMenuState extends State<DevMenu> {
  bool _showMenu = false;
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _toggleMenu() {
    if (_showMenu) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => _DevMenuOverlay(
        onClose: _toggleMenu,
        config: widget.config,
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _showMenu = true);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _showMenu = false);
  }

  @override
  Widget build(BuildContext context) {
    // Only show in debug mode
    if (widget.config.environment != Environment.development) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        Positioned(
          bottom: 100,
          right: 16,
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.purple,
            onPressed: _toggleMenu,
            child: const Icon(Icons.developer_mode, size: 20),
          ),
        ),
      ],
    );
  }
}

class _DevMenuOverlay extends StatefulWidget {
  final VoidCallback onClose;
  final AppConfig config;

  const _DevMenuOverlay({
    required this.onClose,
    required this.config,
  });

  @override
  State<_DevMenuOverlay> createState() => _DevMenuOverlayState();
}

class _DevMenuOverlayState extends State<_DevMenuOverlay> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade700,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.developer_mode, color: Colors.white),
                      const SizedBox(width: 8),
                      const Text(
                        'Developer Menu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: widget.onClose,
                      ),
                    ],
                  ),
                ),
                // Tabs
                Container(
                  color: Colors.grey.shade800,
                  child: Row(
                    children: [
                      _buildTab('Info', 0),
                      _buildTab('Performance', 1),
                      _buildTab('Logs', 2),
                      _buildTab('Network', 3),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: IndexedStack(
                    index: _selectedTab,
                    children: [
                      _buildInfoTab(),
                      _buildPerformanceTab(),
                      _buildLogsTab(),
                      _buildNetworkTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.purple.shade700 : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.purple : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade400,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoItem('App Name', widget.config.appName),
        _buildInfoItem('Version', widget.config.version),
        _buildInfoItem('Environment', widget.config.environment.toString()),
        _buildInfoItem('API Base URL', widget.config.apiBaseUrl),
        const Divider(color: Colors.grey),
        _buildInfoItem('Flutter Version', 'Run: flutter --version'),
        _buildInfoItem('Dart Version', 'Run: dart --version'),
      ],
    );
  }

  Widget _buildPerformanceTab() {
    final fps = FrameRateMonitor.instance.currentFps;
    final jank = FrameRateMonitor.instance.jankPercentage;
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoItem('Current FPS', fps.toStringAsFixed(1)),
        _buildInfoItem('Jank %', '${jank.toStringAsFixed(1)}%'),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            PerformanceMonitor.instance.printReport();
            AppLogger.instance.info('Performance report printed to console');
          },
          icon: const Icon(Icons.analytics),
          label: const Text('Print Performance Report'),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {
            MemoryManager.instance.printTrackedObjects();
            AppLogger.instance.info('Memory report printed to console');
          },
          icon: const Icon(Icons.memory),
          label: const Text('Print Memory Report'),
        ),
      ],
    );
  }

  Widget _buildLogsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.article, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Check console for logs',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              AppLogger.instance.debug('Test debug log');
              AppLogger.instance.info('Test info log');
              AppLogger.instance.warning('Test warning log');
            },
            icon: const Icon(Icons.bug_report),
            label: const Text('Generate Test Logs'),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.network_check, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Network monitoring\ncoming soon',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
