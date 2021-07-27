import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:trellocards/home_page.dart';

class LoginForm extends StatefulWidget {
  final paddingTopForm,
      fontSizeTextField,
      fontSizeTextFormField,
      spaceBetweenFields,
      iconFormSize;
  final spaceBetweenFieldAndButton,
      widthButton,
      fontSizeButton,
      fontSizeForgotPassword,
      fontSizeSnackBar,
      errorFormMessage;

  LoginForm(
      this.paddingTopForm,
      this.fontSizeTextField,
      this.fontSizeTextFormField,
      this.spaceBetweenFields,
      this.iconFormSize,
      this.spaceBetweenFieldAndButton,
      this.widthButton,
      this.fontSizeButton,
      this.fontSizeForgotPassword,
      this.fontSizeSnackBar,
      this.errorFormMessage);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();

  final _passwordController = TextEditingController();

  var _pressd = false;

  @override
  Widget build(BuildContext context) {
    final double widthSize = MediaQuery.of(context).size.width;
    final double heightSize = MediaQuery.of(context).size.height;

    return Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.only(
                left: widthSize * 0.05,
                right: widthSize * 0.05,
                top: heightSize * widget.paddingTopForm),
            child: Column(children: <Widget>[
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Phone Number',
                      style: TextStyle(
                          fontSize: widthSize * widget.fontSizeTextField,
                          fontFamily: 'Poppins',
                          color: Colors.white))),
              TextFormField(
                  controller: _usernameController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Error!';
                    }
                  },
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    labelStyle: TextStyle(color: Colors.white),
                    errorStyle: TextStyle(
                        color: Colors.white,
                        fontSize: widthSize * widget.errorFormMessage),
                    prefixIcon: Icon(
                      Icons.person,
                      size: widthSize * widget.iconFormSize,
                      color: Colors.white,
                    ),
                  ),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.fontSizeTextFormField)),
              SizedBox(height: heightSize * widget.spaceBetweenFieldAndButton),
              _pressd == true
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text('OTP',
                          style: TextStyle(
                              fontSize: widthSize * widget.fontSizeTextField,
                              fontFamily: 'Poppins',
                              color: Colors.white)))
                  : Text(""),
              _pressd == true
                  ? TextFormField(
                      controller: _passwordController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Error!';
                        }
                      },
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 2)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2)),
                        labelStyle: TextStyle(color: Colors.white),
                        errorStyle: TextStyle(
                            color: Colors.white,
                            fontSize: widthSize * widget.errorFormMessage),
                        prefixIcon: Icon(
                          Icons.person,
                          size: widthSize * widget.iconFormSize,
                          color: Colors.white,
                        ),
                      ),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.fontSizeTextFormField))
                  : Text(""),
              SizedBox(height: heightSize * widget.spaceBetweenFieldAndButton),
              FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.fromLTRB(
                      widget.widthButton, 15, widget.widthButton, 15),
                  color: Colors.white,
                  onPressed: () async {
                    if (_pressd == true) {
                      Uri uri = Uri.parse(
                          "https://skyva-app.herokuapp.com/user/verifyotp");
                      final params = {
                        "email": "1234@gmail.com",
                        "phoneNo": _usernameController.text,
                        "countryCode": '91',
                        "otp": _passwordController.text
                      };
                      var response = await post(
                        uri,
                        body: json.encode(params),
                        headers: {"Content-Type": "application/json"},
                      );
                      print(response.body);
                      print(response.statusCode);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => HomePage()));
                    } else {
                      Uri uri = Uri.parse(
                          'https://skyva-app.herokuapp.com/user/sendotp');
                      print(_usernameController.text);
                      var params = {
                        "email": "1234@gmail.com",
                        "phoneNo": _usernameController.text,
                        "countryCode":
                            '91' // do not use + in front of countryCode
                      };

                      String body = json.encode(params);

                      var response = await post(
                        uri,
                        body: body,
                        headers: {"Content-Type": "application/json"},
                      );
                      print(response.body);
                      print(response.statusCode);
                      if(response.statusCode==200){
                      setState(() {
                        _pressd = true;
                      });}
                    }
                  },
                  child: Text(_pressd == false ? 'Send OTP' : "Login",
                      style: TextStyle(
                          fontSize: widthSize * widget.fontSizeButton,
                          fontFamily: 'Poppins',
                          color: Color.fromRGBO(41, 187, 255, 1)))),
              SizedBox(height: heightSize * 0.01),
            ])));
  }
}
