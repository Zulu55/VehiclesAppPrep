import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';

import 'package:vehicles_prep/components/loader_component.dart';
import 'package:vehicles_prep/helpers/api_Helper.dart';
import 'package:vehicles_prep/hubs/procedure_hub.dart';
import 'package:vehicles_prep/hubs/response.dart';
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

    Response response = await ApiHelper.put('/api/Procedures/', widget.procedure.id, request, widget.tokenHub.token);

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

    Map<String, dynamic> request = {
      'description' : _description,
      'price': double.parse(_price)
    };

    Response response = await ApiHelper.post('/api/Procedures/', request, widget.tokenHub.token);

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

    Response response = await ApiHelper.delete('/api/Procedures/', widget.procedure.id, widget.tokenHub.token);

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
}