import 'package:flutter/material.dart';
import 'package:password_app/generator.dart';
import 'package:password_app/password.dart';

void main() {
  createNewPassword('password', 'accountname', 'email@domain.com', 'Title');
  createNewPassword('1234', 'hehe', 'el@dan.com', 'Taitle 2');
  createNewPassword('12 64 10', '', '', 'The Safe');
  generatePassword(20, 5, 5);
  generatePassword(10, 5, 5);
  generatePassword(9, 5, 5);
  generatePassword(20, 0, 0);
  generatePassword(5, 1, 5);
  generatePassword(5, 1, 1);
  runApp(MyApp());
}

List<Password> passwordList = new List();

List<Password> getPasswords() {
  return passwordList;
}

void createNewPassword(
    String password, String account, String email, String main) {
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
      home: MyHomePage(title: 'Password App'),
    );
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
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Accounts'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(title: 'Password App')),
                );
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingPage()),
                );
              },
            ),
            ListTile(
              title: Text('Log Out'),
              onTap: () {
                // Update the state of the app.
                // ...
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
        child: Text('Settings'),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add', // used by assistive technologies
        child: Icon(Icons.airline_seat_recline_extra),
        onPressed: null,
      ),
    );
  }
}

class NewPasswordPage extends StatefulWidget {
  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _formKey = GlobalKey<FormState>();
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
  final _controller = TextEditingController();

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
          controller: _controller,
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
              child:
                  Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
            ),
          ),
          obscureText: _obscureText,
          onSaved: (password) {
            formData['password'] = password;
          },
          validator: (password) =>
              password.length <= 0 ? 'Please enter a password.' : null,
        ),
        new RaisedButton(
          child: new Text("Generate Password"),
          onPressed: () {
            _controller.text = generatePassword(10, 3, 2);
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
          decoration: new InputDecoration(
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
                !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                    .hasMatch(email)) {
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
      createNewPassword(formData['password'], formData['account'],
          formData['email'], formData['main']);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(title: 'Password App')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for the major Material Components.

    return Scaffold(
        appBar: AppBar(
          title: Text('New Password Page'),
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Accounts'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MyHomePage(title: 'Password App')),
                  );
                },
              ),
              ListTile(
                title: Text('Settings'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingPage()),
                  );
                },
              ),
              ListTile(
                title: Text('Log Out'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
        // body is the majority of the screen.
        body: _buildForm());
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Accounts'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(title: 'Password App')),
                );
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingPage()),
                );
              },
            ),
            ListTile(
              title: Text('Log Out'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: passwordList.length,
        itemBuilder: (context, index) {
          final passwordItem = passwordList[index];

          return ListTile(
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
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Accounts'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(title: 'Password App')),
                );
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingPage()),
                );
              },
            ),
            ListTile(
              title: Text('Log Out'),
              onTap: () {},
            ),
          ],
        ),
      ),
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
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                }),
          ),
          // new IconButton(
          //     icon: Icon(Icons.visibility),
          //     onPressed: (){
          //       setState(() {
          //         _obscureText = !_obscureText;
          //       });
          //     }
          // ),
          ListTile(
            title: Text("Email:"),
            subtitle: Text(password.email),
          )
        ],
      ),
    );
  }
}
