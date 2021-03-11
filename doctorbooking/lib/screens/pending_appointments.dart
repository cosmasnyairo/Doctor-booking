import 'package:doctorbooking/models/appointment.dart';
import 'package:doctorbooking/providers/detailsprovider.dart';
import 'package:doctorbooking/screens/user_details.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class PendingAppointments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List args = ModalRoute.of(context).settings.arguments;
    final List<Appointment> pendingappointments = args[0];
    final String userid = args[1];

    final provider = Provider.of<DetailsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Pending Appointments')),
      body: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.all(20),
        physics: ClampingScrollPhysics(),
        separatorBuilder: (ctx, _) => SizedBox(height: 20),
        itemBuilder: (ctx, i) => Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 10,
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(height: 20),
              Text(
                'Appointment',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text('Hospital: ${pendingappointments[i].hospital}'),
                subtitle: ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: [
                    Text(
                        'Time: ${DateFormat.yMMMEd().format(pendingappointments[i].date)}'),
                    Text(
                        'Time: ${pendingappointments[i].time.hour}:${pendingappointments[i].time.minute}'),
                  ],
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => UserDetails(
                          provider.role == 'Patient'
                              ? pendingappointments[i].doctorid
                              : pendingappointments[i].patientid,
                        ),
                      ),
                    );
                  },
                  child: provider.role == 'Patient'
                      ? Text('View doctor details')
                      : Text('View patient details'),
                ),
              ),
              SizedBox(height: 10)
            ],
          ),
        ),
        itemCount: pendingappointments.length,
      ),
    );
  }
}
