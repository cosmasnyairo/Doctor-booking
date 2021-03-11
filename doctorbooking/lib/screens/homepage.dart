import 'package:doctorbooking/models/appointment.dart';
import 'package:doctorbooking/providers/detailsprovider.dart';
import 'package:doctorbooking/providers/authprovider.dart';
import 'package:doctorbooking/screens/user_details.dart';
import 'package:doctorbooking/widgets/appointmentscard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;
  String role = '';
  String userid = '';
  dynamic user;
  List<Appointment> pastappointments = [];
  List<Appointment> pendingappointments = [];

  @override
  void didChangeDependencies() async {
    setState(() {
      _isLoading = true;
    });

    await fetchDetails();

    setState(() {
      _isLoading = false;
    });

    super.didChangeDependencies();
  }

  Future<void> fetchDetails() async {
    userid = Provider.of<AuthProvider>(context, listen: false).userid;
    final provider = Provider.of<DetailsProvider>(context, listen: false);
    await provider.fetchdetails(userid);

    role = provider.role;
    user = role == 'Patient' ? provider.patient : provider.doctor;
    pastappointments = user.pastappointments;
    pendingappointments = user.pendingappointments;
  }

  void showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(duration: Duration(seconds: 2), content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;
    return _isLoading
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            appBar: AppBar(
              title: Text(
                role == 'Patient'
                    ? 'Hello ${user.name}'
                    : 'Hello Dr.${user.name}',
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              actions: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => UserDetails(userid),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.person_outline_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                    ))
              ],
            ),
            body: Container(
              height: deviceheight,
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Text('Your appointments', textAlign: TextAlign.center),
                  SizedBox(height: 20),
                  AppointmentsCard(pendingappointments, 'pending', userid),
                  SizedBox(height: 20),
                  AppointmentsCard(pastappointments, 'past', userid),
                ],
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await Provider.of<AuthProvider>(context, listen: false)
                        .logout();
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  label: Text('Logout'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Theme.of(context).errorColor,
                  icon: Icon(Icons.exit_to_app),
                ),
                role == 'Patient' ? SizedBox(height: 20) : SizedBox(),
                role == 'Patient'
                    ? FloatingActionButton.extended(
                        heroTag: null,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('add_appointment')
                              .then(
                            (value) async {
                              if (value != null) {
                                setState(() {
                                  _isLoading = true;
                                });

                                await fetchDetails();

                                setState(() {
                                  _isLoading = false;
                                });

                                return showSnackBarMessage(value.toString());
                              }
                            },
                          );
                        },
                        label: Text('Add Appointment'),
                        icon: Icon(Icons.add),
                      )
                    : SizedBox(),
                role == 'Patient' ? SizedBox(height: 20) : SizedBox(),
                role == 'Patient'
                    ? FloatingActionButton.extended(
                        heroTag: null,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('add_medical_details');
                        },
                        label: Text('Add medical details'),
                        icon: Icon(Icons.add),
                      )
                    : SizedBox(),
                role == 'Patient' ? SizedBox(height: 20) : SizedBox(),
              ],
            ));
  }
}
