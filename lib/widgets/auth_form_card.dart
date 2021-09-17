import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_store/utils/app_string.dart';
import 'package:flutter_store/providers/auth_provider.dart';
import 'package:flutter_store/exceptions/auth_exception.dart';

enum AuthMode { Signup, Login }

class AuthCardWidget extends StatefulWidget {
  @override
  _AuthCardWidgetState createState() => _AuthCardWidgetState();
}

class _AuthCardWidgetState extends State<AuthCardWidget> {
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;
  GlobalKey<FormState> _form = GlobalKey();
  final _passwordController = TextEditingController();

  bool _isLogin() => _authMode == AuthMode.Login;
  bool _isSignup() => _authMode == AuthMode.Signup;

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    _form.currentState?.save();

    Auth auth = Provider.of(context, listen: false);

    try {
      if (_isLogin()) {
        await auth.login(
          _authData["email"] as String,
          _authData["password"] as String,
        );
      } else {
        await auth.signup(
          _authData["email"] as String,
          _authData["password"] as String,
        );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Erro inesperado.');
    }

    setState(() => _isLoading = false);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppString.titleAlertError),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppString.closeAlertError,
            ),
          )
        ],
      ),
    );
  }

  void _switchAuthMode() {
    if (_isLogin()) {
      setState(() => _authMode = AuthMode.Signup);
    } else {
      setState(() => _authMode = AuthMode.Login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        height: _isLogin() ? 300 : 370,
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: AppString.labelEmail,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return AppString.authInvalidEmail;
                  }
                  return null;
                },
                onSaved: (email) => _authData['email'] = email ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: AppString.labelPassword,
                ),
                keyboardType: TextInputType.text,
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value!.isEmpty || value.length < 5) {
                    return AppString.authInvalidPassword;
                  }
                  return null;
                },
                onSaved: (password) => _authData['password'] = password ?? '',
              ),
              if (_isSignup())
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppString.labelConfirmPassword,
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  validator: _isLogin()
                      ? null
                      : (value) {
                          if (value != _passwordController.text) {
                            return AppString.notConfirmedPassword;
                          }
                          return null;
                        },
                ),
              Spacer(),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      child: Text(
                        _authMode == AuthMode.Login
                            ? AppString.authSignin
                            : AppString.authRegister,
                      ),
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30.0,
                          vertical: 8.0,
                        ),
                      ),
                    ),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(
                  "${_authMode == AuthMode.Login ? AppString.authRegister : AppString.authSignin}",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
