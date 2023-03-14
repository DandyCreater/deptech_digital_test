import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dep_tech/data/model/agenda_response_model.dart';
import 'package:dep_tech/data/model/register_response_model.dart';
import 'package:dep_tech/data/model/user_response_model.dart';
import 'package:dep_tech/data/utils/agenda_helper.dart';
import 'package:dep_tech/data/utils/user_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class RemoteDataSource {
  Future logIn(LoginParamaterPost value);
  Future register(RegisterParameterPost value);
  Future updateUser(
      RegisterParameterPost value, bool changePassword, String newPassword);

  Future addAgenda(AgendaParameterPost agenda, File image);
  Future agendaList();
  Future deleteItem(String uId);
  Future editAgenda(AgendaParameterPost agenda, String uId);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var storage = const FlutterSecureStorage();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final userHelper = UserHelper();
  final agendaHelper = AgendaHelper();

  @override
  Future logIn(LoginParamaterPost value) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: value.email!, password: value.password!);

      var data = {
        'email': value.email,
        'password': value.password,
      };

      await storage.write(key: "keyUserId", value: userCredential.user!.uid);
      await storage.write(key: "keyLogin", value: jsonEncode(data));
      UserResponseModel user =
          await userHelper.getUserById(userCredential.user!.uid);

      var loginData = {
        'bornDate': user.bornDate,
        'email': user.email,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'gender': user.gender,
        'profilePict': user.profilePict,
      };

      await storage.write(key: 'keyUserData', value: jsonEncode(loginData));
      return user;
    } on FirebaseAuthException catch (e) {
      debugPrint("Error Log In  : ${e.code}");
      return UserResponseModel(
          id: null,
          bornDate: "",
          email: "",
          firstName: e.message,
          lastName: "",
          gender: "",
          profilePict: "");
    }
  }

  @override
  Future register(RegisterParameterPost value) async {
    Reference storage = FirebaseStorage.instance.ref();
    var date = DateTime.now();
    String imageUrl = '';
    try {
      TaskSnapshot snapshot = await storage
          .child(
              "profilepicture/${value.firstName}-${date.day}-${date.hour}-${date.minute}-${date.second}")
          .putFile(value.profilePict!);

      if (snapshot.state == TaskState.success) {
        imageUrl = await snapshot.ref.getDownloadURL();
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: value.email!, password: value.password!);

      UserResponseModel user = UserResponseModel(
          id: userCredential.user!.uid,
          bornDate: value.bornDate,
          email: value.email,
          firstName: value.firstName,
          lastName: value.lastName,
          gender: value.gender,
          profilePict: imageUrl);

      await userHelper.setUser(user);

      return user;
    } on FirebaseAuthException catch (e) {
      debugPrint("Catch Error Register ${e.message}");
      return UserResponseModel(
          id: null,
          bornDate: "",
          email: "",
          firstName: e.message,
          lastName: "",
          gender: "",
          profilePict: "");
    }
  }

  @override
  Future updateUser(RegisterParameterPost value, bool changePassword,
      String newPassword) async {
    Reference storageImg = FirebaseStorage.instance.ref();
    var date = DateTime.now();
    String imageUrl = '';
    try {
      String? userId = await storage.read(key: 'keyUserId');
      String? userData = await storage.read(key: 'keyUserData');
      var userProfile = UserResponseModel.fromJson(jsonDecode(userData!));

      if (value.profilePict != null) {
        TaskSnapshot snapshot = await storageImg
            .child(
                "profilepicture/${value.firstName}-${date.day}-${date.hour}-${date.minute}-${date.second}")
            .putFile(value.profilePict!);

        if (snapshot.state == TaskState.success) {
          imageUrl = await snapshot.ref.getDownloadURL();
        }
      } else {
        imageUrl = userProfile.profilePict!;
      }

      UserResponseModel user = await userHelper.getUserById(userId!);
      UserResponseModel users = UserResponseModel(
          id: user.id,
          bornDate: value.bornDate,
          email: value.email,
          firstName: value.firstName,
          lastName: value.lastName,
          gender: value.gender,
          profilePict: imageUrl);
      await userHelper.updateUser(users);

      var dataUser = {
        'bornDate': value.bornDate,
        'email': value.email,
        'firstName': value.firstName,
        'lastName': value.lastName,
        'gender': value.gender,
        'profilePict': imageUrl,
      };

      await storage.write(key: 'keyUserData', value: jsonEncode(dataUser));
      if (changePassword == true) {
        User currentUser = _auth.currentUser!;
        currentUser.updatePassword(newPassword);
      }

      return users;
    } on FirebaseAuthException catch (e) {
      debugPrint("Something Wrong! ${e.message}");
      return UserResponseModel(
          id: null,
          bornDate: "",
          email: "",
          firstName: e.message,
          lastName: "",
          gender: "",
          profilePict: "");
    }
  }

  @override
  Future addAgenda(AgendaParameterPost agenda, File image) async {
    Reference storageImg = FirebaseStorage.instance.ref();
    var date = DateTime.now();
    String imageUrl = '';
    try {
      String? userId = await storage.read(key: 'keyUserId');
      TaskSnapshot snapshot = await storageImg
          .child(
              "agenda/${agenda.title}-${date.day}-${date.hour}-${date.minute}-${date.second}")
          .putFile(image);

      if (snapshot.state == TaskState.success) {
        imageUrl = await snapshot.ref.getDownloadURL();
      }
      AgendaResponseModel data = AgendaResponseModel(
          id: userId,
          date: agenda.date,
          description: agenda.description,
          picture: imageUrl,
          remindVal: agenda.remindVal,
          reminder: agenda.reminder,
          time: agenda.time,
          title: agenda.title);

      await agendaHelper.addAgenda(data);
      return data;
    } on FirebaseException catch (e) {
      debugPrint("Something Wrong! ${e.message}");
      return AgendaResponseModel(
          id: null,
          date: "",
          description: e.message,
          picture: "",
          remindVal: "",
          reminder: false,
          time: "",
          title: "");
    }
  }

  @override
  Future agendaList() async {
    List<AgendaResponseModel>? listData = [];
    final CollectionReference _agenda =
        FirebaseFirestore.instance.collection('user');
    try {
      String? userId = await storage.read(key: 'keyUserId');
      QuerySnapshot<Map<String, dynamic>> dataItem =
          await _agenda.doc(userId).collection('agenda').get();
      final allData = dataItem.docs
          .map((e) => AgendaResponseModel.fromFirestore(e))
          .toList();
      for (var items in allData) {
        listData.add(items);
      }
      return listData;
    } on FirebaseException catch (e) {
      debugPrint("Something Wrong ! ${e.message}");
      return AgendaResponseModel(
          id: null,
          date: "",
          description: e.message,
          picture: "",
          remindVal: "",
          reminder: false,
          time: "",
          title: "");
    }
  }

  @override
  Future deleteItem(String uId) async {
    List<AgendaResponseModel>? listData = [];
    final CollectionReference agenda =
        FirebaseFirestore.instance.collection('user');
    String? userId = await storage.read(key: 'keyUserId');
    try {
      await agenda.doc(userId).collection('agenda').doc(uId).delete();
      QuerySnapshot<Map<String, dynamic>> dataItem =
          await agenda.doc(userId).collection('agenda').get();
      final allData = dataItem.docs
          .map((e) => AgendaResponseModel.fromFirestore(e))
          .toList();
      for (var items in allData) {
        listData.add(items);
      }
      return listData;
    } on FirebaseException catch (e) {
      debugPrint("Something Wrong ! ${e.message}");
      return AgendaResponseModel(
          id: null,
          date: "",
          description: e.message,
          picture: "",
          remindVal: "",
          reminder: false,
          time: "",
          title: "");
    }
  }

  @override
  Future editAgenda(AgendaParameterPost agenda, String uId) async {
    final CollectionReference data =
        FirebaseFirestore.instance.collection('user');
    String? userId = await storage.read(key: 'keyUserId');
    Reference storageImg = FirebaseStorage.instance.ref();
    var date = DateTime.now();
    String imageUrl = '';

    try {
      var dataAgenda = {
        'date': agenda.date,
        'description': agenda.description,
        'picture': agenda.imageUrl,
        'remindVal': agenda.remindVal,
        'reminder': agenda.reminder,
        'time': agenda.time,
        'title': agenda.title,
      };
      await storage.write(key: 'keyUserAgenda', value: jsonEncode(dataAgenda));
      debugPrint("Image Url : ${agenda.imageUrl}");

      if (agenda.image != null) {
        TaskSnapshot snapshot = await storageImg
            .child(
                "agenda/${agenda.title}-${date.day}-${date.hour}-${date.minute}-${date.second}")
            .putFile(agenda.image!);

        if (snapshot.state == TaskState.success) {
          imageUrl = await snapshot.ref.getDownloadURL();
        }
      } else {
        imageUrl = agenda.imageUrl!;
      }

      await data.doc(userId).collection('agenda').doc(uId).update({
        'date': agenda.date,
        'description': agenda.description,
        'picture': imageUrl,
        'remindVal': agenda.remindVal,
        'reminder': agenda.reminder,
        'time': agenda.time,
        'title': agenda.title,
      });
      return "OK";
    } on FirebaseException catch (e) {
      debugPrint("Something Wrong ! ${e.message}");
      return AgendaResponseModel(
          id: null,
          date: "",
          description: e.message,
          picture: "",
          remindVal: "",
          reminder: false,
          time: "",
          title: "");
    }
  }
}
