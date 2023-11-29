import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:osama_shop/account_screens/change_password_screen.dart';
import 'package:osama_shop/controllers/auth.dart';
import 'package:osama_shop/controllers/push_screens.dart';
import 'package:osama_shop/widgets/back_arrow.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = context.watch<Auth>().user;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        foregroundColor: Colors.black,
        title: const Text('Account security'),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Divider(
                  thickness: 10,
                ),
                buildListTile('Email verification', () {
                  PushScreens.pushScreens(context, const EmailVerification());
                }),
                if (user!.email != null) const Divider(),
                if (user.email != null) buildListTile('Phone Number', () {}),
                const Divider(),
                buildListTile('Change password', () {
                  PushScreens.pushScreens(context, const ChangePassword());
                }),
                const Divider(),
                buildListTile('Delete Account', () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListTile buildListTile(String title, Function() onTap) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}

class EmailVerification extends StatefulWidget {
  const EmailVerification({Key? key}) : super(key: key);

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  bool verifySent = false;
  bool timerFinished = false;

  Timer? _timer;

  int time = 60;

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('Email verification'),
        foregroundColor: Colors.black,
        leading: const BackArrow(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Divider(),
              const Icon(
                Icons.mark_email_read_outlined,
                size: 128,
                color: Colors.black,
              ),
              const Text('Email verification'),
              const SizedBox(
                height: 16.0,
              ),
              const Text('100 Points will be in your Pocket.'),
              const SizedBox(
                height: 32.0,
              ),
              Container(
                width: double.infinity,
                height: 50,
                color: Colors.grey[300],
                child: Center(child: Text('${context.watch<Auth>().user!.email}')),
              ),
              const SizedBox(
                height: 16.0,
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
                    try {
                      await context.read<Auth>().user!.sendEmailVerification();
                      setState(() {
                        verifySent = true;
                      });
                      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                        if (time == 1) {
                          _timer!.cancel();
                          setState(() {
                            timerFinished = true;
                            verifySent = false;
                          });
                        }
                        setState(() {
                          time--;
                        });
                      });
                    } on FirebaseAuthException catch (e) {
                      if (context.mounted) {
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  content: Text(e.message!),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: Text(
                                          'Ok',
                                          style: TextStyle(color: Colors.blue[900]),
                                        )),
                                  ],
                                ));
                      }
                    }
                  },
                  child: Text(
                    verifySent ? '$time S' : 'Verify',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              if (verifySent)
                const Text(
                  'A confirmation email has been sent to you. Please click the link in the email to complete verification.',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.normal),
                ),
              if (timerFinished)
                const SizedBox(
                  height: 32.0,
                ),
              if (timerFinished)
                Text(
                  'Didn\'t receive the email?\n\n1.Please check your spam folder.\n2.If you still don\'t see the email, reach out to service@osamashop.cpm.',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
