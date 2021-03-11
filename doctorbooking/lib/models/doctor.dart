import 'package:doctorbooking/models/appointment.dart';

class Doctor {
  final String name;
  final String email;
  final String doctorid;
  final String role;
  final List<Appointment> pastappointments;
  final List<Appointment> pendingappointments;

  Doctor({
    this.name,
    this.email,
    this.doctorid,
    this.pastappointments,
    this.pendingappointments,
    this.role,
  });
}
