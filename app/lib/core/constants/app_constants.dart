class AppConstants {
  // App Info
  static const String appName = 'Oasis Taxi';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  
  // API Endpoints
  static const String authEndpoint = '/auth';
  static const String usersEndpoint = '/users';
  static const String ridesEndpoint = '/rides';
  static const String paymentsEndpoint = '/payments';
  static const String driversEndpoint = '/drivers';
  static const String notificationsEndpoint = '/notifications';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String onboardingKey = 'onboarding_completed';
  
  // Ride Status
  static const String rideStatusPending = 'pending';
  static const String rideStatusAccepted = 'accepted';
  static const String rideStatusArriving = 'arriving';
  static const String rideStatusInProgress = 'in_progress';
  static const String rideStatusCompleted = 'completed';
  static const String rideStatusCancelled = 'cancelled';
  
  // Payment Methods
  static const String paymentCash = 'cash';
  static const String paymentCard = 'card';
  static const String paymentMercadoPago = 'mercadopago';
  static const String paymentYape = 'yape';
  
  // Error Messages
  static const String networkError = 'Error de conexión. Por favor, verifica tu internet.';
  static const String serverError = 'Error del servidor. Intenta nuevamente.';
  static const String unknownError = 'Ocurrió un error inesperado.';
  static const String sessionExpired = 'Tu sesión ha expirado. Por favor, inicia sesión nuevamente.';
  
  // Success Messages
  static const String rideCreated = 'Solicitud de viaje creada exitosamente';
  static const String rideCancelled = 'Viaje cancelado';
  static const String paymentSuccessful = 'Pago realizado exitosamente';
  static const String profileUpdated = 'Perfil actualizado correctamente';
  
  // Validation Messages
  static const String requiredField = 'Este campo es requerido';
  static const String invalidEmail = 'Correo electrónico inválido';
  static const String invalidPhone = 'Número de teléfono inválido';
  static const String passwordTooShort = 'La contraseña debe tener al menos 6 caracteres';
  static const String passwordsDoNotMatch = 'Las contraseñas no coinciden';
  
  // Animations
  static const String loadingAnimation = 'assets/animations/loading.json';
  static const String successAnimation = 'assets/animations/success.json';
  static const String errorAnimation = 'assets/animations/error.json';
  static const String searchingAnimation = 'assets/animations/searching.json';
  static const String carAnimation = 'assets/animations/car.json';
  
  // Images
  static const String logoImage = 'assets/images/logo_oasis_taxi.png';
  static const String onboardingImage1 = 'assets/images/onboarding1.png';
  static const String onboardingImage2 = 'assets/images/onboarding2.png';
  static const String onboardingImage3 = 'assets/images/onboarding3.png';
  static const String defaultAvatar = 'assets/images/default_avatar.png';
  
  // Icons
  static const String markerPickup = 'assets/icons/marker_pickup.png';
  static const String markerDestination = 'assets/icons/marker_destination.png';
  static const String markerDriver = 'assets/icons/marker_driver.png';
  
  // Durations
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration searchDebounce = Duration(milliseconds: 500);
  static const Duration locationUpdateInterval = Duration(seconds: 10);
  
  // Sizes
  static const double mapDefaultZoom = 15.0;
  static const double mapMinZoom = 10.0;
  static const double mapMaxZoom = 20.0;
  static const double searchRadiusKm = 5.0;
  static const int maxRecentAddresses = 5;
  static const int maxFavoriteAddresses = 10;
  
  // Regular Expressions
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp phoneRegex = RegExp(
    r'^\+?[0-9]{9,15}$',
  );
  static final RegExp nameRegex = RegExp(
    r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]{2,50}$',
  );
}