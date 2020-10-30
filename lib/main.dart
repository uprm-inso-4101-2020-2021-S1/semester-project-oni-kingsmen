import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:password_app/generator.dart';
import 'package:password_app/password.dart';

void main() {
  runApp(MyApp());
}

List<Password> passwordList = new List();
List<Question> questionList = new List();
int userID = 0;

void createNewPassword(
    String password, String account, String email, String main, String notes) {
  print("creating password with" +
      " main: " +
      main +
      " account: " +
      account +
      " password: " +
      password);
  passwordList.add(Password(password.trim(), account.trim(), email.trim(),
      main.trim(), notes.trim()));
}

void createNewQuestion(String question, String answer, bool casesensitive) {
  print("creating question with" +
      " question: " +
      question +
      " answer: " +
      answer +
      " case: " +
      casesensitive.toString());
  questionList.add(Question(question.trim(), answer.trim(), casesensitive));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignInPage(),
    );
  }
}

Future<bool> onBackPressed(BuildContext context) async {
  return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('You are about to log out.'),
          content: new Text('Are you sure?'),
          actions: <Widget>[
            new GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              child: Text("NO"),
            ),
            SizedBox(height: 16),
            new GestureDetector(
              onTap: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text("YES"),
            ),
          ],
        ),
      ) ??
      false;
}

Future<bool> createSecurityQuestion(BuildContext context, Question question) {
  TextEditingController _controller = new TextEditingController();

  AlertDialog _withQuestion() {
    return AlertDialog(
      title: Text(question.question),
      content: TextField(
        controller: _controller,
      ),
      actions: <Widget>[
        MaterialButton(
            child: Text("Submit"),
            onPressed: () {
              _controller.text = _controller.text.trim();
              if (question.caseSensitive) {
                if (_controller.text == question.answer) {
                  Navigator.of(context).pop(true);
                } else {
                  Navigator.of(context).pop(false);
                }
              } else {
                if (_controller.text.toLowerCase() ==
                    question.answer.toLowerCase()) {
                  Navigator.of(context).pop(true);
                } else {
                  Navigator.of(context).pop(false);
                }
              }
            })
      ],
    );
  }

  AlertDialog _withRandomQuestion() {
    var rng = new Random();
    int chosenNum = rng.nextInt(questionList.length);
    return AlertDialog(
      title: Text(questionList[chosenNum].question),
      content: TextField(
        controller: _controller,
      ),
      actions: <Widget>[
        MaterialButton(
            child: Text("Submit"),
            onPressed: () {
              _controller.text = _controller.text.trim();
              if (questionList[chosenNum].caseSensitive) {
                if (_controller.text == questionList[chosenNum].answer) {
                  Navigator.of(context).pop(true);
                } else {
                  Navigator.of(context).pop(false);
                }
              } else {
                if (_controller.text.toLowerCase() ==
                    questionList[chosenNum].answer.toLowerCase()) {
                  Navigator.of(context).pop(true);
                } else {
                  Navigator.of(context).pop(false);
                }
              }
            })
      ],
    );
  }

  AlertDialog _withoutQuestion() {
    return AlertDialog(
      title: Text('You have no security questions available!'),
      content: Text(
          "You can add security questions by selecting the 'Security Questions' button in the Settings page."
          "\nAre you sure you want to continue?"),
      actions: <Widget>[
        MaterialButton(
            child: Text("Back"),
            onPressed: () {
              _controller.text = _controller.text.trim();
              Navigator.of(context).pop(false);
            }),
        MaterialButton(
            child: Text("Continue"),
            onPressed: () {
              _controller.text = _controller.text.trim();
              Navigator.of(context).pop(true);
            }),
      ],
    );
  }

  return showDialog(
    context: context,
    builder: (context) {
      if (question != null) {
        return _withQuestion();
      } else if (questionList.length > 0) {
        return _withRandomQuestion();
      } else {
        return _withoutQuestion();
      }
    },
  );
}

Drawer createDrawer(BuildContext context) {
  return new Drawer(
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text('Hello Guy!'),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          title: Text('Accounts'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        ListTile(
          title: Text('Settings'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingPage()),
            );
          },
        ),
        ListTile(
          title: Text('Log Out'),
          onTap: () {
            onBackPressed(context);
          },
        ),
      ],
    ),
  );
}

Drawer createPasswordDrawer(BuildContext context) {
  return new Drawer(
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text('Hello Guy!'),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          title: Text('Accounts'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        ListTile(
          title: Text('Settings'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingPage()),
            );
          },
        ),
        ListTile(
          title: Text('Log Out'),
          onTap: () {
            onBackPressed(context);
          },
        ),
      ],
    ),
  );
}

