import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'package:vehicles_prep/components/loader_component.dart';
import 'package:vehicles_prep/helpers/api_Helper.dart';
import 'package:vehicles_prep/hubs/document_type.dart';
import 'package:vehicles_prep/hubs/response.dart';
import 'package:vehicles_prep/hubs/token_hub.dart';
import 'package:vehicles_prep/hubs/user.dart';

class UserScreen extends StatefulWidget {
  final TokenHub tokenHub;
  final User user;

  UserScreen({required this.tokenHub, required this.user});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String _firstName = '';
  String _firstNameError = '';
  bool _firstNameShowError = false;  
  TextEditingController _firstNameController = TextEditingController();

  String _lastName = '';
  String _lastNameError = '';
  bool _lastNameShowError = false;  
  TextEditingController _lastNameController = TextEditingController();

  DocumentType _documentType = DocumentType(description: '', id: 0);
  List<DocumentType> _documentTypes = [];

  String _document = '';
  String _documentError = '';
  bool _documentShowError = false;  
  TextEditingController _documentController = TextEditingController();

  String _address = '';
  String _addressError = '';
  bool _addressShowError = false;  
  TextEditingController _addressController = TextEditingController();

  String _email = '';
  String _emailError = '';
  bool _emailShowError = false;  
  TextEditingController _emailController = TextEditingController();

  String _phoneNumber = '';
  String _phoneNumberError = '';
  bool _phoneNumberShowError = false;  
  TextEditingController _phoneNumberController = TextEditingController();

  bool _showLoader = false;

