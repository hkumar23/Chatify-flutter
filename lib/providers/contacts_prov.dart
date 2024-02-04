import 'package:chatify2/misc/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Contacts with ChangeNotifier {
  Future<bool> userExist({required String email}) async {
    bool userExist = false;
    var userSnap = await FirebaseFirestore.instance
        .collection(AppConstants.userEmails)
        .get();
    for (var element in userSnap.docs) {
      // print(element.id);
      if (element.id == email) {
        userExist = true;
      }
    }
    return userExist;
  }

  Future<void> addContact(
      String email, String userId, String? contactId) async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection(AppConstants.userEmails)
          .get();
      for (var element in userSnap.docs) {
        if (element.id == email) {
          contactId = element.data()[AppConstants.userId];
        }
      }
      // print(contactId);
      if (contactId == null) {
        throw "User does not exist";
      }
      final contactDocRef = FirebaseFirestore.instance
          .collection(AppConstants.contacts)
          .doc(contactId);
      final userDocRef = FirebaseFirestore.instance
          .collection(AppConstants.contacts)
          .doc(userId);
      final contactDocSnap = await contactDocRef.get();
      final userDocSnap = await userDocRef.get();

      if (contactDocSnap.exists) {
        if (contactDocSnap.data()!.containsKey(userId)) {
          throw "Contact already exists";
        }
        await contactDocRef.update({
          userId: true,
        });
      } else {
        await contactDocRef.set({
          userId: true,
        });
      }

      if (userDocSnap.exists) {
        if (userDocSnap.data()!.containsKey(contactId)) {
          throw "Contact already exists";
        }
        await userDocRef.update({
          contactId: true,
        });
      } else {
        await userDocRef.set({
          contactId: true,
        });
      }

      contactId = null;
    } catch (err) {
      // print(err);
      rethrow;
    }
    notifyListeners();
  }
}
