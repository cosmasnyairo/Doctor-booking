import 'package:doctorbooking/models/appointment.dart';
import 'package:doctorbooking/models/medicalhistory.dart';

class Patient {
  final String name;
  final String email;
  final String patientid;
  final String role;
  final List<MedicalHistory> medicalhistory;
  final List<Appointment> pastappointments;
  final List<Appointment> pendingappointments;

  Patient({
    this.name,
    this.email,
    this.patientid,
    this.medicalhistory,
    this.pastappointments,
    this.pendingappointments,
    this.role,
  });
}
