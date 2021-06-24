import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:sahabatjaya/services/srv_login.dart';
import 'package:sahabatjaya/widgets/basics/styles.dart';
import 'package:sahabatjaya/widgets/basics/validate.dart';

class PageLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Creating Form Login");
    return ChangeNotifierProvider(
      create: (context) => ServiceLogin(Provider.of<UserProvider>(context, listen: false)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Log In'),
          leading: Container(),
        ),
        body: Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
              child: LogInForm(),
//              child: Navigator.pushNamed(context, '/'),
            ),
          ),
        ),
      ),
    );
  }
}

class LogInForm extends StatefulWidget {
  const LogInForm({Key key}) : super(key: key);

  @override
  LogInFormState createState() => LogInFormState();
}

class LogInFormState extends State<LogInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String uname;
  String password;
  String message = '';

  Future<void> submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      print("UserName: $uname" );
      await Provider.of<ServiceLogin>(context, listen: false).loginAPI(context, uname, password);
    }
  }

  @override
  Widget build(BuildContext context) {
//    Provider.of<ServiceLogin>(context) = ()=>Navigator.pushNamed(context, '/');
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Log in to the App',
            textAlign: TextAlign.center,
//            style: Styles.h1,
          ),
          SizedBox(height: 10.0),
          Consumer<ServiceLogin>(
            builder: (context, provider, child) => Text(provider.pesan),
          ),
          SizedBox(height: 30.0),
          TextFormField(
              decoration: Styles.input.copyWith(
                hintText: 'Email',
              ),
              validator: (value) {
                uname = value.trim();
                return Validate.validateEmail(value);
              }
          ),
          SizedBox(height: 15.0),
          TextFormField(
              obscureText: true,
              decoration: Styles.input.copyWith(
                hintText: 'Password',
              ),
              validator: (value) {
                password = value.trim();
                return Validate.requiredField(value, 'Password is required.');
              }
          ),
          SizedBox(height: 15.0),
          FlatButton(
            child: Text('Sign In'),
            onPressed: submit,
          ),
          SizedBox(height: 20.0),
          Center(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Don't have an account? ",
                    style: Styles.p,
                  ),
                  TextSpan(
                    text: 'Register.',
                    style: Styles.p.copyWith(color: Colors.blue[500]),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => {
                        Navigator.pushNamed(context, '/register'),
                      },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Center(
            child: RichText(
              text: TextSpan(
                  text: 'Forgot Your Password?',
                  style: Styles.p.copyWith(color: Colors.blue[500]),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => {
                      Navigator.pushNamed(context, '/password-reset'),
                    }
              ),
            ),
          ),
        ],
      ),
    );
  }
}
