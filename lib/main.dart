import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:password_app/generator.dart';
import 'package:password_app/password.dart';

void main() {
  runApp(MyApp());
}

List<Password> passwordList = new List();
int userID = 0;

// List<Password> getPasswords() {
//   return passwordList;
// }

void createNewPassword(
    String password, String account, String email, String main) {
  print("creating password with" +
      " main: " +
      main +
      " account: " +
      account +
      " password: " +
      password);
  passwordList.add(Password(password, account, email, main));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password App',
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

Future<String> createSecurityQuestion(BuildContext context) {
  TextEditingController controller = new TextEditingController();

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Security Question (Debug answer: abc"),
        content: TextField(
          controller: controller,
        ),
        actions: <Widget>[
          MaterialButton(
              child: Text("Submit"),
              onPressed: () {
                Navigator.of(context).pop(controller.text.toString());
              })
        ],
      );
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
            // Navigator.of(context).popUntil((route) => route.isFirst);
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
            // Navigator.of(context).popUntil((route) => route.isFirst);
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
    return WillPopScope(
      onWillPop: () => onBackPressed(context),
      child: Scaffold(
        drawer: createDrawer(context),
        appBar: AppBar(
          title: Text('Settings Page'),
        ),
        // body is the majority of the screen.
        body: Center(
          child: Text('Settings'),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add', // used by assistive technologies
          child: Icon(Icons.airline_seat_recline_extra),
          onPressed: null,
        ),
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
  bool processing = false;

  @override
  void initState() {
    super.initState();
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
      'user': _usernamecontroller.text,
      'pass': _passwordcontroller.text,
    };

    var res = await http.post(url, body: data);

    if (jsonDecode(res.body) == 'exists') {
      Fluttertoast.showToast(
          msg: "Account already exists", toastLength: Toast.LENGTH_SHORT);
    } else if (jsonDecode(res.body) == 'created') {
      Fluttertoast.showToast(
          msg: "Account created", toastLength: Toast.LENGTH_SHORT);
      _passwordcontroller.text = '';
      _usernamecontroller.text = '';
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomePage()),
      // );
    } else {
      Fluttertoast.showToast(msg: "failed", toastLength: Toast.LENGTH_SHORT);
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
      'user': _usernamecontroller.text,
      'pass': _passwordcontroller.text,
    };

    var res = await http.post(url, body: data);

    print(jsonDecode(res.body));
    if (jsonDecode(res.body) == 'false') {
      Fluttertoast.showToast(
          msg: "Incorrect Password", toastLength: Toast.LENGTH_SHORT);
    } else if (jsonDecode(res.body) == 'not found') {
      Fluttertoast.showToast(
          msg: "Username not found, try creating a new account.",
          toastLength: Toast.LENGTH_SHORT);
    } else {
      Fluttertoast.showToast(
          msg: "Account found", toastLength: Toast.LENGTH_SHORT);
      passwordList.clear();
      var json = jsonDecode(res.body);
      print(json);
      userID = int.parse(json);
      _passwordcontroller.text = '';
      _usernamecontroller.text = '';
      getpasswords(userID.toString());
    }

    setState(() {
      processing = false;
    });
  }

  Future getpasswords(String userid) async {
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
            password['email'], password['main']);
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

  bool _signIn = true;

  Widget boxUI() {
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
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            boxUI(),
            _buildUsernameField(),
            _buildPasswordField(),
            _buildSubmitButton(),
          ],
        ));
  }

  Widget _buildUsernameField() {
    return Column(
      children: [
        new Text('Username', style: new TextStyle(fontSize: 25.0)),
        new Padding(padding: EdgeInsets.only(top: 5.0)),
        new TextFormField(
          decoration: new InputDecoration(
            fillColor: Colors.white,
            labelText: '(Debug: guy)',
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: new BorderSide(),
            ),
          ),
          controller: _usernamecontroller,
          onSaved: (username) {
            formData['username'] = username;
          },
          validator: (username) =>
              // username == masterUsername ? null : 'Incorrect Username',
              username.length > 0 ? null : "enter",
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      children: [
        new Text('Password', style: new TextStyle(fontSize: 25.0)),
        new Padding(padding: EdgeInsets.only(top: 5.0)),
        new TextFormField(
          controller: _passwordcontroller,
          decoration: new InputDecoration(
            labelText: '(Debug: 123)',
            fillColor: Colors.white,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: new BorderSide(),
            ),
            // suffixIcon: GestureDetector(
            //   onTap: () {
            //     setState(() {
            //       _obscureText = !_obscureText;
            //     });
            //   },
            //   child:
            //   Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
            // ),
          ),
          // obscureText: _obscureText,
          obscureText: true,
          onSaved: (password) {
            formData['password'] = password;
          },
          validator: (password) => password.length > 0 ? null : "enter",
          //password == masterPassword ? null : 'Incorrect Master Password',
        )
      ],
    );
  }

  Widget _buildSubmitButton() {
    return RaisedButton(
      onPressed: () {
        _submitForm();
      },
      child: processing == false
          ? Text('Login')
          : CircularProgressIndicator(
              backgroundColor: Colors.green,
            ),
    );
  }

  void _submitForm() {
    print('Submitting form');
    if (_formKey.currentState.validate()) {
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
  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  bool processing = false;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _mainController = TextEditingController();

  final Map<String, dynamic> formData = {
    'main': null,
    'password': null,
    'email': '',
    'account': ''
  };

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildMainField(),
            _buildPasswordField(),
            _buildAccountField(),
            _buildEmailField(),
            _buildSubmitButton(),
          ],
        ));
  }

  bool _obscureText;

  @override
  void initState() {
    _obscureText = false;
    super.initState();
  }

  Widget _buildPasswordField() {
    return Column(
      children: [
        new Text('Password', style: new TextStyle(fontSize: 25.0)),
        new Padding(padding: EdgeInsets.only(top: 5.0)),
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
        new Text('Email (Optional)', style: new TextStyle(fontSize: 25.0)),
        new Padding(padding: EdgeInsets.only(top: 5.0)),
        new TextFormField(
          controller: _emailController,
          decoration: new InputDecoration(
            fillColor: Colors.white,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: new BorderSide(),
            ),
          ),
          onSaved: (email) {
            _emailController.text = _emailController.text.toLowerCase();
            formData['email'] = email.toLowerCase();
          },
          validator: (email) {
            _emailController.text = _emailController.text.toLowerCase();
            if (email.length > 0 &&
                !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                    .hasMatch(email.toLowerCase())) {
              return 'This is not a valid email';
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
        new Text('Account Name (Optional)',
            style: new TextStyle(fontSize: 25.0)),
        new Padding(padding: EdgeInsets.only(top: 5.0)),
        new TextFormField(
          controller: _usernameController,
          decoration: new InputDecoration(
            fillColor: Colors.white,
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
        new Text('Title', style: new TextStyle(fontSize: 25.0)),
        new Padding(padding: EdgeInsets.only(top: 5.0)),
        new TextFormField(
            controller: _mainController,
            decoration: new InputDecoration(
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
                title.length <= 0 ? 'Please enter a Title' : null),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return RaisedButton(
      onPressed: () {
        _submitForm();
      },
      child: Text('Submit'),
    );
  }

  void _submitForm() {
    print('Submitting form');
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save(); //onSaved is called!
      print(formData);
      addPasswordToDB();
    }
  }

  Future addPasswordToDB() async {
    setState(() {
      processing = true;
    });

    var url = 'http://oni-kingsmen-site.000webhostapp.com/createpassword.php';
    var data = {
      'id': userID.toString(),
      'main': _mainController.text,
      'pass': _passwordController.text,
      'email': _emailController.text,
      'username': _usernameController.text,
      'notes': '',
    };

    var res = await http.post(url, body: data);

    if (jsonDecode(res.body) == 'exists') {
      Fluttertoast.showToast(
          msg: "Given Title and Password already exist.",
          toastLength: Toast.LENGTH_SHORT);
    } else if (jsonDecode(res.body) == 'created') {
      Fluttertoast.showToast(
          msg: "New Password Added", toastLength: Toast.LENGTH_SHORT);
      createNewPassword(_passwordController.text, _usernameController.text,
          _emailController.text = '', _mainController.text);
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

  @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for the major Material Components.

    return Scaffold(
        appBar: AppBar(
          title: Text('New Password Page'),
        ),
        drawer: createPasswordDrawer(context),
        // body is the majority of the screen.
        body: _buildForm());
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
              MaterialPageRoute(builder: (context) => NewPasswordPage()),
            );
          },
          tooltip: 'Increment',
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
  String securityAnswer = "abc";
  final _controller = TextEditingController();

  _OldPasswordPageState(Password password) {
    this.password = password;
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
                  createSecurityQuestion(context).then((answer) {
                    print(answer);
                    if (answer == securityAnswer) {
                      setState(() {
                        _obscureText = false;
                      });
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
          )
        ],
      ),
    );
  }
}
