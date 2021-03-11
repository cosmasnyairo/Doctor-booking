import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:doctorbooking/models/medicalhistory.dart';
import 'package:doctorbooking/providers/authprovider.dart';
import 'package:doctorbooking/providers/detailsprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

class AddMedicalDetails extends StatefulWidget {
  @override
  _AddMedicalDetailsState createState() => _AddMedicalDetailsState();
}

class _AddMedicalDetailsState extends State<AddMedicalDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, dynamic> _authData = {
    'allergies': '',
    'date': '',
    'prescriptions': '',
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
      final medicalhistory = MedicalHistory(
        date: _authData['date'],
        allergies: _authData['allergies'],
        prescriptions: _authData['prescriptions'],
      );
      final userid = Provider.of<AuthProvider>(context, listen: false).userid;
      await Provider.of<DetailsProvider>(context, listen: false)
          .addMedicalHistory(medicalhistory, userid);
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
    return _isLoading
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            appBar:
                AppBar(title: Text('Add Medical Record'), centerTitle: true),
            body: Container(
              height: deviceSize.height,
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(20),
                  shrinkWrap: true,
                  children: <Widget>[
                    Text('Add new medical record', textAlign: TextAlign.center),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Allergies',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.info),
                      ),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Empty value provided!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['allergies'] = value;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Prescriptions',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.science),
                      ),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Empty value provided!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['prescriptions'] = value;
                      },
                    ),
                    SizedBox(height: 20),
                    DateTimeField(
                      format: DateFormat.yMMMEd(),
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
                    Center(
                      child: ElevatedButton(
                        child: Text('Add Record'),
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
