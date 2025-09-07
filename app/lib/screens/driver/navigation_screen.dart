// ignore_for_file: deprecated_member_use, unused_field, unused_element, avoid_print, unreachable_switch_default, avoid_web_libraries_in_flutter, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:math' as math;
import '../../core/theme/modern_theme.dart';

class NavigationScreen extends StatefulWidget {
  final Map<String, dynamic>? tripData;
  
  NavigationScreen({super.key, this.tripData});
  
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> 
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  
  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _slideAnimation;
  
  // Navigation state
  bool _isNavigating = false;
  final bool _showInstructions = true;
  String _currentInstruction = 'Calculando ruta...';
  String _nextInstruction = '';
  double _distanceToNext = 0;
  int _estimatedTime = 0;
  double _totalDistance = 0;
  int _totalTime = 0;
  
  // Current location simulation
  LatLng _currentLocation = LatLng(-12.0851, -76.9770);
  final LatLng _destination = LatLng(-12.0951, -76.9870);
  Timer? _locationTimer;
  
  // Route instructions
  List<RouteInstruction> _instructions = [];
  int _currentInstructionIndex = 0;
  
  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _slideController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    );
    
    _slideController.forward();
    _initializeRoute();
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _locationTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }
  
  void _initializeRoute() {
    // Simulate route instructions
    _instructions = [
      RouteInstruction(
        instruction: 'Dirígete hacia el norte por Av. Principal',
        distance: 250,
        duration: 60,
        turnIcon: Icons.arrow_upward,
        position: LatLng(-12.0851, -76.9770),
      ),
      RouteInstruction(
        instruction: 'Gira a la derecha en Calle 2',
        distance: 500,
        duration: 120,
        turnIcon: Icons.turn_right,
        position: LatLng(-12.0861, -76.9780),
      ),
      RouteInstruction(
        instruction: 'Continúa recto por 800 metros',
        distance: 800,
        duration: 180,
        turnIcon: Icons.straight,
        position: LatLng(-12.0881, -76.9800),
      ),
      RouteInstruction(
        instruction: 'Gira a la izquierda en Av. Secundaria',
        distance: 400,
        duration: 90,
        turnIcon: Icons.turn_left,
        position: LatLng(-12.0901, -76.9820),
      ),
      RouteInstruction(
        instruction: 'En la rotonda, toma la segunda salida',
        distance: 200,
        duration: 45,
        turnIcon: Icons.rotate_right,
        position: LatLng(-12.0921, -76.9840),
      ),
      RouteInstruction(
        instruction: 'Tu destino está a la derecha',
        distance: 50,
        duration: 15,
        turnIcon: Icons.location_on,
        position: LatLng(-12.0941, -76.9860),
      ),
    ];
    
    _totalDistance = _instructions.fold(0, (sum, inst) => sum + inst.distance);
    _totalTime = _instructions.fold(0, (sum, inst) => sum + inst.duration);
    
    _updateCurrentInstruction();
    _drawRoute();
  }
  
  void _updateCurrentInstruction() {
    if (_currentInstructionIndex < _instructions.length) {
      final current = _instructions[_currentInstructionIndex];
      _currentInstruction = current.instruction;
      _distanceToNext = current.distance.toDouble();
      _estimatedTime = current.duration;
      
      if (_currentInstructionIndex + 1 < _instructions.length) {
        _nextInstruction = _instructions[_currentInstructionIndex + 1].instruction;
      } else {
        _nextInstruction = 'Llegando al destino';
      }
    }
  }
  
  void _drawRoute() {
    // Create route polyline
    List<LatLng> routePoints = _instructions.map((inst) => inst.position).toList();
    routePoints.add(_destination);
    
    _polylines.add(
      Polyline(
        polylineId: PolylineId('route'),
        points: routePoints,
        color: ModernTheme.primaryBlue,
        width: 5,
        patterns: [],
      ),
    );
    
    // Add markers
    _markers.add(
      Marker(
        markerId: MarkerId('origin'),
        position: _currentLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: 'Inicio'),
      ),
    );
    
    _markers.add(
      Marker(
        markerId: MarkerId('destination'),
        position: _destination,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: 'Destino'),
      ),
    );
    
    setState(() {});
  }
  
  void _startNavigation() {
    setState(() {
      _isNavigating = true;
    });
    
    // Simulate location updates
    _locationTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      _simulateMovement();
    });
  }
  
  void _simulateMovement() {
    if (_currentInstructionIndex < _instructions.length - 1) {
      setState(() {
        _distanceToNext -= 50; // Reduce 50 meters
        _estimatedTime = math.max(0, _estimatedTime - 2);
        
        if (_distanceToNext <= 50) {
          _currentInstructionIndex++;
          _updateCurrentInstruction();
          
          // Voice instruction simulation
          _showVoiceNotification();
        }
        
        // Update current location marker
        _currentLocation = _instructions[_currentInstructionIndex].position;
        _updateLocationMarker();
      });
    } else {
      _arriveAtDestination();
    }
  }
  
  void _updateLocationMarker() {
    _markers.removeWhere((marker) => marker.markerId.value == 'current');
    _markers.add(
      Marker(
        markerId: MarkerId('current'),
        position: _currentLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        anchor: Offset(0.5, 0.5),
      ),
    );
  }
  
  void _showVoiceNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.volume_up, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(_currentInstruction)),
          ],
        ),
        backgroundColor: ModernTheme.primaryBlue,
        duration: Duration(seconds: 3),
      ),
    );
  }
  
  void _arriveAtDestination() {
    _locationTimer?.cancel();
    setState(() {
      _isNavigating = false;
      _currentInstruction = '¡Has llegado a tu destino!';
    });
    
    _showArrivalDialog();
  }
  
  void _showArrivalDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: ModernTheme.success, size: 32),
            SizedBox(width: 12),
            Text('¡Llegaste!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Has llegado a tu destino exitosamente.'),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.route, size: 20, color: ModernTheme.textSecondary),
                SizedBox(width: 8),
                Text('${(_totalDistance / 1000).toStringAsFixed(1)} km'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.timer, size: 20, color: ModernTheme.textSecondary),
                SizedBox(width: 8),
                Text('${(_totalTime / 60).round()} min'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('Finalizar'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 16,
              tilt: 45,
              bearing: 90,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              _applyMapStyle();
            },
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: true,
            buildingsEnabled: true,
            trafficEnabled: true,
          ),
          
          // Top navigation bar
          SafeArea(
            child: AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -100 * (1 - _slideAnimation.value)),
                  child: _buildNavigationBar(),
                );
              },
            ),
          ),
          
          // Bottom instruction panel
          if (_showInstructions)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 200 * (1 - _slideAnimation.value)),
                    child: _buildInstructionPanel(),
                  );
                },
              ),
            ),
          
          // Floating action buttons
          Positioned(
            right: 16,
            bottom: _showInstructions ? 280 : 100,
            child: Column(
              children: [
                _buildFloatingButton(
                  Icons.my_location,
                  () => _recenterMap(),
                ),
                SizedBox(height: 12),
                _buildFloatingButton(
                  Icons.layers,
                  () => _toggleMapType(),
                ),
                SizedBox(height: 12),
                _buildFloatingButton(
                  Icons.volume_up,
                  () => _toggleVoice(),
                ),
              ],
            ),
          ),
          
          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: ModernTheme.cardShadow,
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: ModernTheme.textPrimary),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNavigationBar() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ModernTheme.oasisGreen,
        borderRadius: BorderRadius.circular(20),
        boxShadow: ModernTheme.floatingShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Current instruction
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _currentInstructionIndex < _instructions.length
                      ? _instructions[_currentInstructionIndex].turnIcon
                      : Icons.location_on,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentInstruction,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${_distanceToNext.round()} m',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          '$_estimatedTime seg',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Progress bar
          Container(
            margin: EdgeInsets.only(top: 12),
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return LinearProgressIndicator(
                  value: (_currentInstructionIndex + 1) / _instructions.length,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInstructionPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: ModernTheme.floatingShadow,
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 16),
          
          // Trip info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoItem(
                Icons.route,
                '${(_totalDistance / 1000).toStringAsFixed(1)} km',
                'Distancia total',
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey.shade300,
              ),
              _buildInfoItem(
                Icons.timer,
                '${(_totalTime / 60).round()} min',
                'Tiempo estimado',
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey.shade300,
              ),
              _buildInfoItem(
                Icons.speed,
                '45 km/h',
                'Velocidad',
              ),
            ],
          ),
          SizedBox(height: 20),
          
          // Next instruction preview
          if (_nextInstruction.isNotEmpty)
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ModernTheme.backgroundLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.subdirectory_arrow_right, 
                    color: ModernTheme.textSecondary),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Luego:',
                          style: TextStyle(
                            color: ModernTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          _nextInstruction,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: 20),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isNavigating ? null : _startNavigation,
                  icon: Icon(_isNavigating ? Icons.pause : Icons.play_arrow),
                  label: Text(_isNavigating ? 'Navegando...' : 'Iniciar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ModernTheme.oasisGreen,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _cancelNavigation,
                icon: Icon(Icons.close),
                label: Text('Cancelar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ModernTheme.error,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: ModernTheme.oasisGreen, size: 24),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ModernTheme.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: ModernTheme.textSecondary,
          ),
        ),
      ],
    );
  }
  
  Widget _buildFloatingButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: ModernTheme.cardShadow,
      ),
      child: IconButton(
        icon: Icon(icon, color: ModernTheme.oasisGreen),
        onPressed: onPressed,
      ),
    );
  }
  
  void _recenterMap() {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentLocation,
          zoom: 16,
          tilt: 45,
          bearing: 90,
        ),
      ),
    );
  }
  
  void _toggleMapType() {
    // Toggle between normal and satellite view
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cambiar tipo de mapa'),
        duration: Duration(seconds: 1),
      ),
    );
  }
  
  void _toggleVoice() {
    // Toggle voice instructions
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Instrucciones de voz activadas'),
        duration: Duration(seconds: 1),
      ),
    );
  }
  
  void _cancelNavigation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancelar navegación'),
        content: Text('¿Estás seguro de que deseas cancelar la navegación?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: ModernTheme.error,
            ),
            child: Text('Sí, cancelar'),
          ),
        ],
      ),
    );
  }
  
  void _applyMapStyle() {
    // Apply custom map style
    const String mapStyle = '''
    [
      {
        "featureType": "poi",
        "elementType": "labels",
        "stylers": [{"visibility": "off"}]
      }
    ]
    ''';
    _mapController?.setMapStyle(mapStyle);
  }
}

class RouteInstruction {
  final String instruction;
  final double distance;
  final int duration;
  final IconData turnIcon;
  final LatLng position;
  
  RouteInstruction({
    required this.instruction,
    required this.distance,
    required this.duration,
    required this.turnIcon,
    required this.position,
  });
}