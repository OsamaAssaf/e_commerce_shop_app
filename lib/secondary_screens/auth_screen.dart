import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:osama_shop/controllers/auth.dart';
import 'package:osama_shop/secondary_screens/terms_and_conditions_screen.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static const String pageRoute = '/auth_screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          elevation: 0.0,
          foregroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: Text(
            'Osama Shop',
            style: Theme.of(context).textTheme.headline1,
          ),
          centerTitle: true,
          actions: [
            Align(
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 32,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              alignment: Alignment.topRight,
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            labelStyle: Theme.of(context).textTheme.headline2,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.black,
            indicatorWeight: 2,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            isScrollable: true,
            tabs: const [
              Tab(
                text: 'SIGN IN',
                height: 25,
              ),
              Tab(
                text: 'REGISTER',
                height: 25,
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            _Authenticate(
              isReg: false,
            ),
            _Authenticate(
              isReg: true,
            ),
          ],
        ),
      ),
    );
  }
}

enum AuthMode {
  email,
  phone,
}

class _Authenticate extends StatefulWidget {
  const _Authenticate({Key? key, required this.isReg}) : super(key: key);

  final bool isReg;

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<_Authenticate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _phoneFormKey = GlobalKey<FormState>();

  String phoneNumber = '';
  String code = '';

  String email = '';
  String password = '';

  late TextEditingController _codeController;
  bool _checkboxValue = false;

  AuthMode _authMode = AuthMode.phone;

  bool _obscurePassword = true;

  bool codeSent = false;

  Timer? codeTimer;

  Timer? emailTimer;

  int codeSentTimer = 60;

