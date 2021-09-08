import 'dart:convert';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:vehicles_prep/components/loader_component.dart';
import 'package:vehicles_prep/helpers/constans.dart';
import 'package:vehicles_prep/hubs/token_hub.dart';
import 'package:vehicles_prep/hubs/vehicle_type.dart';
import 'package:vehicles_prep/screens/vehicle_type_screen.dart';

class VehicleTypesScreen extends StatefulWidget {
  final TokenHub tokenHub;

  VehicleTypesScreen({required this.tokenHub});

  @override
  _VehicleTypesScreenState createState() => _VehicleTypesScreenState();
}

class _VehicleTypesScreenState extends State<VehicleTypesScreen> {
  List<VehicleType> _vehicleTypes = [];
  bool _isLoading = true;
  String _search = '';
  bool _isFiltered = false;

  @override
  void initState() {
    super.initState();
    _getVehicleTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tipos de Vehículos'),
        actions: <Widget>[
          _isFiltered 
          ? IconButton(
              icon: Icon(Icons.filter_none),
              onPressed: _removeFilter,
            )
          : IconButton(
              icon: Icon(Icons.filter_alt),
              onPressed: _showFilter,
            ), 
        ],
      ),
      body: _isLoading ? LoaderComponent(text: 'Por favor espere...') : _getContent(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {  
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => VehicleTypeScreen(
                    tokenHub: widget.tokenHub, 
                    vehicleType: VehicleType(description: '', id: 0),
                  )
                )
              );
        },
      ),
    );
  }

  Future<Null> _getVehicleTypes() async {
    var url = Uri.parse('${Constans.apiUrl}/api/VehicleTypes');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept'       : 'application/json',
        'authorization': 'bearer ${widget.tokenHub.token}',
      }, 
    );

    String body = response.body;
    if (response.statusCode >= 400) {
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: body,
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

    _vehicleTypes = [];
    dynamic decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        _vehicleTypes.add(VehicleType.fromJson(item));  
      }
    }
    _isLoading = false;
    setState(() { });
  }

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getVehicleTypes,
      child: ListView(
        children: _vehicleTypes.map((e) {
          return Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => VehicleTypeScreen(
                      tokenHub: widget.tokenHub, 
                      vehicleType: e,
                    )
                  )
                );
              },
              child: Hero(
                tag: e.id,
                child: Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e.description, 
                            style: TextStyle(
                              fontSize: 18
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _noContent() {
    return Center(
      child: Text(
        _isFiltered 
          ? 'No hay tipos de vehículo con ese criterio de búsqueda' 
          : 'No hay tipos de vehículo registrados.', 
        style: TextStyle(
          fontSize: 16, 
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _getContent() {
    return _vehicleTypes.length == 0 
      ? _noContent() 
      : _getListView();
  }

  void _showFilter() {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          title: Text('Filtar Tipo de Vehículo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Escriba las primeras letras del tipo de vehículo que desea filtar'),
              SizedBox(height: 10,),
              TextField(
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Criterio de búsqueda...',
                  labelText: 'Buscar',
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    _search = value;
                  });
                },
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),            
            TextButton(
              onPressed: () => _filter(),
              child: Text('Ok'),
            ),            
          ],
        );
      }
    );
  }

  void _filter() {
    if (_search.isEmpty) {
      return;
    }

    List<VehicleType> filteredVehicleTypes = [];
    for (var vehicleType in _vehicleTypes) {
      if (vehicleType.description.toLowerCase().contains(_search.toLowerCase())) {
        filteredVehicleTypes.add(vehicleType);
      }
    }
    setState(() {
      _vehicleTypes = filteredVehicleTypes;
      _isFiltered = true;
    });
    Navigator.of(context).pop();
  }

  void _removeFilter() {
    _isFiltered = false;
    _getVehicleTypes();
  }
}