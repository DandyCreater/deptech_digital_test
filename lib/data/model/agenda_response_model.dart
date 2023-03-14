// ignore_for_file: unnecessary_this

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dep_tech/domain/entity/agenda_entity.dart';

class AgendaResponseModel {
  final String? id;
  final String? date;
  final String? description;
  final String? picture;
  final String? remindVal;
  final bool? reminder;
  final String? time;
  final String? title;

  const AgendaResponseModel(
      {required this.id,
      required this.date,
      required this.description,
      required this.picture,
      required this.remindVal,
      required this.reminder,
      required this.time,
      required this.title});

  factory AgendaResponseModel.fromJson(Map<String, dynamic> json) {
    return AgendaResponseModel(
        id: json['id'],
        date: json['date'],
        description: json['description'],
        picture: json['picture'],
        remindVal: json['remindVal'],
        reminder: json['reminder'],
        time: json['time'],
        title: json['title']);
  }

  factory AgendaResponseModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    return AgendaResponseModel(
        id: snapshot.id,
        date: snapshot.data()!['date'],
        description: snapshot.data()!['description'],
        picture: snapshot.data()!['picture'],
        remindVal: snapshot.data()!['remindVal'],
        reminder: snapshot.data()!['reminder'],
        time: snapshot.data()!['time'],
        title: snapshot.data()!['title']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (date != null) "date": date,
      if (description != null) "description": description,
      if (picture != null) "picture": picture,
      if (remindVal != null) "remindVal": remindVal,
      if (reminder != null) "reminder": reminder,
      if (reminder != null) "time": time,
      if (reminder != null) "title": title,
    };
  }

  AgendaEntity toEntity() {
    return AgendaEntity(
        id: this.id,
        date: this.date,
        description: this.description,
        picture: this.picture,
        remindVal: this.remindVal,
        reminder: this.reminder,
        time: this.time,
        title: this.title);
  }
}

class AgendaParameterPost {
  final String? date;
  final String? description;
  final String? remindVal;
  final bool? reminder;
  final String? imageUrl;
  final String? time;
  final String? title;
  final File? image;

  const AgendaParameterPost(
      {required this.image,
      required this.date,
      required this.description,
      required this.remindVal,
      required this.reminder,
      required this.imageUrl,
      required this.time,
      required this.title});
}

class EditAgendaArguments {
  final String? id;
  final String? date;
  final String? description;
  final String? picture;
  final String? remindVal;
  final String? time;
  final String? title;
  final bool? reminder;

  const EditAgendaArguments(
      {required this.id,
      required this.date,
      required this.description,
      required this.picture,
      required this.remindVal,
      required this.reminder,
      required this.time,
      required this.title});
}
