import 'package:doctorbooking/models/appointment.dart';
import 'package:doctorbooking/providers/detailsprovider.dart';
import 'package:doctorbooking/screens/user_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

class PastAppointments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List args = ModalRoute.of(context).settings.arguments;
    final List<Appointment> pastappointments = args[0];
    final String userid = args[1];

    final provider = Provider.of<DetailsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Past Appointments')),
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
            physics: ClampingScrollPhysics(),
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
                title: Text('Hospital: ${pastappointments[i].hospital}'),
                subtitle: ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: [
                    Text(
                        'Time: ${DateFormat.yMMMEd().format(pastappointments[i].date)}'),
                    Text(
                        'Time: ${pastappointments[i].time.hour}:${pastappointments[i].time.minute}'),
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
                              ? pastappointments[i].doctorid
                              : pastappointments[i].patientid,
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
        itemCount: pastappointments.length,
      ),
    );
  }
}