  _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_authMode == AuthMode.email) {
        try {
          await context
              .read<Auth>()
              .emailAndPassword(email, password, widget.isReg);
          // if(widget.isReg){
          //   emailTimer = Timer.periodic(const Duration(seconds: 5), (timer) async{
          //     await FirebaseAuth.instance.currentUser!.reload();
          //     if(FirebaseAuth.instance.currentUser!.emailVerified){
          //       emailTimer!.cancel();
          //       return;
          //     }else{
          //
          //     }
          //
          //   });
          //
          // }

        } catch (e) {
          String errorMessage = 'Error Occurred';
          if (e == 'weak-password') {
            errorMessage = 'The password provided is too weak.';
          } else if (e == 'email-already-in-use') {
            errorMessage = 'The account already exists for that email.';
          } else if (e == 'user-not-found') {
            errorMessage = 'No user found for that email.';
          } else if (e == 'wrong-password') {
            errorMessage = 'Wrong password provided for that user.';
          }
          showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    content: Text(errorMessage),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text(
                          'Ok',
                          style: TextStyle(color: Colors.blue[900]),
                        ),
                      ),
                    ],
                  ));
        }
      } else {
        await context.read<Auth>().verifyCode(_codeController.text.trim());

        print(phoneNumber);
        print(code);
        print(_checkboxValue);
      }
    }
  }

  @override
  void initState() {
    _codeController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_authMode == AuthMode.phone)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Phone number'),
                        Row(
                          children: [
                            Row(
                              children: const [
                                Text('JO+962'),
                                Icon(Icons.arrow_drop_down_outlined),
                              ],
                            ),
                            const SizedBox(
                              width: 16.0,
                            ),
                            Expanded(
                              child: Form(
                                key: _phoneFormKey,
                                child: TextFormField(
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.next,
                                  cursorColor: Colors.black,
                                  decoration: const InputDecoration(
                                      hintText: 'Please input the phone number',
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 18),
                                      border: InputBorder.none),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Incorrect phone number';
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    phoneNumber = newValue!;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _codeController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                cursorColor: Colors.black,
                                decoration: const InputDecoration(
                                  label: Text('Code'),
                                  border: InputBorder.none,
                                  labelStyle: TextStyle(color: Colors.grey),
                                ),
                                onChanged: (String value) {
                                  setState(() {
                                    code = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter code number';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  code = newValue!;
                                },
                              ),
                            ),
                            if (code.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    code = '';
                                    _codeController.clear();
                                  });
                                },
                                child: const Icon(
                                  Icons.cancel,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (_phoneFormKey.currentState!.validate()) {
                                  _phoneFormKey.currentState!.save();
                                  codeTimer = Timer.periodic(
                                      const Duration(seconds: 60), (timer) {
                                    codeSentTimer--;
                                  });

                                  await context
                                      .read<Auth>()
                                      .phoneAuth(phoneNumber.trim(), context);

                                  codeTimer!.cancel();
                                  codeTimer = null;
                                }
                              },
                              child: Text(
                                codeSent ? '$codeSentTimer' : 'Send',
                                style: const TextStyle(fontSize: 16),
                              ),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero)),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.black)),
                            )
                          ],
                        ),
                        const Divider(),
                        if (widget.isReg)
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Checkbox(
                                  shape: const CircleBorder(),
                                  activeColor: Colors.black,
                                  value: _checkboxValue,
                                  onChanged: (value) {
                                    setState(() {
                                      _checkboxValue = value!;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Receive newsletters and exclusive style tips from Osama Shop via SMS!',
                                  style: Theme.of(context).textTheme.bodyText1,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        if (!widget.isReg)
                          GestureDetector(
                            child: const Text('Use password to sign in'),
                            onTap: () {},
                          ),
                      ],
                    ),
                  if (_authMode == AuthMode.email)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('Country/Region:'),
                            GestureDetector(
                              child: Row(
                                children: [
                                  Text('Jordan'),
                                  const Icon(Icons.arrow_drop_down_outlined),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        TextFormField(
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                              label: Text('EMAIL ADDRESS'),
                              labelStyle: TextStyle(color: Colors.grey),
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.grey))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email address.';
                            } else if (!value.contains('@')) {
                              return 'Please enter a valid email address.';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            email = newValue!;
                          },
                        ),
                        if (widget.isReg)
                          TextFormField(
                            cursorColor: Colors.black,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              label: const Text('PASSWORD'),
                              labelStyle: const TextStyle(color: Colors.grey),
                              border: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.grey)),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                              helperText:
                                  '8 characters minimum\nAt least one letter\nAt least one number',
                              helperMaxLines: 3,
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 8) {
                                return '8 characters minimum';
                              } else if (!value.contains(RegExp(r'[0-9]'))) {
                                return 'At least one number';
                              } else if (!value.contains(RegExp(r'[a-z]'))) {
                                return 'At least one letter';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              password = newValue!;
                            },
                          ),
                        if (!widget.isReg)
                          TextFormField(
                            cursorColor: Colors.black,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                                label: const Text('PASSWORD'),
                                labelStyle: const TextStyle(color: Colors.grey),
                                border: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.grey)),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.grey,
                                  ),
                                ),
                                counter: InkWell(
                                  child: Text(
                                    'Forget your Password?',
                                    style: TextStyle(color: Colors.grey[800]),
                                  ),
                                  onTap: () {},
                                )),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password.';
                              } else if (value.length < 8) {
                                return 'Your password must contains at lest 8 characters.';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              password = newValue!;
                            },
                          ),
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 24.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        child: Text(
                          widget.isReg ? 'REGISTER' : 'SIGN IN',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22.0),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero)),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.black)),
                        onPressed: () async {
                          await _submit();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _authMode = _authMode == AuthMode.phone
                              ? AuthMode.email
                              : AuthMode.phone;
                        });
                      },
                      child: Text(
                        _authMode == AuthMode.phone
                            ? widget.isReg
                                ? 'Register via email'
                                : 'Login via email'
                            : widget.isReg
                                ? 'Register via phone number'
                                : 'Login via phone number',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18.0,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 32.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          height: 1.0,
                          width: 25.0,
                          color: Colors.grey,
                        ),
                      ),
                      const Text('Or join with'),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          height: 1.0,
                          width: 25.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 19.0,
                          child: CircleAvatar(
                            radius: 18.0,
                            backgroundColor: Colors.white,
                            child: Image.asset('assets/images/google.png'),
                          ),
                        ),
                        onTap: () {
                          context.read<Auth>().signInWithGoogle(context);
                        },
                      ),
                      SignInButton(
                        Buttons.Facebook,
                        shape: const CircleBorder(),
                        mini: true,
                        onPressed: () async {
                          context.read<Auth>().signInWithFacebook(context);
                        },
                      ),
                    ],
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'By joining, you agree to our ',
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context)
                                  .pushNamed(TermsConditions.pageRoute);
                            },
                          text: 'Terms & Conditions',
                          style:
                              TextStyle(color: Colors.blue[900], fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
