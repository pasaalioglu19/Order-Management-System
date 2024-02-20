import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_switch/flutter_switch.dart';

import 'package:oms/backend/api/StaffApi.dart';
import 'package:oms/backend/models/Staff.dart';
import 'package:oms/frontend/components/text_box.dart';
import 'package:oms/frontend/components/styled_button.dart';


TextStyle profileTextStyle = TextStyle(
  fontFamily: GoogleFonts.niramit().fontFamily,
  fontSize: 14, 
  color: Colors.black,
  fontWeight: FontWeight.normal,
);



// Her bir profil satırını temsil eden widget.
class ProfileRow extends StatefulWidget {
  final String staffID;
  final String title;
  final String value;
  final bool isEditable;
  final VoidCallback? onEdit;

  const ProfileRow({
    Key? key,
    required this.staffID,
    required this.title,
    required this.value,
    this.isEditable = true,
    this.onEdit,
  }) : super(key: key);

  @override
  _ProfileRowState createState() => _ProfileRowState();
}

class _ProfileRowState extends State<ProfileRow> {
  final TextEditingController _controller = TextEditingController();
  String? _value;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value;
    _value = widget.value;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(widget.title, style: profileTextStyle,),
        ),
        Expanded(
          flex: 5, 
          child: TextBox(
            labelText: widget.value, 
            color: Color(0xffC6D2C4),
            fontSize: 14,
          )
        ),
        Expanded(
          flex: 1,
          child: widget.isEditable 
            ? IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Dialog göstermek için bir fonksiyon çağırıyoruz
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text(widget.title),
                      content: TextField(
                        controller: _controller, // Varsayılan değer olarak widget.value kullanılır
                        decoration: InputDecoration(
                          hintText: 'Enter new value', 
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff447057)))
                        ),
                        cursorColor: Color(0xff447057),
                        autofocus: true,
                      ),
                      actions: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            StyledButton(flex: 0, title: 'Cancel', onPressed: () => Navigator.pop(context, 'Cancel')),
                            StyledButton(
                              flex: 0,
                              title: 'Save',
                              onPressed: () {
                                Navigator.pop(context, 'Ok');
                                setState(() {
                                  String updated_value = _controller.text;
                                  _value = updated_value;
                                  StaffAPI.updateOne(
                                    widget.staffID,
                                    <String, String> {
                                      widget.title.toLowerCase(): updated_value
                                    }
                                  );
                                });
                              }
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              )
            : Container(),
        ),
      ],
    );
  }
}

// Kullanıcı profili widget'ı.
class Profile extends StatefulWidget {
  final String staffID;

  const Profile({
    Key? key,
    required this.staffID,
  }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}


class _ProfileState extends State<Profile> {
  bool isSwitched = false;
  bool switchVisibility = true;

  Staff? person;

  String name = "";
  String surname = "";
  String phone = "";
  String email = "";
  String password = "";
  String job = "";
  String state = "";
  String warehouse_id = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProfileInformation();
    });
  }

  Future<void> getProfileInformation() async {
    this.person = await StaffAPI.getOne(widget.staffID);
    
    setState(() {
      name = person?.name ?? "";
      surname = person?.surname ?? "";
      phone = person?.phone ?? "";
      email = person?.email ?? "";
      password = person?.password ?? "";
      state = person?.state ?? "";
      job = person?.job ?? "";
      warehouse_id = person?.job ?? "";
    });

    if (state == "active") {
      isSwitched = true;
      switchVisibility = true;
    }
    else if (state == "onleave") {
      switchVisibility = false;
      isSwitched = false;
    } 
    else {
      switchVisibility = true;
      isSwitched = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Profile',
              style: TextStyle(
                fontFamily: GoogleFonts.niramit().fontFamily,
                fontSize: 28,
                color: Color(0xff447057),
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ProfileRow(staffID: widget.staffID, title: 'Name', value: name),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ProfileRow(staffID: widget.staffID, title: 'Surname', value: surname),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ProfileRow(staffID: widget.staffID, title: 'Phone', value: phone),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ProfileRow(staffID: widget.staffID, title: 'Email', value: email),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ProfileRow(staffID: widget.staffID, title: 'Password', value: password),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ProfileRow(staffID: widget.staffID, title: 'Job', value: job, isEditable: false),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'State',
                    style: profileTextStyle,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TextBox(
                    labelText: state,
                    color: Color(0xffC6D2C4),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: switchVisibility
                      ? FlutterSwitch(
                          value: isSwitched,
                          onToggle: (val) {
                            setState(() {
                              isSwitched = val;
                              state = isSwitched ? "active" : "passive";
                              StaffAPI.updateOne(
                                widget.staffID,
                                <String,String>{
                                  "state": state,
                                }
                              );
                              // call function to update state
                              getProfileInformation();
                            });
                          },
                        )
                      : Container(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