class BlankPage extends StatefulWidget {
  @override
  _BlankPageState createState() => _BlankPageState();
}

class _BlankPageState extends State<BlankPage> {
  @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for the major Material Components.
    return Scaffold();
  }
}

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for the major Material Components.
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Hello Guy!'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Accounts'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text('Log Out'),
              onTap: () {
                onBackPressed(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Settings Page'),
      ),
      // body is the majority of the screen.
      body: Center(
        child: RaisedButton(
          onPressed: () {
            createSecurityQuestion(context, null).then((answer) {
              if (answer == true) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OldQuestionsPage()),
                );
              } else {
                Fluttertoast.showToast(
                    msg: "Incorrect Answer", toastLength: Toast.LENGTH_SHORT);
              }
            });
          },
          child: Text('Security Questions'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add', // used by assistive technologies
        child: Icon(Icons.airline_seat_recline_extra),
        onPressed: null,
      ),
    );
  }
}

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {'username': null, 'password': null};

  // bool _obscureText;
  final _usernamecontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _confirmcontroller = TextEditingController();
  bool processing = false;

  @override
  void initState() {
    super.initState();
    _obscureConfirmText = true;
    _obscurePasswordText = true;
    getData();
  }

  Future getData() async {
    var url = 'http://oni-kingsmen-site.000webhostapp.com/get.php';
    http.Response response = await http.get(url);

    var data = jsonDecode(response.body);
    print(data.toString());
  }

  Future register() async {
    setState(() {
      processing = true;
    });
    var url = 'http://oni-kingsmen-site.000webhostapp.com/signup.php';
    var data = {
      'user': _usernamecontroller.text.trim().toLowerCase(),
      'pass': _passwordcontroller.text.trim(),
      'email': _emailcontroller.text.trim().toLowerCase(),
    };
    var res = await http.post(url, body: data);

    if (jsonDecode(res.body) == 'email exists') {
      Fluttertoast.showToast(
          msg: "Email already taken, try logging in.",
          toastLength: Toast.LENGTH_SHORT);
    } else if (jsonDecode(res.body) == 'user exists') {
      Fluttertoast.showToast(
          msg: "Account name already taken.", toastLength: Toast.LENGTH_SHORT);
    } else if (jsonDecode(res.body) == 'created') {
      Fluttertoast.showToast(
          msg: "Account created. Login with your new account",
          toastLength: Toast.LENGTH_SHORT);
      _passwordcontroller.text = '';
      _usernamecontroller.text = '';
      _emailcontroller.text = '';
      _confirmcontroller.text = '';
      setState(() {
        _signIn = true;
      });
    } else {
      Fluttertoast.showToast(
          msg: "Failed to create account. Try again later.",
          toastLength: Toast.LENGTH_SHORT);
    }

    setState(() {
      processing = false;
    });
  }

  Future login() async {
    setState(() {
      processing = true;
    });
    var url = 'http://oni-kingsmen-site.000webhostapp.com/signin.php';
    var data = {
      'user': _usernamecontroller.text.trim(),
      'pass': _passwordcontroller.text.trim(),
    };
    var res = await http.post(url, body: data);

    print(jsonDecode(res.body));
    if (jsonDecode(res.body) == 'false') {
      Fluttertoast.showToast(
          msg: "Incorrect Password", toastLength: Toast.LENGTH_SHORT);
    } else if (jsonDecode(res.body) == 'not found') {
      Fluttertoast.showToast(
          msg:
              RegExp(r"[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?")
                      .hasMatch(_usernamecontroller.text.trim())
                  ? "Email not found, try creating a new account."
                  : "Username not found, try logging in with your email.",
          toastLength: Toast.LENGTH_SHORT);
    } else {
      Fluttertoast.showToast(
          msg: "Account found", toastLength: Toast.LENGTH_SHORT);
      passwordList.clear();
      questionList.clear();
      var json = jsonDecode(res.body);
      print(json);
      userID = int.parse(json);
      _passwordcontroller.text = '';
      _usernamecontroller.text = '';

      getQuestions(userID.toString());
      getPasswords(userID.toString());
    }

    setState(() {
      processing = false;
    });
  }

  Future getPasswords(String userid) async {
    setState(() {
      processing = true;
    });
    var url = 'http://oni-kingsmen-site.000webhostapp.com/getpasswords.php';
    var data = {
      'id': userid,
    };

    var res = await http.post(url, body: data);
    List<dynamic> json = jsonDecode(res.body);
    print(json);
    setState(() {
      processing = false;
    });
    if (json != null) {
      print("not null");
      for (var password in json) {
        createNewPassword(password['password'], password['username'],
            password['email'], password['main'], password['notes']);
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BlankPage()),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  Future getQuestions(String userid) async {
    setState(() {
      processing = true;
    });
    var url = 'http://oni-kingsmen-site.000webhostapp.com/getquestions.php';
    var data = {
      'id': userid,
    };
    var res = await http.post(url, body: data);
    List<dynamic> json = jsonDecode(res.body);
    print(json);
    setState(() {
      processing = false;
    });
    if (json != null) {
      print("not null");
      for (var question in json) {
        createNewQuestion(
            question['question'].trim(),
            question['answer'].trim(),
            question['casesensitive'] == '0' ? false : true);
      }
    }
  }

  bool _signIn = true;

  Widget _loginBoxUI() {
    return Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FlatButton(
            onPressed: () {
              setState(() {
                _signIn = true;
                _passwordcontroller.text = '';
                _usernamecontroller.text = '';
                _emailcontroller.text = '';
                _confirmcontroller.text = '';
              });
            },
            child: Text("SIGN IN",
                style: new TextStyle(
                  fontSize: 25.0,
                  color: _signIn ? Colors.green : Colors.grey,
                )),
          ),
          FlatButton(
            onPressed: () {
              setState(() {
                _signIn = false;
                _passwordcontroller.text = '';
                _usernamecontroller.text = '';
                _emailcontroller.text = '';
                _confirmcontroller.text = '';
              });
            },
            child: Text("SIGN UP",
                style: new TextStyle(
                  fontSize: 25.0,
                  color: !_signIn ? Colors.green : Colors.grey,
                )),
          )
        ],
      ),
    );
  }

  Widget _buildForm() {
    if (_signIn) {
      return Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _loginBoxUI(),
              _buildUsernameField(),
              _buildPasswordField(),
              _buildSubmitButton(),
            ],
          ));
    }
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _loginBoxUI(),
            _buildUsernameField(),
            _buildEmailField(),
            _buildPasswordField(),
            _buildConfirmPasswordField(),
            _buildSubmitButton(),
          ],
        ));
  }

  Widget _buildUsernameField() {
    return Column(
      children: [
        new Padding(padding: EdgeInsets.only(top: 15.0)),
        new Text(_signIn ? 'Username or Email' : 'Username',
            style: new TextStyle(fontSize: 25.0)),
        new Padding(padding: EdgeInsets.only(top: 5.0)),
        new TextFormField(
            decoration: new InputDecoration(
              fillColor: Colors.white,
              labelText:
                  _signIn ? 'Username or Email (Debug: guy)' : 'New Username',
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(25.0),
                borderSide: new BorderSide(),
              ),
            ),
            controller: _usernamecontroller,
            onSaved: (username) {
              formData['username'] = username;
            },
            validator: (username) {
              if (username.length <= 0) {
                return "Please enter a username.";
              }
              if (!_signIn &&
                  RegExp(r"[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?")
                      .hasMatch(username)) {
                return 'Username cannot follow email format.';
              }
              return null;
            }),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      children: [
        new Padding(padding: EdgeInsets.only(top: 15.0)),
        new Text('Email', style: new TextStyle(fontSize: 25.0)),
        new Padding(padding: EdgeInsets.only(top: 5.0)),
        new TextFormField(
          decoration: new InputDecoration(
            fillColor: Colors.white,
            labelText: 'Email',
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: new BorderSide(),
            ),
          ),
          controller: _emailcontroller,
          onSaved: (email) {
            formData['email'] = email;
          },
          validator: (email) {
            if (email.length <= 0) {
              return 'Please enter a valid email';
            } else if (!RegExp(
                    r"[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?")
                .hasMatch(email)) {
              return 'This is an invalid email.';
            } else {
              return null;
            }
          },
        ),
      ],
    );
  }

  bool _obscurePasswordText;

  Widget _buildPasswordField() {
    return Column(
      children: [
        new Padding(padding: EdgeInsets.only(top: 5.0)),
        new Text('Master Password', style: new TextStyle(fontSize: 25.0)),
        new Padding(padding: EdgeInsets.only(top: 5.0)),
        new TextFormField(
          controller: _passwordcontroller,
          decoration: new InputDecoration(
            labelText: _signIn
                ? 'Master Password (Debug: 123)'
                : 'New Master Password',
            fillColor: Colors.white,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: new BorderSide(),
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscurePasswordText = !_obscurePasswordText;
                });
              },
              child: Icon(_obscurePasswordText
                  ? Icons.visibility
                  : Icons.visibility_off),
            ),
          ),
          // obscureText: _obscureText,
          obscureText: _obscurePasswordText,
          onSaved: (password) {
            formData['password'] = password;
          },
          validator: (password) =>
              password.length > 0 ? null : "Please enter a password.",
          //password == masterPassword ? null : 'Incorrect Master Password',
        )
      ],
    );
  }

  bool _obscureConfirmText;

  Widget _buildConfirmPasswordField() {
    return Column(
      children: [
        new Padding(padding: EdgeInsets.only(top: 5.0)),
        new Text('Confirm Password', style: new TextStyle(fontSize: 25.0)),
        new Padding(padding: EdgeInsets.only(top: 5.0)),
        new TextFormField(
          controller: _confirmcontroller,
          decoration: new InputDecoration(
            labelText: 'Enter Master Password again',
            fillColor: Colors.white,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: new BorderSide(),
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureConfirmText = !_obscureConfirmText;
                });
              },
              child: Icon(_obscureConfirmText
                  ? Icons.visibility
                  : Icons.visibility_off),
            ),
          ),
          // obscureText: _obscureText,
          obscureText: _obscureConfirmText,
          validator: (password) =>
              _confirmcontroller.text == _passwordcontroller.text
                  ? null
                  : "Password does not equal master password given.",
          //password == masterPassword ? null : 'Incorrect Master Password',
        )
      ],
    );
  }

  Widget _buildSubmitButton() {
    if (_signIn)
      return RaisedButton(
        onPressed: () {
          _submitForm();
        },
        child: processing == false
            ? Text('Sign In')
            : CircularProgressIndicator(
                backgroundColor: Colors.green,
              ),
      );

    //Sign up
    return RaisedButton(
      onPressed: () {
        _submitForm();
      },
      child: processing == false
          ? Text('Sign Up')
          : CircularProgressIndicator(
              backgroundColor: Colors.green,
            ),
    );
  }

  void _submitForm() {
    print('Submitting form');
    if (_formKey.currentState.validate()) {
      _usernamecontroller.text = _usernamecontroller.text.trim().toLowerCase();
      _passwordcontroller.text = _passwordcontroller.text.trim();
      _emailcontroller.text = _emailcontroller.text.trim().toLowerCase();
      _confirmcontroller.text = _confirmcontroller.text.trim();
      _formKey.currentState.save(); //onSaved is called!
      print(formData);
      if (!_signIn) {
        register();
      } else {
        login();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for the major Material Components.
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: _buildForm(),
    );
  }
}

