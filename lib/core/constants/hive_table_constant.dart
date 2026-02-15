class HiveTableConstant {
  HiveTableConstant._();

  //database name
  static const String dbName = 'aashwaas';

  //Table name : Box names in Hive
  static const int donorAuthTypeId = 0;
  static const String donorAuthTable = 'donor_auth_table';

  static const int volunteerAuthTypeId = 1;
  static const String volunteerAuthTable = 'volunteer_auth_table';

  static const int donationTypeId = 2;
  static const String donationTable = 'donation_table';

  static const int wishlistTypeId = 3;
  static const String wishlistTable = "wishlist_table";
  
  static const int taskTypeId = 4;
  static const String taskTable = 'task_table';
}
