import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../firebase/cloud_store_data_management.dart';
import '../sqlite/local_db.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      final CloudStoreDataManagement cloudStoreDataManagement = CloudStoreDataManagement();
      final LocalDb localDb = LocalDb();
      final authResult = await FirebaseAuth.instance.signInWithCredential(credential);

      if (authResult.additionalUserInfo!.isNewUser) {
        await cloudStoreDataManagement.registerNewUser(
          userName: authResult.user!.displayName.toString(),
          userEmail: authResult.user!.email.toString(),
        );

        // Calling local db methods to initialize local db with required methods
        await localDb.createTableToStoreImportantData();
        final Map<String, dynamic> importantFetchedData = await cloudStoreDataManagement.getTokenFromCloudStore(
          userMail: authResult.user!.email.toString(),
        );

        await localDb.insertOrUpdateDataForThisAccount(
          userName: authResult.user!.displayName.toString(),
          userMail: authResult.user!.email.toString(),
          userToken: importantFetchedData['token'],
          userAccCreationDate: importantFetchedData['date'],
          userAccCreationTime: importantFetchedData['time'],
        );

        await localDb.createTableForUserActivity(
          tableName: authResult.user!.email.toString().split('@')[0],
        );
      }
    }
    catch (ex) {
      debugPrint(ex.toString());
    }

    notifyListeners();
  }

  Future googleLogout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
