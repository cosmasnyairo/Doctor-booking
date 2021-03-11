import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorbooking/models/appointment.dart';
import 'package:doctorbooking/models/doctor.dart';
import 'package:doctorbooking/models/medicalhistory.dart';
import 'package:doctorbooking/models/patient.dart';

import 'package:flutter/material.dart';

class DetailsProvider with ChangeNotifier {
  Patient _patient;
  String _role;

  String get role {
    return _role;
  }

  Patient get patient {
    return _patient;
  }

  Doctor _doctor;

  Doctor get doctor {
    return _doctor;
  }

  Future<void> fetchdetails(String userid) async {
    await FirebaseFirestore.instance.collection('Users').doc(userid).get().then(
      (f) {
        _role = f['role'];
        _role == 'Patient'
            ? _patient = Patient(
                name: f['name'],
                pastappointments: (f['appointments'] as List<dynamic>)
                    .map(
                      (e) => Appointment(
                        date: DateTime.parse(e['date']),
                        doctorid: e['doctorid'],
                        hospital: e['hospital'],
                        patientid: e['patientid'],
                        time: TimeOfDay(
                          hour: e['time']['time'],
                          minute: e['time']['minute'],
                        ),
                      ),
                    )
                    .where((e) => e.date.isBefore(DateTime.now()))
                    .toList(),
                pendingappointments: (f['appointments'] as List<dynamic>)
                    .map(
                      (e) => Appointment(
                        date: DateTime.parse(e['date']),
                        doctorid: e['doctorid'],
                        hospital: e['hospital'],
                        patientid: e['patientid'],
                        time: TimeOfDay(
                          hour: e['time']['time'],
                          minute: e['time']['minute'],
                        ),
                      ),
                    )
                    .where((e) => e.date.isAfter(DateTime.now()))
                    .toList(),
                medicalhistory: (f['medicalhistory'] as List<dynamic>)
                    .map(
                      (e) => MedicalHistory(
                        date: DateTime.parse(e['date']),
                        allergies: e['allergies'],
                        prescriptions: e['prescriptions'],
                      ),
                    )
                    .toList(),
                patientid: f['patientid'],
                email: f['email'],
                role: f['role'],
              )
            : _doctor = Doctor(
                name: f['name'],
                pastappointments: (f['appointments'] as List<dynamic>)
                    .map(
                      (e) => Appointment(
                        date: DateTime.parse(e['date']),
                        doctorid: e['doctorid'],
                        hospital: e['hospital'],
                        patientid: e['patientid'],
                        time: TimeOfDay(
                          hour: e['time']['time'],
                          minute: e['time']['minute'],
                        ),
                      ),
                    )
                    .where((e) => e.date.isBefore(DateTime.now()))
                    .toList(),
                pendingappointments: (f['appointments'] as List<dynamic>)
                    .map(
                      (e) => Appointment(
                        date: DateTime.parse(e['date']),
                        doctorid: e['doctorid'],
                        hospital: e['hospital'],
                        patientid: e['patientid'],
                        time: TimeOfDay(
                          hour: e['time']['time'],
                          minute: e['time']['minute'],
                        ),
                      ),
                    )
                    .where((e) => e.date.isAfter(DateTime.now()))
                    .toList(),
                doctorid: f['doctorid'],
                email: f['email'],
                role: f['role'],
              );
      },
    );
  }

  Future<void> addAppointment(Appointment appointment) async {
    final addedappointment = {
      'date': appointment.date.toIso8601String(),
      'time': {
        'time': appointment.time.hour,
        'minute': appointment.time.minute,
      },
      'doctorid': appointment.doctorid,
      'patientid': appointment.patientid,
      'hospital': appointment.hospital,
    };
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(appointment.patientid)
        .update({
      'appointments': FieldValue.arrayUnion([addedappointment])
    });
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(appointment.doctorid)
        .update({
      'appointments': FieldValue.arrayUnion([addedappointment])
    });
    notifyListeners();
  }

  Future<void> addMedicalHistory(
      MedicalHistory medicalhistory, String userid) async {
    final addedmedicalrecord = {
      'date': medicalhistory.date.toIso8601String(),
      'allergies': medicalhistory.allergies,
      'prescriptions': medicalhistory.prescriptions,
    };
    await FirebaseFirestore.instance.collection('Users').doc(userid).update({
      'medicalhistory': FieldValue.arrayUnion([addedmedicalrecord])
    });

    notifyListeners();
  }
}
