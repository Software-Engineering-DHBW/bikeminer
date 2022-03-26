import 'package:bikeminer/backend/storage_adapter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bikeminer/route.dart' as route;

class LoginPage extends StatefulWidget {
  final StorageAdapter _sa;
  const LoginPage(this._sa, {Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _hidePassword = true;
  bool _remember = false;
  final TextEditingController _passController = TextEditingController();
  final _passKey = GlobalKey<FormState>();
  final _userKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  margin:
                      const EdgeInsets.symmetric(vertical: 105, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.primary,
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).hintColor.withOpacity(0.2),
                          offset: const Offset(0, 10),
                          blurRadius: 20),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Login",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      Form(
                        key: _userKey,
                        child: TextFormField(
                          controller: _userController,
                          // keyboardType: TextInputType.text,
                          // onSaved: ,
                          validator: (input) => input!.length < 8
                              ? "Password should be longer than 8 characters"
                              : null,
                          decoration: InputDecoration(
                            hintText: "Username",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .backgroundColor
                                    .withOpacity(0.2),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.supervised_user_circle,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // Passwordfield
                      Form(
                        key: _passKey,
                        child: TextFormField(
                          controller: _passController,
                          // keyboardType: TextInputType.text,
                          // onSaved: ,
                          validator: (input) => input!.length < 8
                              ? "Password should be longer than 8 characters"
                              : null,
                          obscureText: _hidePassword,
                          decoration: InputDecoration(
                            hintText: "Password",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .backgroundColor
                                    .withOpacity(0.2),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _hidePassword = !_hidePassword;
                                });
                              },
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.4),
                              icon: Icon(_hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                        ),
                      ),

                      // Remember Checkbutton
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            onChanged: (value) {
                              setState(
                                () {
                                  _remember = value!;
                                },
                              );
                            },
                            value: _remember,
                          ),
                          const Text("Remember?")
                        ],
                      ),

                      // Abstand
                      const SizedBox(
                        height: 5,
                      ),

                      // Loginbutton
                      ElevatedButton(
                        onPressed: () {
                          // TODO: login validation aktivieren
                          bool user = true; //_userKey.currentState!.validate();
                          bool passwd =
                              true; //_passKey.currentState!.validate();
                          if (user && passwd) {
                            var _user = _userController.text;
                            var _passwd = _passController.text;
                            if (_remember) {
                              widget._sa
                                  .updateElementwithKey("Username", _user);
                              widget._sa
                                  .updateElementwithKey("Password", _passwd);
                            }
                            Navigator.pop(context);
                            Navigator.pushNamed(context, route.mapPage);
                          }
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).colorScheme.secondary,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 80,
                          ),
                        ),
                      ),

                      // Abstand
                      const SizedBox(
                        height: 5,
                      ),

                      RichText(
                        text: TextSpan(
                            text: "Need an accound? ",
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "Sign Up!",
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = (() {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                          context, route.registrationPage);
                                    }),
                                  style: const TextStyle(color: Colors.blue))
                            ]),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
