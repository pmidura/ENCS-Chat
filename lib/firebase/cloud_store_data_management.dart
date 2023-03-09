import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../global/constants.dart';

class CloudStoreDataManagement {
  final collectionName = 'encs-chat_users';

  Future<bool> checkThisUserAlreadyPresentOrNot({required String userName}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> findResults = await FirebaseFirestore.instance
          .collection(collectionName)
          .where('user_name', isEqualTo: userName)
          .get();

      debugPrint('Debug 1: ${findResults.docs.isEmpty}');

      return findResults.docs.isEmpty ? true : false;
    }
    catch (ex) {
      debugPrint('Error in checkThisUserAlreadyPresentOrNot: ${ex.toString()}');
      return false;
    }
  }

  Future<bool> registerNewUser({required String userName, required String userEmail}) async {
    try {
      final String? getToken = await FirebaseMessaging.instance.getToken();
      final String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
      final String currentTime = DateFormat('hh:mm a').format(DateTime.now());

      FirebaseFirestore.instance.doc('$collectionName/$userEmail').set({
        'activity': [],
        'connection_request': [],
        'connections': {},
        'creation_date': currentDate,
        'creation_time': currentTime,
        'phone_number': '',
        'profile_pic': FirebaseAuth.instance.currentUser!.photoURL ?? 'https://freesvg.org/img/abstract-user-flat-3.png',
        'token': getToken.toString(),
        'total_connections': '',
        'user_name': userName,
      });

      return true;
    }
    catch (ex) {
      debugPrint('Error in registerNewUser: ${ex.toString()}');
      return false;
    }
  }

  Future<bool> userRecordPresentOrNot({required String email}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirebaseFirestore.instance
        .doc('$collectionName/$email')
        .get();

      return documentSnapshot.exists;
    }
    catch (ex) {
      debugPrint('Error in userRecordPresentOrNot: ${ex.toString()}');
      return false;
    }
  }

  Future<Map<String, dynamic>> getTokenFromCloudStore({required String userMail}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance.doc('$collectionName/$userMail').get();

      debugPrint('DocumentSnapshot is: ${documentSnapshot.data()}');

      final Map<String, dynamic> importantData = <String, dynamic>{};

      importantData['token'] = documentSnapshot.data()!['token'];
      importantData['date'] = documentSnapshot.data()!['creation_date'];
      importantData['time'] = documentSnapshot.data()!['creation_time'];

      return importantData;
    }
    catch (ex) {
      debugPrint('Error in getTokenFromCloudStore: ${ex.toString()}');
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsersListExceptMyAccount({required String currentUserEmail}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection(collectionName).get();

      List<Map<String, dynamic>> usersDataCollection = [];

      for (var queryDocSnapshot in querySnapshot.docs) {
        if (currentUserEmail != queryDocSnapshot.id) {
          usersDataCollection.add({
            queryDocSnapshot.id :
            // '${queryDocSnapshot.get("user_name")}[user-name-about-divider]${queryDocSnapshot.get("about")}',
            '${queryDocSnapshot.get("user_name")}',
          });
        }
      }
      return usersDataCollection;
    }
    catch (ex) {
      debugPrint('Error in getAllUsersListExceptMyAccount: ${ex.toString()}');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getCurrentAccountAllData({required String email}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance.doc('$collectionName/$email').get();
      return documentSnapshot.data();
    }
    catch (ex) {
      debugPrint('Error in getCurrentAccountAllData: ${ex.toString()}');
      return {};
    }
  }

  Future<List<dynamic>> currentUserConnRequestList({required String email}) async {
    try {
      Map<String, dynamic>? currentUserData = await getCurrentAccountAllData(email: email);
      final List<dynamic> connRequestCollection = currentUserData!['connection_request'];
      return connRequestCollection;
    }
    catch (ex) {
      debugPrint('Error in currentUserConnRequestList: ${ex.toString()}');
      return [];
    }
  }

  Future<void> changeConnStatus({
    required String oppositeUserMail,
    required String currentUserMail,
    required String connUpdatedStatus,
    required List<dynamic> currentUserUpdatedConnRequest,
    bool storeDataAlsoInConnections = false,
  }) async {
    try {
      // Opposite conn db update
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance.doc('$collectionName/$oppositeUserMail').get();
      Map<String, dynamic>? map = documentSnapshot.data();

      List<dynamic> oppositeConnRequestsList = map!['connection_request'];
      int index = -1;

      for (var element in oppositeConnRequestsList) {
        if (element.keys.first.toString() == currentUserMail) index = oppositeConnRequestsList.indexOf(element);
      }

      if (index > -1) oppositeConnRequestsList.removeAt(index);

      oppositeConnRequestsList.add({
        currentUserMail: connUpdatedStatus,
      });

      map['connection_request'] = oppositeConnRequestsList;

      if (storeDataAlsoInConnections) map[FirestoreFieldConstants().connections].addAll({currentUserMail: []});
      await FirebaseFirestore.instance.doc('$collectionName/$oppositeUserMail').update(map);

      // Current user conn db update
      final Map<String, dynamic>? currentUserMap = await getCurrentAccountAllData(email: currentUserMail);
      currentUserMap!['connection_request'] = currentUserUpdatedConnRequest;

      if (storeDataAlsoInConnections) currentUserMap[FirestoreFieldConstants().connections].addAll({oppositeUserMail: []});
      await FirebaseFirestore.instance.doc('$collectionName/$currentUserMail').update(currentUserMap);
    }
    catch (ex) {
      debugPrint('Error in changeConnStatus: ${ex.toString()}');
    }
  }
}
