import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:osama_shop/controllers/auth.dart';
import 'package:osama_shop/widgets/app_bar.dart';
import 'package:provider/provider.dart';

class ChangeName extends StatefulWidget {
  const ChangeName({Key? key}) : super(key: key);

  @override
  State<ChangeName> createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {
  User? user;
  final TextEditingController _controller = TextEditingController();
  String newName = '';
  @override
  void initState() {
    _controller.addListener(() {
      setState(() {
        newName = _controller.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = context.watch<Auth>().user;
    String name = user!.email!.split('@')[0];

    return Scaffold(
      appBar: AppBarWidget.setCenterAppBar('Nickname', context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _controller,
              cursorColor: Colors.black,
              decoration:
                  const InputDecoration(border: OutlineInputBorder(borderSide: BorderSide.none)),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(borderRadius: BorderRadius.zero))),
                onPressed: newName == ''
                    ? null
                    : () {
                        print(newName);
                      },
                child: const Text(
                  'Save',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