class NewPasswordPage extends StatefulWidget {
  Password password;

  NewPasswordPage(Password password) {
    this.password = password;
  }

  @override
  _NewPasswordPageState createState() => _NewPasswordPageState(password);
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  Password password;

  _NewPasswordPageState(Password password) {
    this.password = password;
  }

  final _formKey = GlobalKey<FormState>();
  bool processing = false;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _mainController = TextEditingController();
  final _notesController = TextEditingController();

  final Map<String, dynamic> formData = {
    'main': null,
    'password': null,
    'email': '',
    'account': ''
  };

  bool _obscureText;

  @override
  void initState() {
    _obscureText = true;
    if (password != null) {
      _usernameController.text = password.account;
      _passwordController.text = password.password;
      _emailController.text = password.email;
      _mainController.text = password.main;
    }
    super.initState();
  }

  Widget _buildPasswordField() {
    return Column(
      children: [
        new Padding(padding: EdgeInsets.only(top: 5.0)),
        new Text('Password:', style: new TextStyle(fontSize: 15.0)),
        new Padding(padding: EdgeInsets.only(top: 2.5)),
        new TextFormField(
            controller: _passwordController,
            decoration: new InputDecoration(
              labelText: 'Password',
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(25.0),
                borderSide: new BorderSide(),
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off),
              ),
            ),
            obscureText: _obscureText,
            onSaved: (password) {
              formData['password'] = password;
            },
            validator: (password) {
              if (password.length <= 0) {
                return 'Please enter a password.';
              } else if (password.length > 128) {
                return 'Max Password Size: 128';
              }
              return null;
            }),
        new RaisedButton(
          child: new Text("Generate Password"),
          onPressed: () {
            passwordGeneratorPopup(context).then((generatedPassword) {
              _passwordController.text = generatedPassword;
            });
          },
        )
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      children: [
        new Padding(padding: EdgeInsets.only(top: 5.0)),
        new Text('Email (Optional):', style: new TextStyle(fontSize: 15.0)),
        new Padding(padding: EdgeInsets.only(top: 2.5)),
        new TextFormField(
          controller: _emailController,
          decoration: new InputDecoration(
            labelText: 'Email (Optional)',
            fillColor: Colors.white,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: new BorderSide(),
            ),
          ),
          onSaved: (email) {
            formData['email'] = email;
          },
          validator: (email) {
            if (email.length > 0 &&
                !RegExp(r"[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?")
                    .hasMatch(email)) {
              return 'This is an invalid email.';
            } else {
              return null;
            }
          },
        ),
      ],
    );
  }

  Widget _buildAccountField() {
    return Column(
      children: [
        new Padding(padding: EdgeInsets.only(top: 5.0)),
        new Text('Account Name (Optional):',
            textAlign: TextAlign.left, style: new TextStyle(fontSize: 15.0)),
        new Padding(padding: EdgeInsets.only(top: 2.5)),
        new TextFormField(
          controller: _usernameController,
          decoration: new InputDecoration(
            fillColor: Colors.white,
            labelText: 'Account Name (Optional)',
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: new BorderSide(),
            ),
          ),
          onSaved: (account) {
            formData['account'] = account;
          },
        ),
      ],
    );
  }

  Widget _buildMainField() {
    return Column(
      children: [
        new Padding(padding: EdgeInsets.only(top: 5.0)),
        new Text('Title:', style: new TextStyle(fontSize: 15.0)),
        new Padding(padding: EdgeInsets.only(top: 2.5)),
        new TextFormField(
            controller: _mainController,
            decoration: new InputDecoration(
              labelText: 'Title',
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(25.0),
                borderSide: new BorderSide(),
              ),
            ),
            onSaved: (title) {
              formData['main'] = title;
            },
            validator: (title) =>
                title.length <= 0 ? 'Please enter a title.' : null),
      ],
    );
  }

  Widget _buildSubmitButton() {
    if (processing == false)
      return RaisedButton(
        onPressed: () {
          _submitForm();
        },
        child: Text('Submit'),
      );
    else {
      return CircularProgressIndicator(
        backgroundColor: Colors.green,
      );
    }
  }

  void _submitForm() {
    print('Submitting form');
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save(); //onSaved is called!
      print(formData);
      if (password == null) {
        addPasswordToDB();
      } else {
        editPassword();
      }
    }
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildMainField(),
            _buildPasswordField(),
            _buildAccountField(),
            _buildEmailField(),
            _buildSubmitButton(),
          ],
        ));
  }

  Future addPasswordToDB() async {
    setState(() {
      processing = true;
    });

    var url = 'http://oni-kingsmen-site.000webhostapp.com/createpassword.php';
    var data = {
      'id': userID.toString(),
      'main': _mainController.text.trim(),
      'pass': _passwordController.text.trim(),
      'email': _emailController.text.trim(),
      'username': _usernameController.text.trim(),
      'notes': ''.trim(),
    };

    var res = await http.post(url, body: data);

    if (jsonDecode(res.body) == 'exists') {
      Fluttertoast.showToast(
          msg: "Given Title and Password already exist.",
          toastLength: Toast.LENGTH_SHORT);
    } else if (jsonDecode(res.body) == 'created') {
      Fluttertoast.showToast(
          msg: "New Password Added", toastLength: Toast.LENGTH_SHORT);
      createNewPassword(
          _passwordController.text.trim(),
          _usernameController.text.trim(),
          _emailController.text.trim(),
          _mainController.text.trim(),
          _notesController.text.trim());
      _passwordController.text = '';
      _usernameController.text = '';
      _emailController.text = '';
      _mainController.text = '';

      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      Fluttertoast.showToast(
          msg: "Failed to create password.", toastLength: Toast.LENGTH_SHORT);
    }

    setState(() {
      processing = false;
    });
  }

  Future editPassword() async {
    setState(() {
      processing = true;
    });

    var url = (password.main == _mainController.text &&
            password.password == _passwordController.text)
        ? 'http://oni-kingsmen-site.000webhostapp.com/editcurrentpassword.php'
        : 'http://oni-kingsmen-site.000webhostapp.com/editpassword.php';

    var data = {
      'id': userID.toString(),
      'oldmain': password.main,
      'oldpass': password.password,
      'main': _mainController.text.trim(),
      'pass': _passwordController.text.trim(),
      'email': _emailController.text.trim(),
      'user': _usernameController.text.trim(),
      'notes': ''.trim(),
    };

    var res = await http.post(url, body: data);
    print(jsonDecode(res.body));
    if (jsonDecode(res.body) == 'exists') {
      Fluttertoast.showToast(
          msg: "Given Title and Password already exist.",
          toastLength: Toast.LENGTH_SHORT);
    } else if (jsonDecode(res.body) == 'no') {
      Fluttertoast.showToast(
          msg: "Failed to edit password.", toastLength: Toast.LENGTH_SHORT);
    } else if (jsonDecode(res.body) == true) {
      Fluttertoast.showToast(
          msg: "Password Edited", toastLength: Toast.LENGTH_SHORT);

      password.main = _mainController.text;
      password.password = _passwordController.text;
      password.account = _usernameController.text;
      password.email = _emailController.text;

      _passwordController.text = '';
      _usernameController.text = '';
      _emailController.text = '';
      _mainController.text = '';

      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      Fluttertoast.showToast(
          msg: "An error occurred. Try again later.",
          toastLength: Toast.LENGTH_SHORT);
    }

    setState(() {
      processing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for the major Material Components.

    return Scaffold(
        appBar: AppBar(
          title: Text(password == null ? 'New Password Page' : 'Edit Password'),
        ),
        drawer: createPasswordDrawer(context),
        // body is the majority of the screen.
        body: _buildForm());
  }
}

class QuestionPage extends StatefulWidget {
  Question question;

  QuestionPage(Question question) {
    this.question = question;
  }

  @override
  _QuestionPageState createState() => _QuestionPageState(question);
}

class _QuestionPageState extends State<QuestionPage> {
  Question question;

  _QuestionPageState(Question question) {
    this.question = question;
  }

  Widget _deleteButton() {
    TextEditingController _controller = new TextEditingController();
    return RaisedButton(
      onPressed: () {
        createSecurityQuestion(context, question);
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                  'Are you sure you want to delete this Security Question?'),
              content: Column(
                children: [
                  Text(question.question),
                  Text("Type 'yes' to confirm."),
                  TextField(
                    controller: _controller,
                  ),
                ],
              ),
              actions: <Widget>[
                MaterialButton(
                    child: Text("Submit"),
                    onPressed: () {
                      _controller.text = _controller.text.trim().toLowerCase();
                      if (_controller.text == 'yes') {
                        _deleteQuestion();
                      } else {
                        Navigator.of(context).pop();
                      }
                    })
              ],
            );
          },
        );
      },
      child: Text('Delete Question'),
    );
  }

  Future _deleteQuestion() async {
    setState(() {
      processing = true;
    });

    var url = 'http://oni-kingsmen-site.000webhostapp.com/deletequestion.php';
    var data = {
      'id': userID.toString(),
      'question': question.question,
    };

    var res = await http.post(url, body: data);
    print("JSONRES: " + jsonDecode(res.body));
    if (jsonDecode(res.body) == 'true') {
      Fluttertoast.showToast(
          msg: "Question Deleted", toastLength: Toast.LENGTH_SHORT);

      questionList.remove(question);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (jsonDecode(res.body) == 'false') {
      Fluttertoast.showToast(
          msg: "Failed to delete question.", toastLength: Toast.LENGTH_SHORT);
    } else {
      Fluttertoast.showToast(
          msg: "An error occurred. Try again later.",
          toastLength: Toast.LENGTH_SHORT);
    }

    setState(() {
      processing = false;
    });
  }

  final _formKey = GlobalKey<FormState>();
  bool processing = false;
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  final Map<String, dynamic> formData = {
    'question': null,
    'answer': null,
    'casesensitive': null,
  };

  bool _obscureText;

  @override
  void initState() {
    _obscureText = true;

    if (question != null) {
      _questionController.text = question.question;
      _answerController.text = question.answer;
      checkboxValue = question.caseSensitive;
      _obscureText = true;
    } else {
      checkboxValue = false;
    }
    super.initState();
  }

  Widget _buildAnswerField() {
    return Column(
      children: [
        new Padding(padding: EdgeInsets.only(top: 5.0)),
        new Text('Answer:', style: new TextStyle(fontSize: 15.0)),
        new Padding(padding: EdgeInsets.only(top: 2.5)),
        new TextFormField(
            controller: _answerController,
            decoration: new InputDecoration(
              labelText: 'Answer',
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(25.0),
                borderSide: new BorderSide(),
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off),
              ),
            ),
            obscureText: _obscureText,
            onSaved: (answer) {
              formData['answer'] = answer;
            },
            validator: (answer) {
              if (answer.length <= 0) {
                return 'Please enter an answer.';
              } else if (answer.length > 128) {
                return 'Max Answer Size: 128';
              }
              return null;
            }),
      ],
    );
  }

  Widget _buildQuestionField() {
    return Column(
      children: [
        new Padding(padding: EdgeInsets.only(top: 5.0)),
        new Text('Question:', style: new TextStyle(fontSize: 15.0)),
        new Padding(padding: EdgeInsets.only(top: 2.5)),
        new TextFormField(
            controller: _questionController,
            decoration: new InputDecoration(
              labelText: 'Title',
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(25.0),
                borderSide: new BorderSide(),
              ),
            ),
            onSaved: (question) {
              formData['question'] = question;
            },
            validator: (question) {
              if (question.length <= 0) {
                return 'Please enter an answer.';
              } else if (question.length > 128) {
                return 'Max Answer Size: 128';
              }
              return null;
            }),
      ],
    );
  }

  var checkboxValue;

  Widget _caseSensitiveBox() {
    return CheckboxListTile(
      value: checkboxValue,
      onChanged: (val) {
        setState(() {
          checkboxValue = val;
        });
      },
      title:
          new Text('Case Sensitive Answer', style: TextStyle(fontSize: 14.0)),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.green,
    );
  }

  Widget _buildSubmitButton() {
    if (processing == false)
      return RaisedButton(
        onPressed: () {
          _submitForm();
        },
        child: Text('Submit'),
      );
    else {
      return CircularProgressIndicator(
        backgroundColor: Colors.green,
      );
    }
  }

  void _submitForm() {
    print('Submitting form');
    if (_formKey.currentState.validate()) {
      checkboxValue
          ? formData['casesensitive'] = '1'
          : formData['casesensitive'] = '0';
      _formKey.currentState.save(); //onSaved is called!
      print(formData);
      if (question == null) {
        addQuestionToDB();
      } else {
        editQuestion();
      }
    }
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildQuestionField(),
            _buildAnswerField(),
            _caseSensitiveBox(),
            _buildSubmitButton(),
            if (question != null) _deleteButton(),
          ],
        ));
  }

  Future addQuestionToDB() async {
    setState(() {
      processing = true;
    });

    var url = 'http://oni-kingsmen-site.000webhostapp.com/createquestion.php';
    var data = {
      'id': userID.toString(),
      'question': _questionController.text.trim(),
      'answer': _answerController.text.trim(),
      'case': checkboxValue ? '1' : '0',
    };

    var res = await http.post(url, body: data);

    if (jsonDecode(res.body) == 'exists') {
      Fluttertoast.showToast(
          msg: "Given Question already exists.",
          toastLength: Toast.LENGTH_SHORT);
    } else if (jsonDecode(res.body) == 'created') {
      Fluttertoast.showToast(
          msg: "New Question Added", toastLength: Toast.LENGTH_SHORT);
      createNewQuestion(_questionController.text.trim(),
          _answerController.text.trim(), checkboxValue);

      _questionController.text = '';
      _answerController.text = '';

      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      Fluttertoast.showToast(
          msg: "Failed to create question.", toastLength: Toast.LENGTH_SHORT);
    }

    setState(() {
      processing = false;
    });
  }

  Future editQuestion() async {
    setState(() {
      processing = true;
    });

    var url = (question.question.toLowerCase() ==
            _questionController.text.toLowerCase())
        ? 'http://oni-kingsmen-site.000webhostapp.com/editcurrentquestion.php'
        : 'http://oni-kingsmen-site.000webhostapp.com/editquestion.php';

    var data = {
      'id': userID.toString(),
      'oldquestion': question.question,
      'oldanswer': question.answer,
      'question': _questionController.text.trim(),
      'answer': _answerController.text.trim(),
      'case': checkboxValue ? '1' : '0',
    };

    var res = await http.post(url, body: data);
    print(jsonDecode(res.body));
    if (jsonDecode(res.body) == 'exists') {
      Fluttertoast.showToast(
          msg: "Given Question already exists.",
          toastLength: Toast.LENGTH_SHORT);
    } else if (jsonDecode(res.body) == 'no') {
      Fluttertoast.showToast(
          msg: "Failed to edit question.", toastLength: Toast.LENGTH_SHORT);
    } else if (jsonDecode(res.body) == true) {
      Fluttertoast.showToast(
          msg: "Question Edited", toastLength: Toast.LENGTH_SHORT);

      question.question = _questionController.text;
      question.answer = _answerController.text;
      question.caseSensitive = checkboxValue;

      _questionController.text = '';
      _answerController.text = '';

      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      Fluttertoast.showToast(
          msg: "An error occurred. Try again later.",
          toastLength: Toast.LENGTH_SHORT);
    }

    setState(() {
      processing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for the major Material Components.

    return Scaffold(
        appBar: AppBar(
          title: Text(question == null
              ? 'New Security Question Page'
              : 'Edit Security Question'),
        ),
        drawer: createPasswordDrawer(context),
        // body is the majority of the screen.
        body: _buildForm());
  }
}

class OldQuestionsPage extends StatefulWidget {
  OldQuestionsPage({Key key}) : super(key: key);

  @override
  _OldQuestionsPageState createState() => _OldQuestionsPageState();
}

class _OldQuestionsPageState extends State<OldQuestionsPage> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Security Questions"),
      ),
      // drawer: createDrawer(context),
      body: ListView.builder(
        itemCount: questionList.length,
        itemBuilder: (context, index) {
          final questionItem = questionList[index];

          return ListTile(
            onTap: () {
              createSecurityQuestion(context, questionItem).then((answer) {
                if (answer == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QuestionPage(questionItem)),
                  );
                } else {
                  Fluttertoast.showToast(
                      msg: "Incorrect Answer", toastLength: Toast.LENGTH_SHORT);
                }
              });
            },
            title: Text(questionItem.question),
            trailing: IconButton(
              icon: Icon(Icons.menu),
              tooltip: 'Details',
              onPressed: () {
                createSecurityQuestion(context, questionItem).then((answer) {
                  if (answer == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuestionPage(questionItem)),
                    );
                  } else {
                    Fluttertoast.showToast(
                        msg: "Incorrect Answer",
                        toastLength: Toast.LENGTH_SHORT);
                  }
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QuestionPage(null)),
          );
        },
        tooltip: 'Add New Security Question',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackPressed(context),
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Password App"),
        ),
        drawer: createDrawer(context),
        body: ListView.builder(
          itemCount: passwordList.length,
          itemBuilder: (context, index) {
            final passwordItem = passwordList[index];

            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OldPasswordPage(passwordItem)),
                );
              },
              title: Text(passwordItem.main),
              subtitle: Text(passwordItem.account),
              trailing: IconButton(
                icon: Icon(Icons.menu),
                tooltip: 'Details',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OldPasswordPage(passwordItem)),
                  );
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewPasswordPage(null)),
            );
          },
          tooltip: 'Add New Password',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

