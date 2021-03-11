import 'package:doctorbooking/models/appointment.dart';
import 'package:doctorbooking/providers/authprovider.dart';
import 'package:doctorbooking/providers/detailsprovider.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddAppointment extends StatefulWidget {
  @override
  _AddAppointmentState createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, dynamic> _authData = {
    'doctorid': '',
    'date': '',
    'time': '',
    'hospital': '',
  };

  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      final appointment = Appointment(
        date: _authData['date'],
        doctorid: _authData['doctorid'],
        hospital: _authData['hospital'],
        patientid: Provider.of<AuthProvider>(context, listen: false).userid,
        time: TimeOfDay.fromDateTime(_authData['time']),
      );
      await Provider.of<DetailsProvider>(context, listen: false)
          .addAppointment(appointment);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop('Appointment added');
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog(error.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
        title: Text('An Error Occurred'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final dateformat = DateFormat.yMMMEd();
    final timeformat = DateFormat.jm();
    return _isLoading
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            appBar: AppBar(title: Text('Add Appointment'), centerTitle: true),
            body: Container(
              height: deviceSize.height,
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(20),
                  shrinkWrap: true,
                  children: <Widget>[
                    Text('Add new appointment', textAlign: TextAlign.center),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Doctor id',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.person),
                      ),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Invalid id!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['doctorid'] = value;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Hospital',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.local_hospital),
                      ),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Invalid hospital name!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['hospital'] = value;
                      },
                    ),
                    SizedBox(height: 20),
                    DateTimeField(
                      format: dateformat,
                      decoration: InputDecoration(
                        labelText: 'Appointment date',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.date_range),
                      ),
                      onSaved: (value) {
                        _authData['date'] = value;
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Date not chosen!';
                        }
                        return null;
                      },
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    DateTimeField(
                      format: timeformat,
                      decoration: InputDecoration(
                        labelText: 'Appointment time',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.access_time),
                      ),
                      onSaved: (value) {
                        _authData['time'] = value;
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Time not chosen!';
                        }
                        return null;
                      },
                      onShowPicker: (context, currentValue) async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now(),
                          ),
                        );
                        return DateTimeField.convert(time);
                      },
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        child: Text('Add Appointment'),
                        onPressed: _submit,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
