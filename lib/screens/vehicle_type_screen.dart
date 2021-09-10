import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';

import 'package:vehicles_prep/components/loader_component.dart';
import 'package:vehicles_prep/helpers/api_Helper.dart';
import 'package:vehicles_prep/hubs/response.dart';
import 'package:vehicles_prep/hubs/token_hub.dart';
import 'package:vehicles_prep/hubs/vehicle_type.dart';

class VehicleTypeScreen extends StatefulWidget {
  final TokenHub tokenHub;
  final VehicleType vehicleType;

  VehicleTypeScreen({required this.tokenHub, required this.vehicleType});

  @override
  _VehicleTypeScreenState createState() => _VehicleTypeScreenState();
}

class _VehicleTypeScreenState extends State<VehicleTypeScreen> {
  String _description = '';
  String _descriptionError = '';
  bool _descriptionShowError = false;  
  TextEditingController _descriptionController = TextEditingController();

  bool _showLoader = false;

  @override
  void initState() {
    super.initState();
    _description = widget.vehicleType.description;
    _descriptionController.text = _description;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vehicleType.id == 0 ? "Nuevo Tipo de Vehiculo" : widget.vehicleType.description),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              _showDescription(),
              _showButtons(),
            ],
          ),
          _showLoader ? LoaderComponent(text: 'Por favor espere...') : Container(),
        ],
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
          widget.vehicleType.id == 0 ? Container() : SizedBox(width: 10,),
          widget.vehicleType.id == 0 ? Container() : Expanded(
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

    if (widget.vehicleType.id == 0) {
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

    setState(() { });
    return isValid;
  }

  void _saveRecord() async {
    setState(() {
      _showLoader = true;
    });

    Map<String, dynamic> request = {
      'id' : widget.vehicleType.id,
      'description' : _description,
    };

    Response response = await ApiHelper.put('/api/VehicleTypes/', widget.vehicleType.id, request, widget.tokenHub.token);

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
    };

    Response response = await ApiHelper.post('/api/VehicleTypes/', request, widget.tokenHub.token);

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

    Response response = await ApiHelper.delete('/api/VehicleTypes/', widget.vehicleType.id, widget.tokenHub.token);

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