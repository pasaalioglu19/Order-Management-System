import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:oms/frontend/pages/any_actor/profile.dart';

class ProfileTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.niramitTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Profile(staffID: 'staff_id1',),
        ),
      ),
    );
  }
}


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   runApp(MaterialApp(home: ProfileTest()));
// }