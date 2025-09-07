import 'package:flutter/material.dart';
import '../../core/theme/modern_theme.dart';

class OasisAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final bool showLogo;
  
  const OasisAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ModernTheme.oasisGreen,
      elevation: 0,
      centerTitle: true,
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showLogo) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              padding: EdgeInsets.all(4),
              child: Image.asset(
                'assets/images/logo_oasis_taxi.png',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback al ícono si la imagen no carga
                  return Icon(
                    Icons.local_taxi,
                    color: ModernTheme.oasisGreen,
                    size: 16,
                  );
                },
              ),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class OasisDrawerHeader extends StatelessWidget {
  final String userType;
  final String userName;
  
  const OasisDrawerHeader({
    super.key,
    required this.userType,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: ModernTheme.primaryGradient,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo principal
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(8),
                    child: Image.asset(
                      'assets/images/logo_oasis_taxi.png',
                      width: 44,
                      height: 44,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback al ícono si la imagen no carga
                        return Icon(
                          Icons.local_taxi,
                          color: ModernTheme.oasisGreen,
                          size: 30,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'OASIS TAXI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        'Tu viaje, tu precio',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              // Info del usuario
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: Icon(
                      _getUserIcon(userType),
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _getUserTypeLabel(userType),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  IconData _getUserIcon(String userType) {
    switch (userType) {
      case 'driver':
        return Icons.directions_car;
      case 'admin':
        return Icons.admin_panel_settings;
      default:
        return Icons.person;
    }
  }
  
  String _getUserTypeLabel(String userType) {
    switch (userType) {
      case 'driver':
        return 'Conductor';
      case 'admin':
        return 'Administrador';
      default:
        return 'Pasajero';
    }
  }
}