class OldPasswordPage extends StatefulWidget {
  Password password;

  OldPasswordPage(Password password) {
    this.password = password;
  }

  @override
  _OldPasswordPageState createState() => _OldPasswordPageState(password);
}

class _OldPasswordPageState extends State<OldPasswordPage> {
  Password password;
  bool _obscureText;
  final _controller = TextEditingController();

  _OldPasswordPageState(Password password) {
    this.password = password;
  }

  bool processing = false;

  Future _deletePassword() async {
    setState(() {
      processing = true;
    });

    var url = 'http://oni-kingsmen-site.000webhostapp.com/deletepassword.php';
    var data = {
      'id': userID.toString(),
      'main': password.main,
      'pass': password.password,
    };

    var res = await http.post(url, body: data);
    print("JSONRES: " + jsonDecode(res.body));
    if (jsonDecode(res.body) == 'true') {
      Fluttertoast.showToast(
          msg: "Password Deleted", toastLength: Toast.LENGTH_SHORT);

      passwordList.remove(password);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (jsonDecode(res.body) == 'false') {
      Fluttertoast.showToast(
          msg: "Failed to delete password.", toastLength: Toast.LENGTH_SHORT);
    } else {
      Fluttertoast.showToast(
          msg: "An error occurred. Try again later.",
          toastLength: Toast.LENGTH_SHORT);
    }

    setState(() {
      processing = false;
    });
  }

  @override
  void initState() {
    _controller.text = password.password;
    _obscureText = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for the major Material Components.
    return Scaffold(
      appBar: AppBar(
        title: Text(password.main),
      ),
      drawer: createPasswordDrawer(context),
      // body is the majority of the screen.
      body: ListView(
        children: [
          ListTile(
            title: Text("Account:"),
            subtitle: Text(password.account),
          ),
          ListTile(
            title: Text("Password:"),
            subtitle: TextField(
              readOnly: true,
              controller: _controller,
              obscureText: _obscureText,
            ),
          ),
          new IconButton(
              icon: Icon(Icons.visibility),
              onPressed: () {
                if (_obscureText) {
                  createSecurityQuestion(context, null).then((answer) {
                    print(answer);
                    if (answer == true) {
                      setState(() {
                        _obscureText = false;
                      });
                    } else {
                      Fluttertoast.showToast(
                          msg: "Incorrect Answer",
                          toastLength: Toast.LENGTH_SHORT);
                    }
                  });
                } else {
                  setState(() {
                    _obscureText = true;
                  });
                }
              }),
          ListTile(
            title: Text("Email:"),
            subtitle: Text(password.email),
          ),
          RaisedButton(
            onPressed: () {
              createSecurityQuestion(context, null).then((answer) {
                if (answer == true) {
                  _deletePassword();
                } else {
                  Fluttertoast.showToast(
                      msg: "Incorrect Answer", toastLength: Toast.LENGTH_SHORT);
                }
              });
            },
            child: Text('Delete Password'),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        tooltip: 'Edit',
        child: Icon(Icons.edit),
        onPressed: () {
          createSecurityQuestion(context, null).then((answer) {
            print(answer);
            if (answer == true) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewPasswordPage(password)),
              );
            } else {
              Fluttertoast.showToast(
                  msg: "Incorrect Answer", toastLength: Toast.LENGTH_SHORT);
            }
          });
        },
      ),
    );
  }
}