  @override
  void initState() {
    super.initState();
    _getDocumentTypes();

    _firstName = widget.user.firstName;
    _firstNameController.text = _firstName;

    _lastName = widget.user.lastName;
    _lastNameController.text = _lastName;

    _documentType = widget.user.documentType;

    _document = widget.user.document;
    _documentController.text = _document;

    _address = widget.user.address;
    _addressController.text = _address;

    _email = widget.user.email;
    _emailController.text = _email;

    _phoneNumber = widget.user.phoneNumber;
    _phoneNumberController.text = _phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.id.isEmpty ? "Nuevo Usuario" : widget.user.fullName),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _showFirstName(),
                _showLastName(),
                _showDocumentType(),
                _showDocument(),
                _showAddress(),
                _showEmail(),
                _showPhoneNumber(),
                _showButtons(),
              ],
            ),
          ),
          _showLoader ? LoaderComponent(text: 'Por favor espere...') : Container(),
        ],
      ),
    );
  }

  Widget _showFirstName() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        autofocus: true,
        controller: _firstNameController,
        decoration: InputDecoration(
          errorText: _firstNameShowError ? _firstNameError : null,
          hintText: 'Ingresa nombres del usuario...',
          labelText: 'Nombres',
          suffixIcon: Icon(Icons.person),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
        ),
        onChanged: (value) {
          setState(() {
            _firstName = value;
          });
        },
      ),
    );
  }

  Widget _showLastName() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _lastNameController,
        decoration: InputDecoration(
          errorText: _lastNameShowError ? _lastNameError : null,
          hintText: 'Ingresa apellidos del usuario...',
          labelText: 'Apellidos',
          suffixIcon: Icon(Icons.person),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
        ),
        onChanged: (value) {
          setState(() {
            _lastName = value;
          });
        },
      ),
    );
  }

  Widget _showDocumentType() {
    return Container();
  }

  Widget _showDocument() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _documentController,
        decoration: InputDecoration(
          errorText: _documentShowError ? _documentError : null,
          hintText: 'Ingresa documento del usuario...',
          labelText: 'Documento',
          suffixIcon: Icon(Icons.assignment_ind),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
        ),
        onChanged: (value) {
          setState(() {
            _document = value;
          });
        },
      ),
    );
  }

  Widget _showAddress() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.streetAddress,
        controller: _addressController,
        decoration: InputDecoration(
          errorText: _addressShowError ? _addressError : null,
          hintText: 'Ingresa dirección del usuario...',
          labelText: 'Dirección',
          suffixIcon: Icon(Icons.home),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
        ),
        onChanged: (value) {
          setState(() {
            _address = value;
          });
        },
      ),
    );
  }

  Widget _showEmail() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        controller: _emailController,
        decoration: InputDecoration(
          errorText: _emailShowError ? _emailError : null,
          hintText: 'Ingresa email del usuario...',
          labelText: 'Email',
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

  Widget _showPhoneNumber() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.phone,
        controller: _phoneNumberController,
        decoration: InputDecoration(
          errorText: _phoneNumberShowError ? _phoneNumberError : null,
          hintText: 'Ingresa teléfono del usuario...',
          labelText: 'Teléfono',
          suffixIcon: Icon(Icons.phone),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
        ),
        onChanged: (value) {
          setState(() {
            _phoneNumber = value;
          });
        },
      ),
    );
  }

  Widget _showButtons() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                      return Color(0xFF4DD637);
                  },
                ),
              ),
              child: Text('Guardar'),
              onPressed: () => _save(), 
            ),
          ),
          widget.user.id.isEmpty ? Container() : SizedBox(width: 10,),
          widget.user.id.isEmpty ? Container() : Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                      return Color(0xFFE21717);
                  },
                ),
              ),
              child: Text('Eliminar'),
              onPressed: () => _confirmDelete(), 
            ),
          ),
        ],
      ),
    );
  }

  void _save() {
    if (!_validateFields()) {
      return;
    }

    if (widget.user.id == '') {
      _addRecord();
    } else {
      _saveRecord();
    }
  }

  bool _validateFields() {
    bool isValid = true;

    if (_firstName.isEmpty) {
      _firstNameShowError = true;
      _firstNameError = 'Debes ingresar al menos un nombre.';
      isValid = false;
    } else {  
      _firstNameShowError = false;
    }

    if (_lastName.isEmpty) {
      _lastNameShowError = true;
      _lastNameError = 'Debes ingresar al menos un apellido.';
      isValid = false;
    } else {  
      _lastNameShowError = false;
    }

    if (_document.isEmpty) {
      _documentShowError = true;
      _documentError = 'Debes ingresar el documento.';
      isValid = false;
    } else {  
      _addressShowError = false;
    }

    if (_address.isEmpty) {
      _addressShowError = true;
      _addressError = 'Debes ingresar la dirección.';
      isValid = false;
    } else {  
      _addressShowError = false;
    }

    if (_email.isEmpty) {
      _emailShowError = true;
      _emailError = 'Debes ingresar un email.';
      isValid = false;
    } else if (!EmailValidator.validate(_email)){
      _emailShowError = true;
      _emailError = 'Debes ingresar un correo válido.';
      isValid = false;
    } else {  
      _emailShowError = false;
    }

    if (_phoneNumber.isEmpty) {
      _phoneNumberShowError = true;
      _phoneNumberError = 'Debes ingresar la dirección.';
      isValid = false;
    } else {  
      _phoneNumberShowError = false;
    }

    setState(() { });
    return isValid;
   }

  void _saveRecord() async {
    setState(() {
      _showLoader = true;
    });

    //TODO: pending to change the document type and the image
    Map<String, dynamic> request = {
      'id' : widget.user.id,
      'firstName' : _firstName,
      'lastName' : _lastName,
      'documentType' : 1, 
      'document' : _document,
      'address' : _address,
      'userType' : 1,
      'userName' : _email,
      'email' : _email,
      'phoneNumber' : _phoneNumber,
    };

    Response response = await ApiHelper.put(
      '/api/Users/', 
      widget.user.id, 
      request, 
      widget.tokenHub.token
    );

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: response.message,
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

    Navigator.pop(context);
  }

  void _addRecord() async {
    setState(() {
      _showLoader = true;
    });

    //TODO: pending to change the document type and the image
    Map<String, dynamic> request = {
      'firstName' : _firstName,
      'lastName' : _lastName,
      'documentType' : 1, 
      'document' : _document,
      'address' : _address,
      'userType' : 1,
      'userName' : _email,
      'email' : _email,
      'phoneNumber' : _phoneNumber,
    };

    Response response = await ApiHelper.post('/api/Users/', request, widget.tokenHub.token);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: response.message,
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

    Navigator.pop(context);
  }

  void _confirmDelete() async {
      var response = await showAlertDialog(
        context: context,
        title: 'Confirmación', 
        message: '¿Estas seguro de querer borrar el regitro?',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: 'yes', label: 'Yes'),
            AlertDialogAction(key: 'no', label: 'No'),
        ]
      );    

      if (response == 'yes') {
        _deleteRecord();
      }

  }

  void _deleteRecord() async {
    setState(() {
      _showLoader = true;
    });

    Response response = await ApiHelper.delete('/api/Users/', widget.user.id, widget.tokenHub.token);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: response.message,
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

    Navigator.pop(context);
  }

  Future<Null> _getDocumentTypes() async {
    setState(() {
      _showLoader = true;
    });

    Response response = await ApiHelper.getDocumentTypes(widget.tokenHub.token);

    setState(() {
      _showLoader = false;
    });
    
    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: response.message,
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

    _documentTypes = response.result;
  }
}