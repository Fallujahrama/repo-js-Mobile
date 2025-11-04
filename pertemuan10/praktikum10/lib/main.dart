import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geolocator Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const GeolocatorWidget(),
    );
  }
}

class GeolocatorWidget extends StatefulWidget {
  const GeolocatorWidget({super.key});

  @override
  State<GeolocatorWidget> createState() => _GeolocatorWidgetState();
}

class _GeolocatorWidgetState extends State<GeolocatorWidget> {
  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final List<_PositionItem> _positionItems = <_PositionItem>[];
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  bool positionStreamStarted = false;

  @override
  void initState() {
    super.initState();
    _toggleServiceStatusStream();
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(height: 10);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Geolocator Demo'),
        actions: [
          PopupMenuButton(
            elevation: 40,
            onSelected: (value) async {
              switch (value) {
                case 1:
                  _getLocationAccuracy();
                  break;
                case 2:
                  _requestTemporaryFullAccuracy();
                  break;
                case 3:
                  _openAppSettings();
                  break;
                case 4:
                  _openLocationSettings();
                  break;
                case 5:
                  setState(_positionItems.clear);
                  break;
              }
            },
            itemBuilder: (context) => [
              if (!kIsWeb && Platform.isIOS)
                const PopupMenuItem(
                  value: 1,
                  child: Text("Get Location Accuracy"),
                ),
              if (!kIsWeb && Platform.isIOS)
                const PopupMenuItem(
                  value: 2,
                  child: Text("Request Temporary Full Accuracy"),
                ),
              const PopupMenuItem(
                value: 3,
                child: Text("Open App Settings"),
              ),
              if (!kIsWeb && (Platform.isAndroid || Platform.isWindows))
                const PopupMenuItem(
                  value: 4,
                  child: Text("Open Location Settings"),
                ),
              const PopupMenuItem(
                value: 5,
                child: Text("Clear"),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _positionItems.length,
        itemBuilder: (context, index) {
          final positionItem = _positionItems[index];

          if (positionItem.type == _PositionItemType.log) {
            return ListTile(
              title: Text(
                positionItem.displayValue,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                title: Text(positionItem.displayValue),
              ),
            );
          }
        },
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'toggle',
            onPressed: () {
              positionStreamStarted = !positionStreamStarted;
              _toggleListening();
            },
            tooltip: (_positionStreamSubscription == null)
                ? 'Start position updates'
                : _positionStreamSubscription!.isPaused
                    ? 'Resume'
                    : 'Pause',
            backgroundColor: _determineButtonColor(),
            child: (_positionStreamSubscription == null ||
                    _positionStreamSubscription!.isPaused)
                ? const Icon(Icons.play_arrow)
                : const Icon(Icons.pause),
          ),
          sizedBox,
          FloatingActionButton(
            heroTag: 'current',
            onPressed: _getCurrentPosition,
            child: const Icon(Icons.my_location),
          ),
          sizedBox,
          FloatingActionButton(
            heroTag: 'last',
            onPressed: _getLastKnownPosition,
            child: const Icon(Icons.bookmark),
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) return;

    final position = await _geolocatorPlatform.getCurrentPosition();
    _updatePositionList(_PositionItemType.position, position.toString());
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _updatePositionList(_PositionItemType.log, _kLocationServicesDisabledMessage);
      return false;
    }

    LocationPermission permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        _updatePositionList(_PositionItemType.log, _kPermissionDeniedMessage);
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _updatePositionList(_PositionItemType.log, _kPermissionDeniedForeverMessage);
      return false;
    }

    _updatePositionList(_PositionItemType.log, _kPermissionGrantedMessage);
    return true;
  }

  void _updatePositionList(_PositionItemType type, String displayValue) {
    _positionItems.add(_PositionItem(type, displayValue));
    setState(() {});
  }

  bool _isListening() => !(_positionStreamSubscription == null ||
      _positionStreamSubscription!.isPaused);

  Color _determineButtonColor() {
    return _isListening() ? Colors.green : Colors.red;
  }

  void _toggleServiceStatusStream() {
    // getServiceStatusStream is not supported on web platform
    if (kIsWeb) {
      return;
    }
    
    if (_serviceStatusStreamSubscription == null) {
      final serviceStatusStream = _geolocatorPlatform.getServiceStatusStream();
      _serviceStatusStreamSubscription = serviceStatusStream.handleError((error) {
        _serviceStatusStreamSubscription?.cancel();
        _serviceStatusStreamSubscription = null;
      }).listen((serviceStatus) {
        String serviceStatusValue;
        if (serviceStatus == ServiceStatus.enabled) {
          if (positionStreamStarted) _toggleListening();
          serviceStatusValue = 'enabled';
        } else {
          if (_positionStreamSubscription != null) {
            setState(() {
              _positionStreamSubscription?.cancel();
              _positionStreamSubscription = null;
              _updatePositionList(_PositionItemType.log, 'Position Stream has been canceled');
            });
          }
          serviceStatusValue = 'disabled';
        }
        _updatePositionList(_PositionItemType.log, 'Location service has been $serviceStatusValue');
      });
    }
  }

  void _toggleListening() {
    if (_positionStreamSubscription == null) {
      final positionStream = _geolocatorPlatform.getPositionStream();
      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
      }).listen((position) => _updatePositionList(_PositionItemType.position, position.toString()));
      _positionStreamSubscription?.pause();
    }

