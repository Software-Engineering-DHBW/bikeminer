import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bikeminer/route.dart' as route;

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool _hidePassword = true;
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwdController = TextEditingController();
  final TextEditingController _passwdvController = TextEditingController();
  final _passKey = GlobalKey<FormState>();
  final _userKey = GlobalKey<FormState>();
  final _passvalidKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _userController.dispose();
    _passwdController.dispose();
    _passwdvController.dispose();
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
                        "Registration",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      Form(
                        key: _userKey,
                        child: TextFormField(
                          controller: _userController,
                          keyboardType: TextInputType.text,
                          // onSaved: ,
                          validator: (input) => input!.length < 8
                              ? "Username should be longer than 8 characters"
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

                      Form(
                        key: _passKey,
                        child: TextFormField(
                          controller: _passwdController,
                          keyboardType: TextInputType.text,
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

                      const SizedBox(
                        height: 10,
                      ),

                      Form(
                        key: _passvalidKey,
                        child: TextFormField(
                          controller: _passwdvController,
                          keyboardType: TextInputType.text,
                          // onSaved: ,
                          validator: (input) => input != _passwdController.text
                              ? "Passwords should be the same!"
                              : null,
                          obscureText: _hidePassword,
                          decoration: InputDecoration(
                            hintText: "Password validate",
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
                      const SizedBox(
                        height: 30,
                      ),

                      // Registrationbutton
                      ElevatedButton(
                        onPressed: () {
                          bool user = _userKey.currentState!.validate();
                          bool passwd = _passKey.currentState!.validate();
                          bool passwdvalid =
                              _passvalidKey.currentState!.validate();
                          if (user && passwd && passwdvalid) {
                            var _user = _userController.text;
                            var _passwd = _passwdController.text;
                            Navigator.pop(context);
                            Navigator.pushNamed(context, route.loginPage);
                          }
                        },
                        child: const Text(
                          "Registrate",
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

                      const SizedBox(
                        height: 10,
                      ),

                      RichText(
                        text: TextSpan(
                          text: "Back to ",
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Login!",
                              recognizer: TapGestureRecognizer()
                                ..onTap = (() {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, route.loginPage);
                                }),
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
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
