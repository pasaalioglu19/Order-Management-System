import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

import 'package:oms/backend/api/StaffApi.dart';

class EmailSignInPage extends StatefulWidget {
  const EmailSignInPage({Key? key}) : super(key: key);

  @override
  State<EmailSignInPage> createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage> {
  bool _isLoading = false;
  bool _formVerification = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(198, 242, 196, 0.8),
      body: Center(
        child: SingleChildScrollView(
            child: Center(
          child: buildSignInForm(),
        )),
      ),
    );
  }

  Widget buildSignInForm() {
    final _signInFormKey = GlobalKey<FormState>();

    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Form(
        key: _signInFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: const Text('Login',
                  style: const TextStyle(
                    color: const Color.fromRGBO(62, 63, 64, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Visibility(
                  visible: _formVerification,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Invalid email or password',
                      style: TextStyle(color: Colors.red[900]),
                    ),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _emailController,
              validator: (value) {
                if (!EmailValidator.validate(value!)) {
                  return 'Please enter a valid email';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                label: const Text(
                  'Email',
                  style: TextStyle(color: Color.fromRGBO(62, 63, 64, 1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color.fromRGBO(62, 63, 64, 1)),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _passwordController,
              obscureText: true,
              validator: (value) {
                if (value == null || value!.isEmpty || value!.length < 6) {
                  return 'Password should include at least 6 characters';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                label: const Text(
                  'Password',
                  style: TextStyle(color: Color.fromRGBO(62, 63, 64, 1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color.fromRGBO(62, 63, 64, 1)),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(68, 112, 87, 1),
                ),
                onPressed: _isLoading
                    ? null
                    : () async {
                        if (_signInFormKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text);
                            StaffAPI.updateOne(credential.user!.uid, {
                              "last_seen_time":
                                  Timestamp.fromDate(DateTime.now())
                            });
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found' ||
                                e.code == 'wrong-password') {
                              setState(() {
                                _formVerification = true;
                              });
                            }
                          }
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                child: const Text(
                  'Sign In',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
