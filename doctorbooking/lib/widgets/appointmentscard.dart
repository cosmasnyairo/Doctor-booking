import 'package:doctorbooking/models/appointment.dart';
import 'package:flutter/material.dart';

class AppointmentsCard extends StatelessWidget {
  final List<Appointment> appointments;
  final String type;
  final String userid;
  AppointmentsCard(this.appointments, this.type, this.userid);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: EdgeInsets.all(20),
        leading: Icon(Icons.info,
            color: appointments.isEmpty
                ? Theme.of(context).errorColor
                : Theme.of(context).primaryColor),
        minLeadingWidth: 10,
        title: Text(
          appointments.isEmpty
              ? 'No $type appointments'
              : 'You have ${appointments.length} $type appointments',
          style: appointments.isEmpty ? TextStyle(color: Colors.grey) : null,
        ),
        trailing: Icon(Icons.navigate_next),
        subtitle: Text('View details'),
        onTap: () {
          Navigator.of(context).pushNamed(
            type == 'past' ? 'past_appointments' : 'pending_appointments',
            arguments: [appointments, userid],
          );
        },
      ),
    );
  }
}
