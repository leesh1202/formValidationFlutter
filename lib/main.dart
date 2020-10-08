import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:checkbox_formfield/checkbox_formfield.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(SignUpPage());

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<FormState> _key = new GlobalKey();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String fname, userid, password, email, pno;
  bool enabled = false;
  bool checked = false;
  bool _validate = false;
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Center(child: Text('Registration')),
            backgroundColor: Colors.lightGreen,
          ),
          body: Center(
              child: SingleChildScrollView(
                  child: Container(
            margin: EdgeInsets.all(15.0),
            child: Form(
              key: _key,
              // ignore: deprecated_member_use
              autovalidate: _validate,
              child: formUI(),
            ),
          ))),
        ));
  }

  Widget formUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: TextFormField(
              decoration: InputDecoration(
                labelText: 'FullName',
                prefixIcon: Icon(Icons.person),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purple),
                ),
                border: OutlineInputBorder(),
              ),
              //autofocus: true,
              //textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.text,
              validator: validateName,
              onSaved: (String value) {
                fname = value;
              }),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'UserName',
              prefixIcon: Icon(Icons.person),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.purple),
              ),
              border: OutlineInputBorder(),
            ),
            /*validator: validateName,
              */
            keyboardType: TextInputType.text,
            // ignore: missing_return
            validator: (value) {
              Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
              RegExp regex = new RegExp(pattern);
              if (value.length < 4)
                return "Username too short";
              else if (!regex.hasMatch(value))
                return 'Invalid username';
              else
                return null;
            },
            onSaved: (value) => userid = value,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: TextFormField(
            obscureText: !_passwordVisible,
            decoration: InputDecoration(
              labelText: 'Set Password',
              prefixIcon: Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.purple),
              ),
              border: OutlineInputBorder(),
            ),
            /*validator: validateName,
              */
            keyboardType: TextInputType.text,
            // ignore: missing_return
            validator: (value) {
              Pattern pattern =
                  r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
              RegExp regex = new RegExp(pattern);
              if (!regex.hasMatch(value))
                return 'Invalid Password';
              else
                return null;
            },
            onSaved: (value) => password = value,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Email ID',
                hintText: "e.g abc@gmail.com",
                prefixIcon: Icon(Icons.email),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purple),
                ),
                border: OutlineInputBorder(),
              ),
              /*validator: validateEmail,
              */
              keyboardType: TextInputType.emailAddress,
              validator: (email) => EmailValidator.validate(email)
                  ? null
                  : "Invalid email address",
              onSaved: (String value) {
                email = value;
              }),
        ),

        Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Mobile No',
                prefixIcon: Icon(Icons.phone),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purple),
                ),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: validateMobile,
              onSaved: (String value) {
                pno = value;
              }),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              Text("Send Notification", style: TextStyle(fontSize: 18)),
              Switch(
                onChanged: (bool val) {
                  setState(() {
                    enabled = val;
                  });
                },
                activeColor: Colors.green,
                activeTrackColor: Colors.greenAccent[400],
                value: enabled,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              CheckboxListTileFormField(
                title: Text(
                  'I Agree',
                  style: TextStyle(fontSize: 18),
                ),
                onSaved: (bool value) {
                  checked = value;
                },
                validator: (bool value) {
                  if (value == true) {
                    return null;
                  } else {
                    return 'Accept Terms to Proceed';
                  }
                },
                activeColor: Colors.lightGreen,
              ),
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: MaterialButton(
            child: Text(
              'Register',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.lightGreen,
            onPressed: _sendToServer,
          ),
        ),
      ],
    );
  }

  void success() {
    final snackbar = new SnackBar(
      content: new Text("Registration Successful"),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  String validateName(String value) {
    String pattern = r'(^[a-z A-Z,.\-]+$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "NAME IS REQUIRED";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    }
    return null;
  }

  String validateMobile(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Mobile is Required";
    } else if (value.length != 10) {
      return "Mobile number must 10 digits";
    } else if (!regExp.hasMatch(value)) {
      return "Mobile Number must be digits";
    }
    return null;
  }

/*
  String validateEmail(String value) {
    //String pattern=r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }
*/
  _sendToServer() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      success();
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}
