import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';

class CloudStoreDataManagement {
  final collectionName = 'encs-chat_users';

  Future<bool> checkThisUserAlreadyPresentOrNot({required String userName}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> findResults = await FirebaseFirestore.instance
          .collection(collectionName)
          .where('user_name', isEqualTo: userName)
          .get();

      print('Debug 1: ${findResults.docs.isEmpty}');

      return findResults.docs.isEmpty ? true : false;
    }
    catch (ex) {
      print('Error in check this user already present or not: ${ex.toString()}');
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
        'profile_pic': '',
        'token': getToken.toString(),
        'total_connections': '',
        'user_name': userName,
      });

      return true;
    }
    catch (ex) {
      print('Error in register new user: ${ex.toString()}');
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
      print('Error in user record present or not: ${ex.toString()}');
      return false;
    }
  }
}
