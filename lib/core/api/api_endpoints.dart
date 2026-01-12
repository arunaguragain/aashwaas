class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - change this for production
  static const String baseUrl = 'http://10.0.2.2:3000/api/v1';
  //static const String baseUrl = 'http://localhost:3000/api/v1';
  // For Android Emulator use: 'http://10.0.2.2:3000/api/v1'
  // For iOS Simulator use: 'http://localhost:5000/api/v1'
  // For Physical Device use your computer's IP: 'http://192.168.x.x:5000/api/v1'

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ============ Doonor Endpoints ============
  static const String donor = '/donor';
  static const String donorLogin = '/donor/login';
  static const String donorRegister = '/donor/register';
  static String donorById(String id) => '/donor/$id';
  static String donorPhoto(String id) => '/donor/$id/photo';
  
  //volunteer endpoints
  static const String volunteer = '/volunteer';
  static const String volunteerLogin = '/volunteer/login';
  static const String volunteerRegister = '/volunteer/register';
  static String volunteerById(String id) => '/volunteer/$id';
  static String volunteerPhoto(String id) => '/volunteer/$id/photo';
  
}
