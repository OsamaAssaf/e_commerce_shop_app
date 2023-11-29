import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:osama_shop/controllers/auth.dart';
import 'package:osama_shop/widgets/app_bar.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool showOldPassword = false;

  bool showNewPassword = false;

  bool showConfirmPassword = false;

  String? oldPassword;

  String? newPassword;

  TextEditingController? _newPasswordController;

  @override
  void initState() {
    _newPasswordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? user = context.watch<Auth>().user;

    return Scaffold(
      appBar: AppBarWidget.setNormalAppBar('Change Password', context),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Old password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    oldPassword = value;
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: _newPasswordController,
                  decoration: const InputDecoration(labelText: 'New password'),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 8) {
                      return '8 characters minimum';
                    } else if (!value.contains(RegExp(r'[0-9]'))) {
                      return 'At least one number';
                    } else if (!value.contains(RegExp(r'[a-z]'))) {
                      return 'At least one letter';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    newPassword = value;
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Confirm password'),
                  validator: (value) {
                    if (value == null || value.isEmpty || value != _newPasswordController!.text) {
                      return 'New password and confirm password do not match.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 32.0,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.black),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(borderRadius: BorderRadius.zero))),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        print(oldPassword);
                        print(newPassword);
                        _changePassword(oldPassword!.trim(), newPassword!.trim(), user);
                      }
                    },
                    child: const Text(
                      'SUBMIT',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _changePassword(String oldPassword, String newPassword, User? user) async {
    String? email = user!.email;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: oldPassword,
      );

      user.updatePassword(newPassword).then((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Successfully changed password')));
        Navigator.of(context).pop();
      }).catchError((error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Password can\'t be changed$error')));
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}
