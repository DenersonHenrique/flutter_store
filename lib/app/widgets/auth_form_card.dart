import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_store/app/utils/app_string.dart';
import 'package:flutter_store/app/providers/auth_provider.dart';
import 'package:flutter_store/app/exceptions/auth_exception.dart';

enum AuthMode { Signup, Login }

class AuthCardWidget extends StatefulWidget {
  @override
  _AuthCardWidgetState createState() => _AuthCardWidgetState();
}

class _AuthCardWidgetState extends State<AuthCardWidget>
    with TickerProviderStateMixin {
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;
  GlobalKey<FormState> _form = GlobalKey();
  final _passwordController = TextEditingController();

  AnimationController? _controller;
  Animation<double>? _opacityAnimation;
  Animation<Offset>? _slideAnimation;

  bool _isLogin() => _authMode == AuthMode.Login;
  // bool _isSignup() => _authMode == AuthMode.Signup;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.linear,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

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
      _showErrorDialog(AppString.unexpectedError);
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
      _controller?.forward();
    } else {
      setState(() => _authMode = AuthMode.Login);
      _controller?.reverse();
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
      child: AnimatedContainer(
        height: _isLogin() ? 310.0 : 370.0,
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
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
              AnimatedContainer(
                constraints: BoxConstraints(
                  minHeight: _isLogin() ? 0 : 60.0,
                  maxHeight: _isLogin() ? 0 : 120.0,
                ),
                duration: Duration(milliseconds: 300),
                curve: Curves.linear,
                child: FadeTransition(
                  opacity: _opacityAnimation!,
                  child: SlideTransition(
                    position: _slideAnimation!,
                    child: TextFormField(
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
                  ),
                ),
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
