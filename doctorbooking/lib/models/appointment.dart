import 'package:flutter/material.dart';

class Appointment {
  final DateTime date;
  final TimeOfDay time;
  final String doctorid;
  final String patientid;
  final String hospital;
  Appointment({
    this.date,
    this.doctorid,
    this.patientid,
    this.hospital,
    this.time,
  });
}
