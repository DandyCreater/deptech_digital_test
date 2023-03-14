import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dep_tech/data/model/user_response_model.dart';
import 'package:flutter/material.dart';

class UserHelper {
  final CollectionReference _userReference =
      FirebaseFirestore.instance.collection('user');
  Future setUser(UserResponseModel user) async {
    try {
      _userReference.doc(user.id).set({
        'email': user.email,
        'bornDate': user.bornDate,
        'firstName': user.firstName,
        'gender': user.gender,
        'lastName': user.lastName,
        'profilePict': user.profilePict,
      });
    } catch (e) {
      debugPrint("ERROR WHEN SET USER HELPER $e");
    }
  }

  Future getUserById(String id) async {
    try {
      DocumentSnapshot snapshot = await _userReference.doc(id).get();
      return UserResponseModel(
        id: id,
        email: (snapshot.data() as dynamic)['email'],
        bornDate: (snapshot.data() as dynamic)['bornDate'],
        firstName: (snapshot.data() as dynamic)['firstName'],
        gender: (snapshot.data() as dynamic)['gender'],
        lastName: (snapshot.data() as dynamic)['lastName'],
        profilePict: (snapshot.data() as dynamic)['profilePict'],
      );
    } catch (e) {
      return e;
    }
  }

  Future updateUser(UserResponseModel user) async {
    try {
      _userReference.doc(user.id).update({
        'email': user.email,
        'bornDate': user.bornDate,
        'firstName': user.firstName,
        'gender': user.gender,
        'lastName': user.lastName,
        'profilePict': user.profilePict,
      });
    } catch (e) {
      debugPrint("Error Update $e");
      return e;
    }
  }
}
