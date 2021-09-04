import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '';
  String _emailError = '';
  bool _emailShowError = false;  

  String _password = '';
  String _passwordError = '';
  bool _passwordShowError = false;
  bool _passwordShow = false;

  bool _rememberme = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _showLogo(),
          SizedBox(height: 20,),
          _showEmail(),
          _showPassword(),
          _showRememberme(),
          _showButtons(),
        ],
      ),
    );
  }

  Widget _showEmail() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        autofocus: true,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          errorText: _emailShowError ? _emailError : null,
          hintText: 'Ingresa tu email...',
          labelText: 'Email',
          prefixIcon: Icon(Icons.alternate_email),
          suffixIcon: Icon(Icons.email),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
        ),
        onChanged: (value) {
          setState(() {
            _email = value;
          });
        },
      ),
    );
  }

  Widget _showLogo() {
    return Image(
      image: AssetImage('assets/vehicles_logo.png'),
      width: 300,
    );
  }

  Widget _showPassword() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        obscureText: !_passwordShow,
        decoration: InputDecoration(
          errorText: _passwordShowError ? _passwordError : null,
          hintText: 'Ingresa tu contraseña...',
          labelText: 'Contraseña',
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: _passwordShow ? Icon(Icons.visibility): Icon(Icons.visibility_off), 
            onPressed: () {
              setState(() {
                _passwordShow = !_passwordShow;
              });
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          setState(() {
            _password = value;
          });
        },
      ),
    );
  }

  Widget _showRememberme() {
    return CheckboxListTile(
      title: Text('Recordarme'),
      value: _rememberme, 
      onChanged: (value) {
        setState(() {
          _rememberme = value!;
        });
      }
    );
  }

  Widget _showButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                  return Colors.blue;
              },
            ),
          ),
          child: Text('Iniciar Sesión'),
          onPressed: () {
            _login();
          }, 
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                  return Colors.green;
              },
            ),
          ),
          child: Text('Registrar Nuevo Usuario'),
          onPressed: () {}, 
        ),
      ],
    );
  }

  void _login() {
    setState(() {
      _passwordShow = false;
    });

    if (!_validateFields()) {
      return;
    }
  }

  bool _validateFields() {
    bool hasErrors = false;

    if (_email.isEmpty) {
      _emailShowError = true;
      _emailError = 'Debes ingresar tu correo.';
      hasErrors = true;
    } else if (!EmailValidator.validate(_email)){
      _emailShowError = true;
      _emailError = 'Debes ingresar un correo válido.';
      hasErrors = true;
    } else {  
      _emailShowError = false;
    }

    if (_password.isEmpty) {
      _passwordShowError = true;
      _passwordError = 'Debes ingresar tu contraseña.';
      hasErrors = true;
    } else {  
      _passwordShowError = false;
    }

    setState(() { });
    return hasErrors;
  }
}