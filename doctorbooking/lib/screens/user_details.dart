import 'package:doctorbooking/providers/authprovider.dart';
import 'package:doctorbooking/providers/detailsprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class UserDetails extends StatefulWidget {
  final String userid;
  UserDetails(this.userid);

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  bool _isLoading = false;
  String role = '';
  dynamic user = '';
  @override
  void didChangeDependencies() async {
    setState(() {
      _isLoading = true;
    });
    final provider = Provider.of<DetailsProvider>(context, listen: false);
    await provider.fetchdetails(widget.userid);
    role = provider.role;
    user = role == 'Patient' ? provider.patient : provider.doctor;
    setState(() {
      _isLoading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;

    return _isLoading
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : WillPopScope(
            onWillPop: () async {
              await Provider.of<DetailsProvider>(context, listen: false)
                  .fetchdetails(
                      Provider.of<AuthProvider>(context, listen: false).userid);

              return true;
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  role == 'Patient' ? 'Patient Profile' : 'Doctor profile',
                  textAlign: TextAlign.center,
                ),
              ),
              body: Container(
                height: deviceheight,
                child: ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 10,
                      child: ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Username'),
                        subtitle: Text(user.name),
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 10,
                      child: ListTile(
                        leading: Icon(Icons.email),
                        title: Text('Email'),
                        subtitle: Text(user.email),
                      ),
                    ),
                    SizedBox(height: 20),
                    role == 'Patient'
                        ? Text('Medical History', textAlign: TextAlign.center)
                        : SizedBox(),
                    SizedBox(height: 20),
                    role == 'Patient'
                        ? ListView.separated(
                            separatorBuilder: (ctx, i) => SizedBox(height: 20),
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (ctx, i) => Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 10,
                              child: ListTile(
                                leading: Icon(Icons.assessment),
                                title: Text(
                                    'Date: ${DateFormat.yMMMEd().format(user.medicalhistory[i].date)}'),
                                subtitle: ListView(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  children: [
                                    Text(
                                        'Allergies : ${user.medicalhistory[i].allergies}'),
                                    Text(
                                        'Prescriptions : ${user.medicalhistory[i].prescriptions}'),
                                  ],
                                ),
                                isThreeLine: true,
                              ),
                            ),
                            itemCount: user.medicalhistory.length,
                          )
                        : SizedBox(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
  }
}
