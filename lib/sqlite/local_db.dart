import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import '../global/enum_gen.dart';

class LocalDb {
  // Important table data
  final String importantTableData = '__Important_Table_Data__';

  // All columns
  final String colUserName = "User_Name";
  final String colUserMail = "User_Mail";
  final String colToken = "User_Device_Token";
  final String colProfileImagePath = "Profile_Image_Path";
  final String colProfileImageUrl = "Profile_Image_Url";
  final String colNotification = "Notification_Status";
  final String colMobileNumber = "User_Mobile_Number";
  final String colAccCreationDate = "Account_Creation_Date";
  final String colAccCreationTime = "Account_Creation_Time";


  // Status management
  final String userStatusData = '__User_Status_Data__';

  // All columns
  final String colActivity = 'Activity_Path';
  final String colActivityTime = 'Activity_Time';
  final String colActivityMediaType = 'Activity_Media';
  final String colActivityExtraText = 'Activity_Extra_Text';
  final String colActivityBGInfo = 'Activity_BG_Info';
  final String colActivitySpecialOptions = 'Activity_Special_Options';


  // Create Singleton objects (created once in the whole app)
  static LocalDb localDatabase = LocalDb._createInstance();
  static late Database _database;

  // Instantiate the object
  LocalDb._createInstance();

  // Access Singleton object
  factory LocalDb() {
    localDatabase = LocalDb._createInstance();
    return localDatabase;
  }

  Future<Database> get database async {
    _database = await initializeDatabase();
    return _database;
  }

  // Make a db
  Future<Database> initializeDatabase() async {
    // Get the directory path to store the db
    final String desirePath = await getDatabasesPath();
    final Directory newDirectory = await Directory('$desirePath/.Databases/').create();
    final String path = '${newDirectory.path}/encs_chat_local_storage.db';

    // Create the db
    final Database getDatabase = await openDatabase(path, version: 1);
    return getDatabase;
  }

  // Table for store important data
  Future<void> createTableToStoreImportantData() async {
    try {
      final Database db = await database;
      await db.execute(
        "CREATE TABLE IF NOT EXISTS $importantTableData("
          "$colUserName TEXT PRIMARY KEY, "
          "$colUserMail TEXT, "
          "$colToken TEXT, "
          "$colProfileImagePath TEXT, "
          "$colProfileImageUrl TEXT, "
          "$colNotification TEXT, "
          "$colMobileNumber TEXT, "
          "$colAccCreationDate TEXT, "
          "$colAccCreationTime TEXT"
        ")"
      );

      debugPrint('User important table created!');
    }
    catch (ex) {
      debugPrint('Error in create important data table: ${ex.toString()}');
    }
  }

  // Insert or update from important data table
  Future<bool> insertOrUpdateDataForThisAccount({
    required String userName,
    required String userMail,
    required String userToken,
    required String userAccCreationDate,
    required String userAccCreationTime,
    String profileImagePath = '',
    String profileImageUrl = '',
    String purpose = 'insert',
  }) async {
    try {
      final Database db = await database;

      if (purpose != 'insert') {
        final int updateResult = await db.rawUpdate(
          "UPDATE $importantTableData SET "
          "$colToken = '$userToken', "
          "$colUserMail = '$userMail', "
          "$colAccCreationDate = '$userAccCreationDate', "
          "$colAccCreationTime = '$userAccCreationTime' "
          "WHERE $colUserName = '$userName'"
        );

        debugPrint('Update result is: $updateResult');
      }
      else {
        final Map<String, dynamic> accountData = <String, dynamic>{};

        accountData[colUserName] = userName;
        accountData[colUserMail] = userMail;
        accountData[colToken] = userToken;
        accountData[colProfileImagePath] = profileImagePath;
        accountData[colProfileImageUrl] = profileImageUrl;
        accountData[colMobileNumber] = '';
        accountData[colNotification] = '1';
        accountData[colAccCreationDate] = userAccCreationDate;
        accountData[colAccCreationTime] = userAccCreationTime;

        await db.insert(importantTableData, accountData, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      return true;
    }
    catch (ex) {
      debugPrint('Error in insert or update important data table: ${ex.toString()}');
      return false;
    }
  }

  // Make table for status
  Future<bool> createTableForUserActivity({required String tableName}) async {
    final Database db = await database;

    try {
      await db.execute(
        "CREATE TABLE IF NOT EXISTS ${tableName}_status("
          "$colActivity, $colActivityTime TEXT PRIMARY KEY, "
          "$colActivityMediaType TEXT, "
          "$colActivityExtraText TEXT, "
          "$colActivityBGInfo TEXT"
        ")"
      );

      debugPrint('User activity table created!');
      return true;
    }
    catch (ex) {
      debugPrint('Error in create table for status: ${ex.toString()}');
      return false;
    }
  }

  // Insert ActivityData to Activity Table
  Future<bool> insertDataInUserActivityTable({
    required String tableName,
    required String statusLinkOrString,
    required StatusMediaTypes mediaTypes,
    required String activityTime,
    String extraText = '',
    String bgInfo = '',
  }) async {
    try {
      final Database db = await database;
      final Map<String, dynamic> activityStoreMap = <String, dynamic>{};

      activityStoreMap[colActivity] = statusLinkOrString;
      activityStoreMap[colActivityTime] = activityTime;
      activityStoreMap[colActivityMediaType] = mediaTypes.toString();
      activityStoreMap[colActivityExtraText] = extraText;
      activityStoreMap[colActivityBGInfo] = bgInfo;

      // Insert result to db
      final int result = await db.insert('${tableName}_status', activityStoreMap, conflictAlgorithm: ConflictAlgorithm.replace);

      return result > 0 ? true : false;
    }
    catch (ex) {
      debugPrint('Error: Activity table data insertion error: ${ex.toString()}');
      return false;
    }
  }
}
