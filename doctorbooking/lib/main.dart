import 'package:doctorbooking/screens/user_details.dart';

import 'screens/add_appointment.dart';
import 'screens/add_medical_details.dart';
import 'screens/past_appointments.dart';
import 'screens/pending_appointments.dart';
import 'providers/detailsprovider.dart';
import 'providers/authprovider.dart';
import 'screens/authentication.dart';
import 'screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProvider(create: (ctx) => DetailsProvider())
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Booking App',
          theme: ThemeData(
            canvasColor: Colors.white,
            primarySwatch: Colors.teal,
          ),
          home: auth.isloggedin ? HomePage() : AuthScreen(),
          routes: {
            'pending_appointments': (ctx) => PendingAppointments(),
            'past_appointments': (ctx) => PastAppointments(),
            'add_appointment': (ctx) => AddAppointment(),
            'add_medical_details': (ctx) => AddMedicalDetails(),
          },
        ),
      ),
    );
  }
}
