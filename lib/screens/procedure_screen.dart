import 'dart:convert';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:vehicles_prep/components/loader_component.dart';
import 'package:vehicles_prep/helpers/constans.dart';
import 'package:vehicles_prep/hubs/procedure_hub.dart';
import 'package:vehicles_prep/hubs/token_hub.dart';

class ProcedureScreen extends StatefulWidget {
  final TokenHub tokenHub;
  final Procedure procedure;

  ProcedureScreen({required this.tokenHub, required this.procedure});

  @override
  _ProcedureScreenState createState() => _ProcedureScreenState();
}

class _ProcedureScreenState extends State<ProcedureScreen> {
  String _description = '';
  String _descriptionError = '';
  bool _descriptionShowError = false;  
  TextEditingController _descriptionController = TextEditingController();

  String _price = '';
  String _priceError = '';
  bool _priceShowError = false;  
  TextEditingController _priceController = TextEditingController();

  bool _showLoader = false;

  @override
  void initState() {
    super.initState();
    _description = widget.procedure.description;
    _descriptionController.text = _description;
    _price = widget.procedure.price.toString();
    _priceController.text = _price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.procedure.id == 0 ? "Nuevo Procedimiento" : widget.procedure.description),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              _showDescription(),
              _showPrice(),
              _showButtons(),
            ],
          ),
          _showLoader ? LoaderComponent(text: 'Por favor espere...') : Container(),
        ],
      ),
    );
  }

  Widget _showPrice() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
        controller: _priceController,
        decoration: InputDecoration(
          errorText: _priceShowError ? _priceError : null,
          hintText: 'Ingresa un precio...',
          labelText: 'Precio',
          suffixIcon: Icon(Icons.attach_money),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
        ),
        onChanged: (value) {
          setState(() {
            _price = value;
          });
        },
      ),
    );
  }

  Widget _showDescription() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        autofocus: true,
        controller: _descriptionController,
        decoration: InputDecoration(
          errorText: _descriptionShowError ? _descriptionError : null,
          hintText: 'Ingresa una descripción...',
          labelText: 'Descripción',
          suffixIcon: Icon(Icons.description),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
        ),
        onChanged: (value) {
          setState(() {
            _description = value;
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
          widget.procedure.id == 0 ? Container() : SizedBox(width: 10,),
          widget.procedure.id == 0 ? Container() : Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                      return Color(0xFFE21717);
                  },
                ),
              ),
              child: Text('Eliminar'),
              onPressed: () {}, 
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

    if (widget.procedure.id == 0) {
      _addRecord();
    } else {
      _saveRecord();
    }
  }

  bool _validateFields() {
    bool isValid = true;

    if (_description.isEmpty) {
      _descriptionShowError = true;
      _descriptionError = 'Debes ingresar una descripción.';
      isValid = false;
    } else {  
      _descriptionShowError = false;
    }

    double price = double.parse(_price);
    if (price <= 0) {
      _priceShowError = true;
      _priceError = 'Debes ingresar un precio mayor a cero.';
      isValid = false;
    } else {  
      _priceShowError = false;
    }

    setState(() { });
    return isValid;
   }

  void _saveRecord() async {
    setState(() {
      _showLoader = true;
    });

    Map<String, dynamic> request = {
      'id' : widget.procedure.id,
      'description' : _description,
      'price': double.parse(_price)
    };

    var url = Uri.parse('${Constans.apiUrl}/api/Procedures/${widget.procedure.id}');
    var response = await http.put(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization': 'bearer ${widget.tokenHub.token}',
      }, 
      body: jsonEncode(request)
    );

    setState(() {
      _showLoader = false;
    });

    if (response.statusCode >= 400) {
      String error = response.body;
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: error,
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

    Map<String, dynamic> request = {
      'description' : _description,
      'price': double.parse(_price)
    };

    var url = Uri.parse('${Constans.apiUrl}/api/Procedures');
    var response = await http.post(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization': 'bearer ${widget.tokenHub.token}',
      }, 
      body: jsonEncode(request)
    );

    setState(() {
      _showLoader = false;
    });

    if (response.statusCode >= 400) {
      String error = response.body;
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: error,
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

    Navigator.pop(context);
  }
}