    setState(() {
      if (_positionStreamSubscription == null) return;

      String statusDisplayValue;
      if (_positionStreamSubscription!.isPaused) {
        _positionStreamSubscription!.resume();
        statusDisplayValue = 'resumed';
      } else {
        _positionStreamSubscription!.pause();
        statusDisplayValue = 'paused';
      }

      _updatePositionList(_PositionItemType.log, 'Listening for position updates $statusDisplayValue');
    });
  }

  void _getLastKnownPosition() async {
    final position = await _geolocatorPlatform.getLastKnownPosition();
    if (position != null) {
      _updatePositionList(_PositionItemType.position, position.toString());
    } else {
      _updatePositionList(_PositionItemType.log, 'No last known position available');
    }
  }

  void _getLocationAccuracy() async {
    final status = await _geolocatorPlatform.getLocationAccuracy();
    _handleLocationAccuracyStatus(status);
  }

  void _requestTemporaryFullAccuracy() async {
    final status = await _geolocatorPlatform.requestTemporaryFullAccuracy(
      purposeKey: "TemporaryPreciseAccuracy",
    );
    _handleLocationAccuracyStatus(status);
  }

  void _handleLocationAccuracyStatus(LocationAccuracyStatus status) {
    String locationAccuracyStatusValue;
    if (status == LocationAccuracyStatus.precise) {
      locationAccuracyStatusValue = 'Precise';
    } else if (status == LocationAccuracyStatus.reduced) {
      locationAccuracyStatusValue = 'Reduced';
    } else {
      locationAccuracyStatusValue = 'Unknown';
    }
    _updatePositionList(_PositionItemType.log, '$locationAccuracyStatusValue location accuracy granted.');
  }

  void _openAppSettings() async {
    final opened = await _geolocatorPlatform.openAppSettings();
    String displayValue = opened ? 'Opened Application Settings.' : 'Error opening Application Settings.';
    _updatePositionList(_PositionItemType.log, displayValue);
  }

  void _openLocationSettings() async {
    final opened = await _geolocatorPlatform.openLocationSettings();
    String displayValue = opened ? 'Opened Location Settings' : 'Error opening Location Settings';
    _updatePositionList(_PositionItemType.log, displayValue);
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _serviceStatusStreamSubscription?.cancel();
    super.dispose();
  }
}

enum _PositionItemType { log, position }

class _PositionItem {
  _PositionItem(this.type, this.displayValue);
  final _PositionItemType type;
  final String displayValue;
}