import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dep_tech/data/model/agenda_response_model.dart';
import 'package:flutter/material.dart';

class AgendaHelper {
  final CollectionReference _agenda =
      FirebaseFirestore.instance.collection('user');
  // final FirebaseFirestore _agenda = FirebaseFirestore.instance;

  Future addAgenda(AgendaResponseModel agenda) async {
    debugPrint(agenda.id);
    try {
      var params = {
        'date': agenda.date,
        'description': agenda.description,
        'picture': agenda.picture,
        'remindVal': agenda.remindVal,
        'reminder': agenda.reminder,
        'time': agenda.time,
        'title': agenda.title,
      };

      await _agenda.doc(agenda.id).collection('agenda').add(params);
    } catch (e) {
      debugPrint("ERROR WHEN ADD AGENDA HELPER $e");
    }
  }
}
