import 'dart:convert';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:vehicles_prep/components/loader_component.dart';
import 'package:vehicles_prep/helpers/constans.dart';
import 'package:vehicles_prep/hubs/brand.dart';
import 'package:vehicles_prep/hubs/token_hub.dart';
import 'package:vehicles_prep/screens/brand_screen.dart';

class BrandsScreen extends StatefulWidget {
  final TokenHub tokenHub;

  BrandsScreen({required this.tokenHub});

  @override
  _BrandsScreenState createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {
  List<Brand> _brands = [];
  bool _isLoading = true;
  String _search = '';
  bool _isFiltered = false;

  @override
  void initState() {
    super.initState();
    _getBrands();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marcas'),
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
                  builder: (context) => BrandScreen(
                    tokenHub: widget.tokenHub, 
                    brand: Brand(description: '', id: 0),
                  )
                )
              );
        },
      ),
    );
  }

  Future<Null> _getBrands() async {
    var url = Uri.parse('${Constans.apiUrl}/api/Brands');
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

    _brands = [];
    dynamic decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        _brands.add(Brand.fromJson(item));  
      }
    }
    _isLoading = false;
    setState(() { });
  }

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getBrands,
      child: ListView(
        children: _brands.map((e) {
          return Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => BrandScreen(
                      tokenHub: widget.tokenHub, 
                      brand: e,
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
          ? 'No hay marcas con ese criterio de búsqueda' 
          : 'No hay marcas registrados.', 
        style: TextStyle(
          fontSize: 16, 
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _getContent() {
    return _brands.length == 0 
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
          title: Text('Filtar Marca'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Escriba las primeras letras de la marca que desea filtar'),
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

    List<Brand> filteredBrands = [];
    for (var brand in _brands) {
      if (brand.description.toLowerCase().contains(_search.toLowerCase())) {
        filteredBrands.add(brand);
      }
    }
    setState(() {
      _brands = filteredBrands;
      _isFiltered = true;
    });
    Navigator.of(context).pop();
  }

  void _removeFilter() {
    _isFiltered = false;
    _getBrands();
  }
}