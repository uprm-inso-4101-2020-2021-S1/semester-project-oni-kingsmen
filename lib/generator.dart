import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final String alphabet = "qwertyuiopsdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM";
final String numbers = "1234567890";
final String symbols = " !\"#\$%&'()*+,-./:;<=>?@[\\]^_`{|}~";

Future<String> passwordGeneratorPopup(BuildContext context) {
  final Map<String, int> formData = {
    'size': null,
    'numberCount': 0,
    'symbolCount': 0,
  };
  final _formKey = GlobalKey<FormState>();

  TextEditingController symController = new TextEditingController();
  TextEditingController numController = new TextEditingController();
  int specialCharCount = 0;

  Widget _buildSizeField() {
    return Column(
      children: [
        new Text('Password Size', style: new TextStyle(fontSize: 12.0)),
        new Padding(padding: EdgeInsets.only(top: 5.0)),
        new TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
            ],
            decoration: new InputDecoration(
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(25.0),
                borderSide: new BorderSide(),
              ),
            ),
            onSaved: (size) {
              formData['size'] = int.parse(size);
            },
            validator: (size) {
              if (size.length <= 0 || int.parse(size) < 0) {
                return "Please enter a valid password size.";
              }
              if (int.parse(size) > 128) {
                return "Max Password Size: 128";
              }

              specialCharCount = 0;

              if (numController.text.length > 0) {
                specialCharCount += int.parse(numController.text);
              }
              if (symController.text.length > 0) {
                specialCharCount += int.parse(symController.text);
              }

              if (int.parse(size) < specialCharCount) {
                return "Size is less than Digits + Symbols.";
              }

              return null;
            }),
      ],
    );
  }

  Widget _buildNumberCountField() {
    return Column(
      children: [
        new Text('# of Numerical Digits', style: new TextStyle(fontSize: 12.0)),
        new Padding(padding: EdgeInsets.only(top: 5.0)),
        new TextFormField(
            controller: numController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
            ],
            decoration: new InputDecoration(
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(25.0),
                borderSide: new BorderSide(),
              ),
            ),
            onSaved: (numberCount) {
              if (numberCount.length > 0) {
                formData['numberCount'] = int.parse(numberCount);
              } else {
                formData['numberCount'] = 0;
              }
            },
            validator: (numberCount) {
              if (numberCount.length > 0 && int.parse(numberCount) < 0) {
                return "Please enter a valid digit count";
              }
              return null;
            })
      ],
    );
  }

  Widget _buildSymbolCountField() {
    return Column(
      children: [
        new Text('# of Symbols', style: new TextStyle(fontSize: 12.0)),
        new Padding(padding: EdgeInsets.only(top: 5.0)),
        new TextFormField(
            controller: symController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
            ],
            decoration: new InputDecoration(
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(25.0),
                borderSide: new BorderSide(),
              ),
            ),
            onSaved: (symbolCount) {
              if (symbolCount.length > 0) {
                formData['symbolCount'] = int.parse(symbolCount);
              } else {
                formData['symbolCount'] = 0;
              }
            },
            validator: (symbolCount) {
              if (symbolCount.length > 0 && int.parse(symbolCount) < 0) {
                return "Please enter a valid symbol count";
              }
              return null;
            })
      ],
    );
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildSizeField(),
            _buildNumberCountField(),
            _buildSymbolCountField(),
          ],
        ));
  }

  bool _submitForm() {
    print('Submitting form');
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save(); //onSaved is called!
      print(formData);
      return true;
    }
    return false;
  }

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Password Generator"),
        content: (_buildForm()),
        actions: <Widget>[
          MaterialButton(
              child: Text("Submit"),
              onPressed: () {
                if (_submitForm()) {
                  Navigator.of(context).pop(generatePassword(formData["size"],
                      formData["numberCount"], formData["symbolCount"]));
                }
              })
        ],
      );
    },
  );
}

String generatePassword(int size, int numberCount, int symbolCount) {
  var rng = new Random();
  int charCount = size - numberCount - symbolCount;

  //current ammount of chars in password
  int currChars = 0;
  int currNums = 0;
  int currSyms = 0;

  String password = "";

  //determine next element
  while (currChars < charCount && (currNums < numberCount || currSyms < symbolCount)
      || (currNums < numberCount && currSyms < symbolCount)) {
    switch (rng.nextInt(3)) {
      //chosen next character type
      case 0:
        //chose alphabet char
        if (currChars < charCount) {
          password += alphabet[rng.nextInt(alphabet.length)];
          currChars++;
        }
        break;
      case 1:
        //chose number
        if (currNums < numberCount) {
          password += numbers[rng.nextInt(numbers.length)];
          currNums++;
        }
        break;
      default:
      //chose symbol
        if (currSyms < symbolCount) {
          password += symbols[rng.nextInt(symbols.length)];
          currSyms++;
        }
        break;
    }
  }

  while (currChars < charCount) {
    password += alphabet[rng.nextInt(alphabet.length)];
    currChars++;
  }
  while (currNums < numberCount) {
    password += numbers[rng.nextInt(numbers.length)];
    currNums++;
  }
  while (currSyms < symbolCount) {
    password += symbols[rng.nextInt(symbols.length)];
    currSyms++;
  }

  print(password);
  return password;
}
