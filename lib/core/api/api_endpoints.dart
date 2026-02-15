import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // Configuration
  static const bool isPhysicalDevice = false;
  static const String _ipAddress = '192.168.1.1';
  static const int _port = 5050;

  // Base URLs
  static String get _host {
    if (isPhysicalDevice) return _ipAddress;
    if (kIsWeb || Platform.isIOS) return 'localhost';
    if (Platform.isAndroid) return '10.0.2.2';
    return 'localhost';
  }

  static String get serverUrl => 'http://$_host:$_port';
  static String get baseUrl => '$serverUrl/api';
  static String get mediaServerUrl => serverUrl;

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ============ Donor Endpoints ============
  static const String donor = '/auth/register';
  static const String donorLogin = '/auth/login';
  // static const String donorRegister = '/register';
  static String donorById(String id) => '/auth/$id';
  static String donorPhoto(String id) => '/auth/$id';

  //volunteer endpoints
  static const String volunteer = '/auth/register';
  static const String volunteerLogin = '/auth/login';
  // static const String volunteerRegister = '/register';
  static String volunteerById(String id) => '/auth/$id';
  static String volunteerPhoto(String id) => '/auth/$id';

  // ============ Donation Endpoints ============
  static const String donations = '/donations';
  static String donationById(String id) => '/donations/$id';
  static const String donationUploadPhoto = '/donations/upload-photo';
  static String donationPicture(String filename) =>
      '$mediaServerUrl/item_photos/$filename';

  // ============ Wishlist Endpoints ============
  static const String wishlistAll = '/wishlists';
  static const String wishlistCreate = '/wishlists';
  static String wishlistById(String id) => '/wishlists/$id';
  static String wishlistByDonor(String donorId) => '/wishlists/donor/$donorId';
  static String wishlistByCategory(String category) =>
      '/wishlists/category/$category';
  static String wishlistByStatus(String status) => '/wishlists/status/$status';
  static String wishlistUpdate(String id) => '/wishlists/$id';
  static String wishlistDelete(String id) => '/wishlists/$id';

  // ============ NGO Endpoints ============
  static const String ngos = '/ngos';
  static String ngoById(String id) => '/ngos/$id';

  // ============ Task Endpoints ============
  static const String tasks = '/tasks';
  static String taskById(String id) => '/tasks/$id';
  static String tasksByVolunteer(String volunteerId) =>
      '/tasks/volunteer/$volunteerId';
  static const String tasksMy = '/tasks/me';
  static String taskAccept(String id) => '/tasks/$id/accept';
  static String taskComplete(String id) => '/tasks/$id/complete';
  static String taskCancel(String id) => '/tasks/$id/cancel';

  // ============ Profile Pictures ============
  static String profilePicture(String filename) =>
      '$mediaServerUrl/item_photos/$filename';
}
